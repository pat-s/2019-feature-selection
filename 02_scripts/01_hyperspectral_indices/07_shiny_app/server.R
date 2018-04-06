library(shiny)
library(mapview)
library(sf)
library(magrittr)
library(raster)
library(glue)
library(viridis)
library(rasterVis)
library(hrbrthemes)
library(dplyr)
library(purrr)
library(ggplot2)

server <- shinyServer(function(input, output, session) {

  # for levelplot()
  lattice.options(
    layout.heights = list(bottom.padding = list(x = 0), top.padding = list(x = 0)),
    layout.widths = list(left.padding = list(x = 0), right.padding = list(x = 0))
  )

  input_reactive_index <- reactive({
    input$index
  })

  input_reactive_plot1 <- reactive({
    input$plot
  })
  input_reactive_plot2 <- reactive({
    input$plot2
  })

  input_reactive_index <- reactive({
    input$index
  })

  # create ras* outside the render() function
  ras1 <- reactive({
    brick(glue("/data/patrick/mod/hyperspectral/all-veg-indices/{name}.grd",
      name = input_reactive_plot1()
    ))[[input_reactive_index()]] %>%
      projectRaster(crs = "+proj=longlat +datum=WGS84 +no_defs")
  })

  ras2 <- reactive({
    brick(glue("/data/patrick/mod/hyperspectral/all-veg-indices/{name}.grd",
      name = input_reactive_plot2()
    ))[[input_reactive_index()]] %>%
      projectRaster(crs = "+proj=longlat +datum=WGS84 +no_defs")
  })

  # study_area <- st_read("/data/patrick/raw/boundaries/basque-country/Study_area_new.shp",
  #                       quiet = TRUE
  # )

  plot_boundaries <- st_read("/data/patrick/mod/plots/location/all.plots.shp",
    quiet = TRUE
  ) %>%
    st_transform(4326) %>%
    arrange(Name) %>%
    # mutate(Name = as.character(Name)) %>%
    mutate(Name = recode(Name,
      "aguinaga pinaster radiata" = "aguinaga-pinaster-radiata",
      "a altube" = "altube", "a azaceta" = "azaceta",
      "a barazar" = "barazar", "a busturi-axpe" = "busturi",
      "a caranca" = "caranca", "douglas 1" = "douglas-1",
      "douglas 2" = "douglas-2", "Douglas Albiztur" = "douglas-albiztur",
      "Douglas Legutio" = "douglas-legutio", "a gipuzkoa" = "gipuzkoa",
      "Laricio defol. Urkiola." = "laricio-defol-urkiola",
      "Laricio defol. Olaeta. pol" = "laricio-defol-olaeta",
      "Laricio defol.Gatzaga" = "laricio-gatzaga",
      "Laukiz I" = "laukiz1",
      "Laukiz II" = "laukiz2", "Laukiz III" = "laukiz3",
      "Ayala/Aiara" = "luiando", "Oiartzun" = "oiartzun",
      "a oxtandio" = "otxandio", "Picea Abornicano" = "picea-abornicano",
      "Pinas. Santa Koloma" = "pinas-santa-koloma",
      "Pinast. Arza" = "pinast-arza", "Rad. Altube" = "rad-altube",
      "Rad. Menagaray 1" = "rad-menagaray-1", "Rad. Menagaray 2" = "rad-menagaray-2",
      "Sequoia Legorreta" = "sequoia-legorreta", "Silvest. Nograro" = "silvest-nograro"
    ))

  output$boxplot <- renderPlot({
    raster_val <- map(list(ras1(), ras2()), ~ getValues(.x))

    raster_val_tbl <- tibble(
      Value = append(
        raster_val[[1]],
        raster_val[[2]]
      ),
      Plot = factor(c(
        rep(
          "Plot 1",
          length(raster_val[[1]])
        ),
        rep(
          "Plot 2",
          length(raster_val[[2]])
        )
      ))
    ) %>%
      na.omit()

    ggplot(raster_val_tbl, aes(y = Value, x = Plot, fill = Plot)) +
      geom_boxplot(width = 0.2) +
      guides(fill = FALSE) +
      scale_fill_manual(values = c("#FDE725", "#1F9A8A")) +
      theme_ipsum_rc(
        base_size = 20,
        axis_title_size = 20
      )
  })

  output$leaflet <- renderLeaflet({
    plot_boundary1 <- plot_boundaries %>%
      dplyr::filter(Name == input_reactive_plot1())

    plot_boundary2 <- plot_boundaries %>%
      dplyr::filter(Name == input_reactive_plot2())

    leaflet() %>%
      addTiles() %>%
      addProviderTiles(input$bmap) %>%
      # addPolylines(data = study_area, opacity = 1, color = "black") %>% # basque country outline
      addPolylines(data = plot_boundary1, opacity = 1, color = "#FDE725") %>%
      addPolylines(data = plot_boundary2, opacity = 1, color = "#1F9A8A") %>%
      addLegend(
        colors = c("#FDE725", "#1F9A8A"), labels = c(
          "Plot 1 location",
          "Plot 2 location"
        ),
        opacity = 1
      )
  })

  output$veg_index <- renderPlot({
    ras_all <- list(ras1(), ras2())

    # calculate absolute min and max of both selected plots to display only one color bar
    min <- map_dbl(ras_all, ~ minValue(.x)) %>%
      min()
    max <- map_dbl(ras_all, ~ maxValue(.x)) %>%
      max()

    plot1 <- levelplot(ras1(),
      pretty = TRUE,
      col.regions = viridis,
      at = seq(min, max, len = 100)
    )

    plot2 <- levelplot(ras2(),
      pretty = TRUE,
      col.regions = viridis,
      colorkey = NULL
    )

    gridExtra::grid.arrange(plot1, plot2, ncol = 1)
  })

  url <- a("Formulas of indices (link)",
           href = "https://cran.r-project.org/web/packages/hsdar/hsdar.pdf",
           style = "padding: 20px")
  output$tab <- renderUI({
    tagList(url)
  })

  output$img <- renderImage({
    list(src = "life-healthy-forest.jpg")
  })
})

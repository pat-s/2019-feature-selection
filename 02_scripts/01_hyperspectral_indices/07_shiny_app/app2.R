library(shiny)
library(mapview)
library(leaflet)
library(sp)
library(shinydashboard)

header <- dashboardHeader(title = "Healthy Forest")

sidebar <- dashboardSidebar(
  selectInput(
    "plot", "Plot 1",
    selected = "laukiz1",
    c(
      "Aguinaga Pinaster Radiata" = "aguinaga-pinaster-radiata",
      "Altube" = "altube", "Azaceta" = "azaceta",
      "Barazar" = "barazar",
      "Busturi" = "busturi",
      "Caranca" = "caranca",
      "Douglas 1" = "douglas-1",
      "Douglas 2" = "douglas-2",
      "Douglas Albiztur" = "douglas-albiztur",
      "Douglas Legutio" = "douglas-legutio",
      "Gipuzkoa" = "gipuzkoa",
      "Laricio Defol Olaeta" = "laricio-defol-olaeta",
      "Laricio Defol Urkiola" = "laricio-defol-urkiola",
      "Laricio Gatzaga" = "laricio-gatzaga",
      "Laukiz1" = "laukiz1",
      "Laukiz2" = "laukiz2",
      "Laukiz3" = "laukiz3",
      "Luiando" = "luiando",
      "Oiartzun" = "oiartzun",
      "Otxandio" = "otxandio",
      "Picea Abornicano" = "picea-abornicano",
      "Pinas Santa Koloma" = "pinas-santa-koloma",
      "Pinast Arza" = "pinast-arza",
      "Rad Altube" = "rad-altube",
      "Rad Menagaray 1" = "rad-menagaray-1",
      "Rad Menagaray 2" = "rad-menagaray-2",
      "Sequoia Legorreta" = "sequoia-legorreta",
      "Silvest Nograro" = "silvest-nograro"
    )
  ),
  selectInput(
    "plot2", "Plot 2",
    selected = "luiando",
    c(
      "Aguinaga Pinaster Radiata" = "aguinaga-pinaster-radiata",
      "Altube" = "altube", "Azaceta" = "azaceta",
      "Barazar" = "barazar",
      "Busturi" = "busturi",
      "Caranca" = "caranca",
      "Douglas 1" = "douglas-1",
      "Douglas 2" = "douglas-2",
      "Douglas Albiztur" = "douglas-albiztur",
      "Douglas Legutio" = "douglas-legutio",
      "Gipuzkoa" = "gipuzkoa",
      "Laricio Defol Olaeta" = "laricio-defol-olaeta",
      "Laricio Defol Urkiola" = "laricio-defol-urkiola",
      "Laricio Gatzaga" = "laricio-gatzaga",
      "Laukiz1" = "laukiz1",
      "Laukiz2" = "laukiz2",
      "Laukiz3" = "laukiz3",
      "Luiando" = "luiando",
      "Oiartzun" = "oiartzun",
      "Otxandio" = "otxandio",
      "Picea Abornicano" = "picea-abornicano",
      "Pinas Santa Koloma" = "pinas-santa-koloma",
      "Pinast Arza" = "pinast-arza",
      "Rad Altube" = "rad-altube",
      "Rad Menagaray 1" = "rad-menagaray-1",
      "Rad Menagaray 2" = "rad-menagaray-2",
      "Sequoia Legorreta" = "sequoia-legorreta",
      "Silvest Nograro" = "silvest-nograro"
    )
  ),
  selectInput(
    "index", "Index",
    selected = "NDVI2",
    c(
      "Boochs" = "Boochs", "Boochs2" = "Boochs2",
      "CARI" = "CARI", "Carter" = "Carter",
      "Carter2" = "Carter2", "Carter3" = "Carter3",
      "Carter4" = "Carter4", "Carter5" = "Carter5",
      "Carter6" = "Carter6", "CI" = "CI",
      "CI2" = "CI2", "ClAInt" = "ClAInt",
      "CRI1" = "CRI1", "CRI2" = "CRI2", "CRI3" = "CRI3", "CRI4" = "CRI4",
      "D1" = "D1", "D2" = "D2", "Datt" = "Datt", "Datt2" = "Datt2",
      "Datt3" = "Datt3", "Datt4" = "Datt4", "Datt5" = "Datt5",
      "Datt6" = "Datt6", "DD" = "DD", "DDn" = "DDn",
      "DPI" = "DPI", "DWSI4" = "DWSI4", "EGFR" = "EGFR", "EVI" = "EVI",
      "GDVI_2" = "GDVI_2", "GDVI_3" = "GDVI_3", "GDVI_4" = "GDVI_4",
      "GI" = "GI", "Gitelson" = "Gitelson", "Gitelson2" = "Gitelson2",
      "GMI1" = "GMI1", "GMI2" = "GMI2", "Green NDVI" = "Green NDVI",
      "Maccioni" = "Maccioni", "MCARI" = "MCARI", "MCARI2" = "MCARI2",
      "mND705" = "mND705", "mNDVI" = "mNDVI", "MPRI" = "MPRI",
      "MSAVI" = "MSAVI", "mSR" = "mSR", "mSR2" = "mSR2",
      "mSR705" = "mSR705", "MTCI" = "MTCI", "MTVI" = "MTVI",
      "NDVI" = "NDVI", "NDVI2" = "NDVI2", "NDVI3" = "NDVI3",
      "NPCI" = "NPCI", "OSAVI" = "OSAVI", "PARS" = "PARS", "PRI" = "PRI",
      "PRI_norm" = "PRI_norm", "PRI*CI2" = "PRI*CI2",
      "PSRI" = "PSRI", "PSSR" = "PSSR", "PSND" = "PSND",
      "SPVI" = "SPVI", "PWI" = "PWI", "RDVI" = "RDVI", "REP_Li" = "REP_Li",
      "SAVI" = "SAVI", "SIPI" = "SIPI", "SPVI" = "SPVI", "SR" = "SR",
      "SR1" = "SR1", "SR2" = "SR2", "SR3" = "SR3", "SR4" = "SR4",
      "SR5" = "SR5", "SR6" = "SR6", "SR7" = "SR7",
      "SR8" = "SR8", "Sum_Dr1" = "Sum_Dr1", "Sum_Dr2" = "Sum_Dr2",
      "SRPI" = "SRPI", "TCARI" = "TCARI", "TCARI2" = "TCARI2",
      "TGI" = "TGI", "TVI" = "TVI", "Vogelmann" = "Vogelmann",
      "Vogelmann2" = "Vogelmann2", "Vogelmann3" = "Vogelmann3",
      "Vogelmann4" = "Vogelmann4"
    )
  )
)

body <- dashboardBody(
  # Define UI for application
  fluidPage(
    mainPanel(
      splitLayout(
        cellWidths = c("50%", "50%"),
        leafletOutput("mapplot", height = 450),
        plotOutput("mapplot_static", height = 450)
      ),
      splitLayout(
        cellWidths = c("50%", "50%"),
        leafletOutput("mapplot2", height=450),
        plotOutput("mapplot_static2", height=450)
      )
    )
  )
)

ui <- dashboardPage(header, sidebar, body, skin = "black")

library(shiny)
library(mapview)
library(sf)
library(magrittr)
library(raster)
library(glue)
library(viridis)
library(rasterVis)

server <- shinyServer(function(input, output, session) {

  lattice.options(
    layout.heights=list(bottom.padding=list(x=0), top.padding=list(x=0)),
    layout.widths=list(left.padding=list(x=0), right.padding=list(x=0))
  )

  input_reactive_index <- reactive({
    input$index
  })

  ras1 <- reactive({
    brick(glue("/data/patrick/mod/hyperspectral/all-veg-indices/{name}.grd",
                     name = input$plot))[[input_reactive_index()]] %>%
    projectRaster(crs = "+proj=longlat +datum=WGS84 +no_defs")
  })

  input_reactive_plot <- reactive({
    input$plot
  })
  input_reactive_plot2 <- reactive({
    input$plot2
  })

  input_reactive_index <- reactive({
    input$index
  })

  ras1 <- reactive({
    brick(glue("/data/patrick/mod/hyperspectral/all-veg-indices/{name}.grd",
               name = input_reactive_plot()))[[input_reactive_index()]] %>%
      projectRaster(crs = "+proj=longlat +datum=WGS84 +no_defs")
  })

  ras2 <- reactive({
    brick(glue("/data/patrick/mod/hyperspectral/all-veg-indices/{name}.grd",
               name = input_reactive_plot2()))[[input_reactive_index()]] %>%
      projectRaster(crs = "+proj=longlat +datum=WGS84 +no_defs")
  })

  study_area <- st_read("/data/patrick/raw/boundaries/basque-country/Study_area_new.shp",
    quiet = TRUE
  )

  plot_boundaries <- st_read("/data/patrick/mod/plots/location/all.plots.shp",
    quiet = TRUE
  ) %>%
    st_transform(4326) %>%
    arrange(Name) %>%
    # mutate(Name = as.character(Name)) %>%
    mutate(Name = recode(Name,
      "aguinaga pinaster radiata" = "aguinaga-pinaster-radiata",
      "a altube" = "altube", "a azaceta" = "azaceta",
      "a barazar" = "barazar", "a busturi" = "busturi",
      "a caranca" = "caranca", "douglas 1" = "douglas-1",
      "douglas 2" = "douglas-2", "Douglas Albiztur" = "douglas-albiztur",
      "Douglas Legutio" = "douglas-legutio", "a gipuzkoa" = "gipuzkoa", "laricio-defol-olaeta" = "laricio-defol-urkiola",
      "Laricio defol. Olaeta. pol" = "laricio-gatzaga", "Laukiz I" = "laukiz1",
      "Laukiz II" = "laukiz2", "Laukiz III" = "laukiz3",
      "Ayala/Aiara" = "luiando", "Oiartzun" = "oiartzun",
      "a oxtandio" = "otxandio", "Picea Abornicano" = "picea-abornicano",
      "Pinas. Santa Koloma" = "pinas-santa-koloma",
      "Pinast. Arza" = "pinast-arza", "Rad. Altube" = "rad-altube",
      "Rad. Menagaray 1" = "rad-menagaray-1", "Rad. Menagaray 2" = "rad-menagaray-2",
      "Sequoia Legorreta" = "sequoia-legorreta", "Silvest. Nograro" = "silvest-nograro"
    ))

  output$mapplot <- renderLeaflet({

    plot_boundary <- plot_boundaries %>%
    dplyr::filter(Name == input_reactive_plot())


    # leaflet(study_area) %>%
    #   addPolygons()

    leaflet() %>%
      addTiles() %>%
      addProviderTiles("Esri.WorldTopoMap") %>%
      # addRasterImage(ras_sel, project = FALSE) %>%
      addPolylines(data = study_area, opacity = 1, color = "black") %>%
      addPolylines(data = plot_boundary, opacity = 1, color = "red") %>%
      addLegend(
        colors = c("red", "black"), labels = c("Plot 1 location", "Basque Country"),
        opacity = 1
      )

    # m <- mapview(ras_grid, map.types = "OpenTopoMap") + study_area
    # m@map
  })

  output$mapplot2 <- renderLeaflet({

    plot_boundary <- plot_boundaries %>%
      dplyr::filter(Name == input_reactive_plot2())

    # leaflet(study_area) %>%
    #   addPolygons()

    leaflet() %>%
      addTiles() %>%
      addProviderTiles("Esri.WorldTopoMap") %>%
      # addRasterImage(ras_sel, project = FALSE) %>%
      addPolylines(data = study_area, opacity = 1, color = "black") %>%
      addPolylines(data = plot_boundary, opacity = 1, color = "red") %>%
      addLegend(
        colors = c("red", "black"), labels = c("Plot 2 location", "Basque Country"),
        opacity = 1
      )

    # m <- mapview(ras_grid, map.types = "OpenTopoMap") + study_area
    # m@map
  })
  output$mapplot_static <- renderPlot({

    ras_all = list(ras1(), ras2())

    min = map_dbl(ras_all, ~ minValue(.x)) %>%
      min()
    max = map_dbl(ras_all, ~ maxValue(.x)) %>%
      max()

    levelplot(ras1(), pretty = TRUE,
              col.regions = viridis,
              at = seq(min, max, len = 100))
  })

  output$mapplot_static2 <- renderPlot({

    ras_all = list(ras1(), ras2())

    min = map_dbl(ras_all, ~ minValue(.x)) %>%
      min()
    max = map_dbl(ras_all, ~ maxValue(.x)) %>%
      max()

    levelplot(ras2(), pretty = TRUE,
              col.regions = viridis,
              colorkey = NULL)
  })

  #  output$mapplot <- renderMapview(mapview(meuse.grid, zcol = input_reactive()) + meuse)
})

shinyApp(ui, server)

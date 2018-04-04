library(shiny)
library(mapview)
library(leaflet)
library(sp)

ui <- pageWithSidebar(

  # App title ----
  headerPanel("Input"),

  # Sidebar panel for inputs ----
  sidebarPanel(        # Input: Selector for variable to plot against mpg ----
                       selectInput("plot", "Plot:",
                                   c("Aguinaga Pinaster Radiata" = "aguinaga-pinaster-radiata",
                                   "Altube" = "altube", "Azaceta" = "azaceta",
                                   "Barazar" = "barazar",
                                   "Busturi = busturi",
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
                                   "Silvest Nograro" = "silvest-nograro")),
                       selectInput("index", "Index",
                                   c("Boochs" = "Boochs", "Boochs2" = "Boochs2",
                                     "CARI" = "CARI", "Carter" = "Carter",
                                     "Carter2" = "Carter2", "Carter3" = "Carter3",
                                     "Carter4" = "Carter4", "Carter5" = "Carter5",
                                     "Carter6" = "Carter6", "CI" = "CI"
                                     # "CI2" = "CI2", "ClAInt" = "ClAInt",
                                     # "CRI1" = "CRI1", "CRI2", "CRI3", "CRI4",
                                     # "D1", "D2",
                                     # "Datt", "Datt2", "Datt3", "Datt4", "Datt5", "Datt6", "DD", "DDn", "DPI", "DWSI4",
                                     # "EGFR", "EVI", "GDVI_2", "GDVI_3", "GDVI_4", "GI", "Gitelson",
                                     # "Gitelson2", "GMI1", "GMI2", "Green NDVI", "Maccioni", "MCARI",
                                     # "MCARI2", "mND705", "mNDVI", "MPRI", "MSAVI", "mSR",
                                     # "mSR2", "mSR705", "MTCI", "MTVI", "NDVI", "NDVI2", "NDVI3",
                                     # "NPCI", "OSAVI", "PARS", "PRI", "PRI_norm", "PRI*CI2", "PSRI",
                                     # "PSSR", "PSND","SPVI", "PWI", "RDVI", "REP_Li", "SAVI", "SIPI",
                                     # "SPVI","SR", "SR1", "SR2", "SR3", "SR4", "SR5", "SR6", "SR7",
                                     # "SR8", "Sum_Dr1", "Sum_Dr2", "SRPI", "TCARI", "TCARI2", "TGI", "TVI", "Vogelmann",
                                     # "Vogelmann2", "Vogelmann3", "Vogelmann4"
                                     )
                                   )),

  # Main panel for displaying outputs ----
  mainPanel(
    leafletOutput("mapplot"),
    mapview:::plainViewOutput("test"),
    plotOutput("mapplot_static")
  )
)


library(shiny)
library(mapview)
library(sf)
library(magrittr)
library(raster)
library(glue)
library(viridis)
library(rasterVis)

server <- shinyServer(function(input, output, session) {

  input_reactive_plot = reactive({
    input$plot
  })

  input_reactive_index = reactive({
    input$index
  })

  output$mapplot <- renderLeaflet({
    ras = brick(glue("/data/patrick/mod/hyperspectral/all-veg-indices/{name}.grd",
                      name = input_reactive_plot()))
    ras_sel = ras[[input_reactive_index()]]
    ras_grid = as(ras_sel, "SpatialPixelsDataFrame")

    m <- mapview(ras_grid, col.regions = viridis, legend = TRUE, layer.name = TRUE, map.types = "OpenTopoMap")
    m@map
  })

  output$mapplot_static <- renderPlot({
    ras = brick(glue("/data/patrick/mod/hyperspectral/all-veg-indices/{name}.grd",
                     name = input_reactive_plot()))
    ras_sel = ras[[input_reactive_index()]]

    levelplot(ras_sel, col.regions = viridis, pretty = TRUE)
  })

  #  output$mapplot <- renderMapview(mapview(meuse.grid, zcol = input_reactive()) + meuse)

})

shinyApp(ui, server)

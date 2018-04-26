library(shiny)
library(mapview)
library(leaflet)
library(sp)
library(shinydashboard)
library(glue)

header <- dashboardHeader(
  title = "LIFE Healthy Forest"
)

sidebar <- dashboardSidebar(
  sidebarMenu(
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
    ),
    uiOutput("tab"), # link to indices
    img(src = "life-healthy-forest.jpg", style = "width: 200px; padding: 20px"),
    br(), # linebreak
    img(src = "fsu.png", style = "width: 200px; padding: 20px")
  )
)

body <- dashboardBody(
  fluidRow(
    box(
      title = "Location information", width = 4, solidHeader = TRUE,
      status = "primary",
      leafletOutput("leaflet", height = 900),

      # get list with providers: dput(unlist(providers))
      absolutePanel(
        top = 55, left = 65, width = 170,
        selectInput("bmap", "Base map tile provider",
          choices = c(
            "OpenStreetMap", "OpenStreetMap.Mapnik", "OpenStreetMap.BlackAndWhite",
            "OpenStreetMap.DE", "OpenStreetMap.France", "OpenStreetMap.HOT",
            "OpenSeaMap", "OpenTopoMap", "Thunderforest", "Thunderforest.OpenCycleMap",
            "Thunderforest.Transport", "Thunderforest.TransportDark", "Thunderforest.SpinalMap",
            "Thunderforest.Landscape", "Thunderforest.Outdoors", "Thunderforest.Pioneer",
            "OpenMapSurfer", "OpenMapSurfer.Roads", "OpenMapSurfer.AdminBounds",
            "OpenMapSurfer.Grayscale", "Hydda", "Hydda.Full", "Hydda.Base",
            "Hydda.RoadsAndLabels", "MapBox", "Stamen", "Stamen.Toner", "Stamen.TonerBackground",
            "Stamen.TonerHybrid", "Stamen.TonerLines", "Stamen.TonerLabels",
            "Stamen.TonerLite", "Stamen.Watercolor", "Stamen.Terrain", "Stamen.TerrainBackground",
            "Stamen.TopOSMRelief", "Stamen.TopOSMFeatures", "Esri", "Esri.WorldStreetMap",
            "Esri.DeLorme", "Esri.WorldTopoMap", "Esri.WorldImagery", "Esri.WorldTerrain",
            "Esri.WorldShadedRelief", "Esri.WorldPhysical", "Esri.OceanBasemap",
            "Esri.NatGeoWorldMap", "Esri.WorldGrayCanvas", "OpenWeatherMap",
            "OpenWeatherMap.Clouds", "OpenWeatherMap.CloudsClassic", "OpenWeatherMap.Precipitation",
            "OpenWeatherMap.PrecipitationClassic", "OpenWeatherMap.Rain",
            "OpenWeatherMap.RainClassic", "OpenWeatherMap.Pressure", "OpenWeatherMap.PressureContour",
            "OpenWeatherMap.Wind", "OpenWeatherMap.Temperature", "OpenWeatherMap.Snow",
            "HERE", "HERE.normalDay", "HERE.normalDayCustom", "HERE.normalDayGrey",
            "HERE.normalDayMobile", "HERE.normalDayGreyMobile", "HERE.normalDayTransit",
            "HERE.normalDayTransitMobile", "HERE.normalNight", "HERE.normalNightMobile",
            "HERE.normalNightGrey", "HERE.normalNightGreyMobile", "HERE.basicMap",
            "HERE.mapLabels", "HERE.trafficFlow", "HERE.carnavDayGrey", "HERE.hybridDay",
            "HERE.hybridDayMobile", "HERE.pedestrianDay", "HERE.pedestrianNight",
            "HERE.satelliteDay", "HERE.terrainDay", "HERE.terrainDayMobile",
            "FreeMapSK", "MtbMap", "CartoDB", "CartoDB.Positron", "CartoDB.PositronNoLabels",
            "CartoDB.PositronOnlyLabels", "CartoDB.DarkMatter", "CartoDB.DarkMatterNoLabels",
            "CartoDB.DarkMatterOnlyLabels", "HikeBike", "HikeBike.HikeBike",
            "HikeBike.HillShading", "BasemapAT", "BasemapAT.basemap", "BasemapAT.grau",
            "BasemapAT.overlay", "BasemapAT.highdpi", "BasemapAT.orthofoto",
            "NASAGIBS", "NASAGIBS.ModisTerraTrueColorCR", "NASAGIBS.ModisTerraBands367CR",
            "NASAGIBS.ViirsEarthAtNight2012", "NASAGIBS.ModisTerraLSTDay",
            "NASAGIBS.ModisTerraSnowCover", "NASAGIBS.ModisTerraAOD", "NASAGIBS.ModisTerraChlorophyll",
            "NLS"
          ),
          selected = "Esri.WorldTopoMap"
        )
      )
    ),
    box(
      title = "Vegetation index", width = 4, solidHeader = TRUE, status = "primary",
      plotOutput("veg_index", height = 900)
    ),
    fluidRow(column(
      width = 4,
      box(
        title = "Boxplot comparison", width = NULL,
        solidHeader = TRUE, status = "primary",
        plotOutput("boxplot", height = 400)
      ),
      valueBox(
        width = NULL, subtitle = HTML(paste(
          "<b>Sensor:</b> Aisa EAGLE-II (airborne)",
          br(),
          "<b>Spatial resolution:</b> 1m",
          br(),
          "<b>Radiometric resolution:</b> 126 bands, 404 nm - 996 nm",
          br(),
          "<b>Correction:</b> Radiometric, geometric, atmospheric",
          br(),
          "<b>Acquisition date:</b> 29 - 30 September 2016"
        )), color = "black",
        value = "Metadata information", icon = icon("calendar")
      )
    )),

    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "shiny.css")
    )
  )
)

ui <- dashboardPage(header, sidebar, body, skin = "black")

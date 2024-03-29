#' @title Download data
#' @description
#' `download_trees()`: Download in-situ tree data
#' @importFrom curl curl_download
#' @importFrom sf st_read
#' @importFrom glue glue
#'
#' @template url
#' @name download
download_trees <- function(url) {
  if (!file.exists("data/gpkg/oiartzun.gpkg")) {
    curl::curl_download(url,
      destfile = glue::glue(tempdir(), "/trees.zip"), quiet = FALSE
    )
    unzip(glue::glue(tempdir(), "/trees.zip"), exdir = "data/gpkg")
  }

  files <- purrr::map(c("laukiz1", "laukiz2", "luiando", "oiartzun"), ~
  sf::st_read(glue::glue("data/gpkg/{.x}.gpkg"), quiet = TRUE))

  ### terra vect files cause an error when being saved to disk (with drake or otherwise)
  # https://github.com/rspatial/terra/issues/50
  # files <- purrr::map(c("laukiz1", "laukiz2", "luiando", "oiartzun"), ~
  # terra::vect(terra::pack(terra::vect(glue::glue("data/gpkg/{.x}.gpkg")))))

  return(files)
}

#' @title Download data
#' @description
#' `download_trees()`: Download in-situ tree data
#' @template url
#' @rdname download
download_aoi <- function(url) {
  if (!file.exists("data/gpkg/aoi.gpkg")) {
    curl::curl_download(url,
      destfile = "data/gpkg/aoi.gpkg", quiet = FALSE
    )
  }

  # files <- st_read("data/gpkg/aoi.gpkg")
  files <- sf::st_read("data/gpkg/aoi.gpkg")
  return(files)
}

#' @description
#' `download_locations()`: Download plot location vector data
#' @template url
#' @rdname download
download_locations <- function(url) {
  if (!file.exists("data/gpkg/plot-locations.gpkg")) {
    curl::curl_download(url,
      destfile = "data/gpkg/plot-locations.gpkg", quiet = FALSE
    )
  }

  # files <- st_read("data/gpkg/plot-locations.gpkg") %>%
  #   mutate(Name = as.character(ignore(Name)))
  files <- sf::st_read("data/gpkg/plot-locations.gpkg")
  return(files)
}

#' @description
#' `download_hyperspectral()`: Download hyperspectral data
#' @template url
#' @rdname download
download_hyperspectral <- function(url, paper = TRUE) {
  if (paper) {
    if (!file.exists("data/hyperspectral/paper/B103_P1P_A090F04_ATM_S.tif")) {
      curl::curl_download(url,
        destfile = glue::glue(tempdir(), "/hs.zip"), quiet = FALSE
      )
      unzip(glue::glue(tempdir(), "/hs.zip"),
        exdir = "data/hyperspectral/paper",
        junkpaths = TRUE
      )
    }

    files_tiff <- list.files("data/hyperspectral/paper", full.names = TRUE)
    files_keep <- c(
      "data/hyperspectral/paper/B103_P1P_A090F04_ATM_S.tif", # laukiz1 & laukiz2
      "data/hyperspectral/paper/B207_P1N_A090F08_ATM_S.tif", # luiando
      "data/hyperspectral/paper/B124_P1N_A091F01_ATM_S.tif" # oiartzun
    )
    files_diff <- setdiff(files_tiff, files_keep)
    fs::file_delete(files_diff)

    files <- purrr::map(
      list.files("data/hyperspectral/paper",
        full.names = TRUE, pattern = ".tif$"
      ),
      ~ raster::brick(.x)
    )
    if (!file.exists("data/hyperspectral/paper/122/B103_P1P_A090F04_ATM_S.tif")) {
      fs::dir_create("data/hyperspectral/paper/122")
      # we need to write them to disk to create a RasterBrick as follow up operations
      # only work with bricks

      names <- purrr::map_chr(files, ~ .x@file@name)

      purrr::walk2(files, names, ~ raster::subset(.x, 5:126,
        filename = sprintf("data/hyperspectral/paper/122/%s", basename(.y)),
        progress = "text", overwrite = TRUE
      ))
    }
    files <- purrr::map(
      list.files("data/hyperspectral/paper/122",
        full.names = TRUE, pattern = ".tif$"
      ),
      ~ raster::brick(.x)
    )
  } else {
    if (!file.exists("data/hyperspectral/all/B101_P1N_A090F03_ATM_S.tif")) {
      curl::curl_download(url,
        destfile = glue::glue(tempdir(), "/hs.zip"), quiet = FALSE
      )
      unzip(glue::glue(tempdir(), "/hs.zip"),
        exdir = "data/hyperspectral/all",
        junkpaths = TRUE
      )
    }

    files <- purrr::map(
      list.files("data/hyperspectral/all",
        full.names = TRUE, pattern = ".tif$"
      ),
      ~ raster::brick(.x)
    )
  }
  return(files)
}

#' @title Download data
#' @description
#' `download_forest_mask()`: Download the forest/non-forest mask.
#' @template url
#' @rdname download
download_forest_mask <- function(url) {
  if (!file.exists("data/sentinel/forest-mask.gpkg")) {
    curl::curl_download(url,
      destfile = "data/sentinel/forest-mask.gpkg", quiet = FALSE
    )
  }

  # files <- st_read("data/sentinel/forest-mask.gpkg")
  files <- sf::st_read("data/sentinel/forest-mask.gpkg")
  return(files)
}

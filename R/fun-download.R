download_trees = function(path) {
  if (!file.exists("data/gpkg/oiartzun.gpkg")) {
    curl_download(path,
                  destfile = glue(tempdir(), "/trees.zip"), quiet = FALSE)
    unzip(glue(tempdir(), "/trees.zip"), exdir = "data/gpkg")
  }

  files = map(c("laukiz1", "laukiz2", "luiando", "oiartzun"), ~
        st_read(glue("data/gpkg/{.x}.gpkg"), quiet = TRUE))
  return(files)
}

download_locations = function(path) {
  if (!file.exists("data/gpkg/all-plots.gpkg")) {
    curl_download(path,
                  destfile = "data/gpkg/all-plots.gpkg", quiet = FALSE)
  }

  files = st_read("data/gpkg/all-plots.gpkg") %>%
    mutate(Name = as.character(ignore(Name)))
  return(files)
}

download_hyperspectral = function(path) {
  if (!file.exists("data/hyperspectral/B101_P1N_A090F03_ATM_S.tif")) {
    curl_download(path,
                  destfile = glue(tempdir(), "/hs.zip"), quiet = FALSE)
      unzip(glue(tempdir(), "/hs.zip"), exdir = "data/hyperspectral/")
  }

  files = map(list.files("data/hyperspectral",
                         full.names = TRUE, pattern = ".tif$"),
              ~ stack(.x))
  return(files)
}

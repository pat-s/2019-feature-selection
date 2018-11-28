needs(data.table, magrittr, purrr, sf, pbmcapply, dplyr, future, furrr, glue)

data_vi_nri = map(c("laukiz1", "laukiz2", "luiando", "oiartzun"), ~
                    readRDS(glue("/data/patrick/mod/tree-per-tree/2016/{.x}/all-indices-{.x}_bf2.rda")))

data_bands = map(c("laukiz1", "laukiz2", "luiando", "oiartzun"), ~
                   readRDS(glue("/data/patrick/mod/tree-per-tree/2016/{.x}/all-bands-{.x}_bf2.rda")))

data_ls = list("vi_nri" = data_vi_nri, "bands" = data_bands)

plan(multiprocess, workers = 2)
future_iwalk(data_ls, ~ {

  # Clean NA ----------------------------------------------------------------

  # Remove columns with NA values and "ID" columns
  # Ref: https://stackoverflow.com/questions/41343900/remove-row-columns-with-any-all-nan-values/41343980#41343980
  # luiando has some NA obs that need to be removed, otherwise the whole column will be removed by `Filter()`
  # for the nri_vi stack 3 more bands are removed than for the "bands" only
  .x[[3]] %<>%
    na.omit()

  .x %<>%
    map(~ select(.x, -contains("_ID"))) %>%
    map(~ as.data.table(.x)) %>%
    #map(~ na.omit(.x)) %>% # some obs in luiando are NA after extraction
    map(~ select(.x, -tree.number, -decoloration, -canker, -diameter, -height)) %>%
    map(~ Filter(function(x) !any(is.na(x)), .x))

  # Extract coords ----------------------------------------------------------

  # Extract coordinates
  # The scaling of variables won't work with the `geom` column attached.
  # So we need to safe the coordinates, remove them and attach them afterwards again.
  # Coordinates are needed for the spatial partitioning during modeling.

  coords = map(.x, ~ st_as_sf(.x, crs = 32630)) %>%
    map(~ as.data.frame(st_coordinates(.x)))
  coords = saveRDS(coords, glue("/data/patrick/mod/hyperspectral/data_clean_with_indices/{.y}_clean_standardized_bf2-coords.rda"))
  .x %<>%
    map(~ st_as_sf(.x, crs = 32630)) %>%
    map(~ st_set_geometry(.x, NULL))


  # Standardize vars --------------------------------------------------------

  # data.table is so much faster than the tidyverse alternative
  .x %<>%
    pbmclapply(function(x) {
      cols = names(x)[2:length(names(x))]
      x[, (cols) := lapply(.SD, scale), .SDcols=cols]
    }, mc.cores = 4
    )

  saveRDS(.x, glue("/data/patrick/mod/hyperspectral/data_clean_with_indices/{.y}_clean_standardized_bf2.rda"))

})

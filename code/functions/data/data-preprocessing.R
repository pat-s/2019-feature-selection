remove_na = function(data) {
  # Remove columns with NA values and "ID" columns
  # Ref: https://stackoverflow.com/questions/41343900/remove-row-columns-with-any-all-nan-values/41343980#41343980
  # luiando has some NA obs that need to be removed, otherwise the whole column will be removed by `Filter()`
  # for the nri_vi stack 3 more bands are removed than for the "bands" only
  data[[3]] %<>%
    na.omit()

  data %<>%
    map(~ dplyr::select(data, -contains("_ID"))) %>%
    map(~ as.data.table(data)) %>%
    #map(~ na.omit(.x)) %>% # some obs in luiando are NA after extraction
    map(~ dplyr::select(data, -tree.number, -decoloration, -canker, -diameter, -height)) %>%
    map(~ Filter(function(x) !any(is.na(x)), data))

  data %<>%
    map(~ st_as_sf(data, crs = 32630)) %>%
    map(~ st_set_geometry(data, NULL))

  return(data)
}

# future_init = function(workers) {
#   do.call(future::plan, list(strategy = multiprocess, ... = workers))
# }

extract_coords = function(data, future_setting) {

  # Extract coords ----------------------------------------------------------

  # Extract coordinates
  # The scaling of variables won't work with the `geom` column attached.
  # So we need to safe the coordinates, remove them and attach them afterwards again.
  # Coordinates are needed for the spatial partitioning during modeling.

  coords = map(data, ~ st_as_sf(data, crs = 32630)) %>%
    map(~ as.data.frame(st_coordinates(data)))

  return(coords)
}

standardize = function(data) {
  data %<>%
    pbmclapply(function(x) {
      cols = names(x)[2:length(names(x))]
      x[, (cols) := lapply(.SD, scale), .SDcols=cols]
    }, mc.cores = 4
    )

  return(data)
}

mutate_defol = function(data) {

  data %<>%
    mutate(defoliation = case_when(.data$defoliation == 0 ~ 0.001,
                                   TRUE ~ as.numeric(defoliation)))
}

log_response = function(data, response) {

  data[[response]] = log(data[[response]])
  return(data)
}

split_in_feature_sets = function(data, set) {

  if (set == "nri") {
    data_split = data[["data_vi_nri"]] %>%
      select(matches("nri|defol"))
  } else if (set == "vi") {
    data_split = data[["data_vi_nri"]] %>%
      select(-matches("nri"))
  } else if (set == "bands") {
    data_split = data[["data_bands"]]
  }
  return(data_split)
}

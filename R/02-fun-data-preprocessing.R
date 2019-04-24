#' @title Data preprocessing
#' @description
#' `clean_single_plots()`:
#'   - Removes columns with `NA` values and cols containing `"ID"`
#'   - Removes the `sf` geometry column.
#'
#' @param data (`list`)\cr List containing multiple `data.frames`.
#' @details
#' # Remove columns with NA values and "ID" columns
# Ref: https://stackoverflow.com/questions/41343900/remove-row-columns-with-any-all-nan-values/41343980#41343980
#' @name data_preprocessing
#' @export

clean_single_plots = function(data) {

  data %<>%
    map(~ as_tibble(.x)) %<>%
    map(~ dplyr::select(.x, -contains("_ID"))) %>%
    map(~ dplyr::select(.x, -tree.number, -decoloration, -canker, -diameter, -height)) %>%
    map(~ select_if(.x, function(x) !any(is.na(x)))) # select all variables without NA

  data %<>%
    map(~ st_as_sf(.x, crs = 32630)) %>%
    map(~ st_set_geometry(.x, NULL))

  return(data)
}

#' @title extract_coords
#' @description
#'   Extracts coordinates from a list of `data.frames` containing X and Y coordinates
#'
#' @param data (`list`)\cr List containing multiple `data.frames`.
#' @return List of `data.frames` with X/Y information
#' @export
extract_coords = function(data) {

  coords = map(data, ~ st_as_sf(.x, crs = 32630)) %>%
    map(~ as.data.frame(st_coordinates(.x)))

  return(coords)
}

#' @title standardize
#' @importFrom pbmcapply pbmclapply
#' @description Standardizes all variables of a list of `data.frames` in
#'   parallel
#'
#' @param data (`list`)\cr List containing multiple `data.frames`.
#' @param cores (`integer`)\cr Number of cores
#' @return List of `data.frames` with standardized variables
#' @details Standardization applies from `2:length(names(data))`, so it is
#'   expected that the response is sorted first in the data.
#' @export
standardize = function(data, cores) {
  data %<>%
    pbmclapply(function(x) {
      cols = names(x)[2:length(names(x))]
      x[, (cols) := lapply(.SD, scale), .SDcols=cols]
    }, mc.cores = cores
    )

  return(data)
}

#' @title mutate_defol
#' @importFrom dplyr case_when
#' @description Mutates the "defoliation" variables so that no absolut zeros occur. These might cause problems when standardizing variables.
#'
#' @param data (`data.frame`)\cr data.frame.
#' @return `data.frame`
#' @export
mutate_defol = function(data) {

  data %<>%
    dplyr::mutate(defoliation = case_when(.data$defoliation == 0 ~ 0.001,
                                          TRUE ~ as.numeric(.data$defoliation))
    )
}

#' @title log_response
#' @description Performs a log transformation on the response variable.
#'
#' @param data (`data.frame`)\cr data.frame.
#' @param response (`character`)\cr Name of response.
#' @return `data.frame`
#' @export
log_response = function(data, response) {

  data[[response]] = log(data[[response]])
  return(data)
}

#' @title split_into_feature_sets
#' @importFrom dplyr select
#' @description Splits data into feature sets.
#'
#' @param data (`data.frame`)\cr data.frame.
#' @param feature_set (`character`)\cr Name of feature set.
#' @return `data.frame`
#' @export
split_into_feature_sets = function(data, feature_set) {

  if (feature_set == "nri") {
    data_split = data[["data_vi_nri"]] %>%
      dplyr::select(matches("nri|defol"))
  } else if (feature_set == "vi") {
    data_split = data[["data_vi_nri"]] %>%
      dplyr::select(-matches("nri"))
  } else if (feature_set == "bands") {
    data_split = data
  }
  return(data_split)
}

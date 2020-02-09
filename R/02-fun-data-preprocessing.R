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

clean_single_plots <- function(data, cols_to_drop, remove_coords = FALSE) {
  data %<>%
    map(~ as_tibble(.x)) %<>%
    map(~ dplyr::select(.x, -contains("_ID"))) %>%
    map(~ dplyr::select(.x, -one_of(cols_to_drop))) %>%
    map(~ select_if(.x, function(x) !any(is.na(x)))) # select all variables without NA

  if (remove_coords) {
    data %<>%
      map(~ st_as_sf(.x, crs = 32630, coords = c("x", "y"))) %>%
      map(~ st_set_geometry(.x, NULL))
  }

  return(data)
}

# @details
# some obs of laukiz2 are marked as "dead" and we have some doubts that these
# observations are valid since apparently some mistakes happened during data
# collection. We are removing these observations. The information about the
# affected tree IDs came from an external file
# remove_dead <- function(object) {
#   dead_trees <- c(
#     34, 54, 61, 63, 64, 67, 81, 93, 137, 1146, 1173, 1175, 207,
#     212, 243, 245, 246, 252, 253, 266, 274, 276, 277, 279, 280, 282,
#     283, 299, 301, 308, 311, 313, 315, 316, 333, 355, 357, 369, 380,
#     383, 384, 385, 387, 397, 408, 409, 410, 421, 434, 441, 461, 463
#   )
#   object[["laukiz2"]] %<>%
#     dplyr::filter(!tree.number %in% dead_trees)
#
#   return(object)
# }

#' @title extract_coords
#' @description
#'   Extracts coordinates from a list of `data.frames` containing X and Y coordinates
#'
#' @param data (`list`)\cr List containing multiple `data.frames`.
#' @return List of `data.frames` with X/Y information
#' @rdname data_preprocessing
#' @export
extract_coords <- function(data) {
  coords <- map(data, ~ st_as_sf(.x, crs = 32630)) %>%
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
#' @rdname data_preprocessing
#' @export
standardize <- function(data, cores) {
  data %<>%
    pbmclapply(function(x) {
      cols <- names(x)[2:length(names(x))]
      x[, (cols) := lapply(.SD, scale), .SDcols = cols]
    }, mc.cores = cores)

  return(data)
}

#' @title mutate_defol
#' @importFrom dplyr case_when
#' @description Mutates the "defoliation" variables so that no absolut zeros occur. These might cause problems when standardizing variables.
#'
#' @param data (`data.frame`)\cr data.frame.
#' @return `data.frame`
#' @rdname data_preprocessing
#' @export
mutate_defol <- function(data) {
  data %<>%
    dplyr::mutate(defoliation = case_when(
      .data$defoliation == 0 ~ 0.001,
      TRUE ~ as.numeric(.data$defoliation)
    ))
}

#' @title log_response
#' @description Performs a log transformation on the response variable.
#'
#' @param data (`data.frame`)\cr data.frame.
#' @param response (`character`)\cr Name of response.
#' @return `data.frame`
#' @rdname data_preprocessing
#' @export
log_response <- function(data, response) {
  data[[response]] <- log(data[[response]])
  return(data)
}

#' @title boxcox_response
#' @description Performs a boxcox transformation on the response variable.
#'
#' @param data (`data.frame`)\cr data.frame.
#' @param response (`character`)\cr Name of response.
#' @return `data.frame`
#' @rdname data_preprocessing
#' @export
boxcox_response <- function(data, response) {
  lambda <- 0.7878788
  data[[response]] <- (data[[response]]^lambda - 1) / lambda
  return(data)
}

#' @title split_into_feature_sets
#' @importFrom dplyr select
#' @description Splits data into feature sets.
#'
#' @param data (`data.frame`)\cr data.frame.
#' @param feature_set (`character`)\cr Name of feature set.
#' @return `data.frame`
#' @rdname data_preprocessing
#' @export
split_into_feature_sets <- function(data, feature_set) {
  if (feature_set == "nri") {
    data_split <- data[["data_vi_nri"]] %>%
      dplyr::select(matches("nri|defol"))
  } else if (feature_set == "vi") {
    data_split <- data[["data_vi_nri"]] %>%
      dplyr::select(-matches("nri"))
  } else if (feature_set == "bands") {
    data_split <- data[["data_bands"]]
  }
  return(data_split)
}

#' @title process_hyperspec
#' @description
#'   Preprocessing of hyperspectral data:
#'   - Crop to plot extent
#'   - Mask to plot extent
#'   - Reproject to EPSG 32630
#' @importFrom fs dir_create
#' @importFrom purrr iwalk pmap map set_names
#' @importFrom raster brick
#' @param data (`list`)\cr Raster bricks
#' @param id (`character`)\cr ID name
#' @param index (`integer`)\cr Internal identifier to check which plot belongs to which image.
#' @param plots (`sf`)\cr sf object containing the plot locations (n = 28)
#' @param name_out (`character`)\cr Name of the plot. Used for naming of the resulting list.
#'
#' @name process_hyperspec
#' @export
process_hyperspec <- function(data, id, index, plots, name_out, paper = TRUE) {

  # for later
  fs::dir_create("data/hyperspectral/vi/")
  fs::dir_create("data/hyperspectral/ndvi/")
  fs::dir_create("data/hyperspectral/nri/")

  if (paper) {
    index <- c(2, 2, 13, 7)
    id <- c("Laukiz I", "Laukiz II")
    name_out <- c("laukiz1", "laukiz2", "luiando", "oiartzun")
  }

  out <- purrr::pmap(list(id, index, name_out), ~
  process_hyperspec_helper(
    plots = plots,
    data = data,
    id = ..1,
    index = ..2,
    name_out = ..3
  ))

  cat("Finished processing.")

  out %<>% purrr::set_names(name_out)

  fs::dir_create("data/raster/hs-preprocessed/")

  # write to disk as otherwise it will be stored as a tmp file that is not
  # accessible later on
  purrr::iwalk(out, ~ raster::writeRaster(.x,
    glue::glue("data/raster/hs-preprocessed/hs-preprocessed-{.y}"),
    overwrite = TRUE
  ))

  cat("Finished writing.")

  out <- purrr::map(list.files("data/raster/hs-preprocessed/",
    pattern = ".grd",
    full.names = TRUE
  ), ~ raster::brick(.x))

  out %<>% purrr::set_names(sort(name_out))

  return(out)
}

#' @rdname process_hyperspec
process_hyperspec_helper <- function(data, id, index, plots, name_out) {
  image <- data[[index]]

  # project
  shape_single_plot <- plots %>%
    dplyr::filter(Name == ignore(id)) %>%
    sf::st_transform("epsg:25830") %>%
    as("Spatial")

  image_masked <- image %>%
    raster::crop(shape_single_plot) %>%
    raster::mask(shape_single_plot) %>%
    raster::projectRaster(crs = "EPSG:32630")
  cat(glue::glue("Finished '{name_out}'.\n"))

  return(image_masked)
}

#' @title Extract indices
#' @description
#'   Extract indices to trees
#' @importFrom raster extract
#' @importFrom purrr map2
#' @importFrom dplyr bind_cols
#'
#' @param plot_name (`character`)\cr Name of the plot
#' @param buffer (`integer`)\cr Buffer to use for extracing, see [raster::extract()].
#' @param tree_data (`sf`)\cr Tree data to extract the indices into.
#' @param veg_indices (`list`)\cr Raster bricks with veg indices
#' @param nri_indices (`list`)\cr Raster bricks with NRI indices
#'
#' @name extra_to_plot
#' @export
extract_indices_to_plot <- function(plot_name,
                                    buffer,
                                    tree_data,
                                    veg_indices,
                                    nri_indices) {
  veg_out <- list(
    raster::extract(veg_indices[[plot_name]],
      tree_data[[plot_name]],
      method = "bilinear",
      fun = mean,
      df = TRUE,
      na.rm = TRUE
    )
  )

  nbi_out <- list(
    raster::extract(nri_indices[[plot_name]],
      tree_data[[plot_name]],
      method = "bilinear",
      fun = mean,
      df = TRUE,
      na.rm = TRUE
    )
  )

  # coerce to data.frame

  # make the following work by giving buffer a value
  if (is.null(buffer)) {
    buffer <- 1
  }

  # veg_out %<>%
  #   purrr::map2(seq_along(buffer), ~ setNames(.x, glue::glue("bf{buffer}_{name}",
  #     name = names(veg_out[[.y]])
  #   )))
  #
  # nbi_out %<>%
  #   purrr::map2(seq_along(buffer), ~ setNames(.x, glue::glue("bf{buffer}_{name}",
  #     name = names(nbi_out[[.y]])
  #   )))

  # merge all data frames (buffers)
  all_veg <- dplyr::bind_cols(veg_out)

  all_nbi <- dplyr::bind_cols(nbi_out)

  tree_data[[plot_name]] %<>%
    dplyr::bind_cols(all_veg) %>%
    dplyr::bind_cols(all_nbi)

  return(tree_data[[plot_name]])
}

#' @title Extract hyperspectral bands
#' @description Extract indices to trees
#' @importFrom raster extract
#' @importFrom purrr map2
#' @param hyperspectral_bands (`list`)\cr List with Raster Bricks of
#'   hyperspectral bands
#'
#' @rdname extract_to_plot
#' @export
extract_bands_to_plot <- function(plot_name,
                                  buffer,
                                  tree_data,
                                  hyperspectral_bands) {
  if (!is.null(buffer)) {
    out_bands <- purrr::map(buffer, function(x) {
      raster::extract(hyperspectral_bands[[plot_name]][[5:126]],
        tree_data[[plot_name]],
        buffer = x,
        fun = mean,
        df = TRUE,
        na.rm = TRUE
      )
    })
  } else {
    out_bands <- list(raster::extract(hyperspectral_bands[[plot_name]][[5:126]],
      tree_data[[plot_name]],
      fun = mean,
      df = TRUE,
      na.rm = TRUE
    ))
  }

  # make the following work by giving buffer a value
  if (is.null(buffer)) {
    buffer <- 1
  }
  out_bands %<>%
    purrr::map2(seq_along(buffer), ~ setNames(
      .x,
      stringr::str_replace(
        glue::glue("{name}",
          name = names(out_bands[[.y]])
        ), "B.*_S.", "B"
      )
    ))

  # merge all data frames (buffers)
  out_bands <- dplyr::bind_cols(out_bands)

  tree_data[[plot_name]] %<>%
    dplyr::bind_cols(out_bands)

  return(tree_data[[plot_name]])
}

#' @title Calculate vegetation indices
#' @description
#'   Calculates vegetation indices from hyperspectral rasters
#' @importFrom future.apply future_lapply
#' @importFrom stringr str_replace
#' @importFrom hsdar vegindex
#' @param hyperspecs (`list`)\cr List of `hyperspec` objects
#' @param indices (`character`)\cr Names of indices to calculate
#'
#' @export
calc_veg_indices <- function(hyperspecs, indices) {
  veg_y <- future.apply::future_lapply(seq_along(hyperspecs), FUN = function(ii) {
    vegindex(hyperspecs[[ii]], indices,
      filename =
        glue::glue("data/hyperspectral/vi/{names(hyperspecs)[[ii]]}.grd"),
      bnames = indices, na.rm = TRUE
    )
  }) %>%
    purrr::set_names(names(hyperspecs))
}

#' @title Calculate Normalized Ratio Indices
#' @description
#'   Calculates Normalized Ratio Indices (NRI) from hyperspectral rasters
#' @importFrom future.apply future_lapply
#' @importFrom stringr str_replace
#' @importFrom hsdar nbi_raster
#' @param hyperspecs (`list`)\cr List of `hyperspec` objects
#' @param indices (`character`)\cr Names of indices to calculate
#'
#' @export
calc_nri_indices <- function(hyperspecs, indices) {
  y <- future.apply::future_lapply(seq_along(hyperspecs), FUN = function(ii) {
    nbi_raster(hyperspecs[[ii]],
      filename =
        stringr::str_replace(glue::glue("data/hyperspectral/nri/nri-{names(hyperspecs)[[ii]]}"), ".tif", ".grd"),
      bnames_prefix = "NRI"
    )
  }) %>%
    purrr::set_names(names(hyperspecs))
}

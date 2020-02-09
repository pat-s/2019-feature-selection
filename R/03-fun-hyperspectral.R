#' @title process_hyperspec
#' @description
#'   Preprocessing of hyperspectral data:
#'   - Crop to plot extent
#'   - Mask to plot extent
#'   - Reproject to EPSG 32630
#' @param data (`list`)\cr Raster bricks
#' @param id (`character`)\cr ID name
#' @param index (`integer`)\cr Internal identifier to check which plot belongs to which image.
#' @param plots (`sf`)\cr sf object containing the plot locations (n = 28)
#' @param name_out (`character`)\cr Name of the plot. Used for naming of the resulting list.
#'
#' @name process_hyperspec
#' @export
process_hyperspec <- function(data, id, index, plots, name_out) {

  # for later
  dir_create("data/hyperspectral/vi/")
  dir_create("data/hyperspectral/ndvi/")
  dir_create("data/hyperspectral/nri/")

  out <- pmap(list(id, index, name_out), ~
  process_hyperspec_helper(
    data = data, id = ..1,
    index = ..2, plots = plots,
    name_out = ..3
  ))

  cat("Finished processing.")

  out %<>% set_names(name_out)

  dir_create("data/raster/hs-preprocessed/")

  # write to disk as otherwise it will be stored as a tmp file that is not accessible later on
  iwalk(out, ~ writeRaster(.x, glue("data/raster/hs-preprocessed/hs-preprocessed-{.y}"),
    overwrite = TRUE
  ))

  cat("Finished writing.")

  out <- map(list.files("data/raster/hs-preprocessed/",
    pattern = ".grd",
    full.names = TRUE
  ), ~ brick(.x))

  out %<>% set_names(sort(name_out))

  return(out)
}

#' @inheritParams process_hyperspec
#' @rdname process_hyperspec
process_hyperspec_helper <- function(data, id, index, plots, name_out) {
  image <- data[[index]]

  # project
  plots %>%
    dplyr::filter(Name == ignore(id)) %>%
    st_transform(25830) %>%
    as("Spatial") -> shape_single_plot

  image_masked <- image %>%
    raster::crop(shape_single_plot) %>%
    raster::mask(shape_single_plot) %>%
    raster::projectRaster(crs = "+proj=utm +zone=30 +datum=WGS84 +units=m +no_defs")
  cat(glue("Finished {name_out}."))

  return(image_masked)
}

#' @title Extract indices
#' @description
#'   Extract indices to trees
#' @importFrom raster extract
#' @importFrom purrr map2
#' @param plot_name (`character`)\cr Name of the plot
#' @param buffer (`integer`)\cr Buffer to use for extracing, see [raster::extract()].
#' @param tree_data (`sf`)\cr Tree data to extract the indices into.
#' @param veg_indices (`list`)\cr Raster bricks with veg indices
#' @param nri_indices (`list`)\cr Raster bricks with NRI indices
#'
#' @export
extract_indices_to_plot <- function(plot_name, buffer, tree_data,
                                    veg_indices, nri_indices) {

  # calculate buffered veg index
  veg_out <- map(buffer, function(x) {
    raster::extract(veg_indices[[plot_name]], tree_data[[plot_name]],
      buffer = x,
      fun = mean, df = TRUE,
      na.rm = TRUE
    )
  })

  veg_out %<>%
    map2(seq_along(buffer), ~ setNames(.x, glue("bf{buffer}_{name}",
      name = names(veg_out[[.y]])
    )))

  nbi_out <- map(buffer, function(y) {
    raster::extract(nri_indices[[plot_name]], tree_data[[plot_name]],
      buffer = y,
      fun = mean, df = TRUE,
      na.rm = TRUE
    )
  })

  nbi_out %<>%
    map2(seq_along(buffer), ~ setNames(.x, glue("bf{buffer}_{name}",
      name = names(nbi_out[[.y]])
    )))

  # merge all data frames (buffers)
  all_veg <- bind_cols(veg_out)

  all_nbi <- bind_cols(nbi_out)

  tree_data[[plot_name]] %<>%
    bind_cols(all_veg) %>%
    bind_cols(all_nbi)

  return(tree_data[[plot_name]])
}

#' @title Extract hyperspectral bands
#' @description Extract indices to trees
#' @importFrom raster extract
#' @importFrom purrr map2
#' @inheritParams extract_indices_to_plot
#' @param hyperspectral_bands (`list`)\cr List with Raster Bricks of
#'   hyperspectral bands
#'
#' @export
extract_bands_to_plot <- function(plot_name, buffer, tree_data,
                                  hyperspectral_bands) {
  out_bands <- map(buffer, function(x) {
    raster::extract(hyperspectral_bands[[plot_name]][[5:126]], tree_data[[plot_name]],
      buffer = x,
      fun = mean, df = TRUE,
      na.rm = TRUE
    )
  })

  out_bands %<>%
    map2(seq_along(buffer), ~ setNames(
      .x,
      str_replace(
        glue("bf{buffer}_{name}",
          name = names(out_bands[[.y]])
        ), "B.*_S.", "B"
      )
    ))

  # merge all data frames (buffers)
  out_bands <- bind_cols(out_bands)

  tree_data[[plot_name]] %<>%
    bind_cols(out_bands)

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
  veg_y <- future_lapply(seq_along(hyperspecs), FUN = function(ii) {
    vegindex(hyperspecs[[ii]], indices,
      filename =
        glue("data/hyperspectral/vi/{names(hyperspecs)[[ii]]}.grd"),
      bnames = indices, na.rm = TRUE
    )
  }) %>%
    set_names(names(hyperspecs))
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
  y <- future_lapply(seq_along(hyperspecs), FUN = function(ii) {
    nbi_raster(hyperspecs[[ii]],
      filename =
        str_replace(glue("data/hyperspectral/nri/nri-{names(hyperspecs)[[ii]]}"), ".tif", ".grd"),
      bnames_prefix = "NRI"
    )
  }) %>%
    set_names(names(hyperspecs))
}

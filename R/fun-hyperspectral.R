process_hyperspec = function(data, id, name, index, plots, name_out) {

  #plan(future.callr::callr, workers = 28)
  plan("multisession", workers = ignore(28))

  # for later
  dir_create("data/hyperspectral/vi/")
  dir_create("data/hyperspectral/ndvi/")
  dir_create("data/hyperspectral/nri/")

  out = future_pmap(list(id, index, name_out), ~
                      process_hyperspec_helper(data = data, id = ..1,
                                               index = ..2, name_out = ..3,
                                               plots = plots))

  cat("Finished processing.")

  out %<>% set_names(name_out)

  dir_create("data/raster/hs-preprocessed/")

  # write to disk as otherwise it will be stored as a tmp file that is not accessible later on
  iwalk(out, ~ writeRaster(.x, glue("data/raster/hs-preprocessed/hs-preprocessed-{.y}"),
                                  overwrite = TRUE))

  cat("Finished writing.")

  out = map(list.files("data/raster/hs-preprocessed/", pattern = ".grd", full.names = TRUE), ~ brick(.x))

  out %<>% set_names(sort(name_out))

  return(out)

}

process_hyperspec_helper <- function(data, id, name, index, plots, name_out) {

  image <- data[[index]]

  # project
  plots %>%
    dplyr::filter(Name == ignore(id)) %>%
    st_transform(25830) %>%
    as("Spatial") -> shape_single_plot

  image_masked = image %>%
    raster::crop(shape_single_plot) %>%
    raster::mask(shape_single_plot) %>%
    raster::projectRaster(crs = "+proj=utm +zone=30 +datum=WGS84 +units=m +no_defs")
  cat(glue("Finished {name_out}."))

  return(image_masked)
}

extract_indices_to_plot = function(plot_name, buffer, bf_name, tree_data,
                                   veg_indices, nri_indices) {

  # calculate buffered veg index
  veg_out <- map(buffer, function(x)
    raster::extract(veg_indices[[plot_name]], tree_data[[plot_name]], buffer = x,
                    fun = mean, df = TRUE,
                    na.rm = TRUE))

  veg_out %<>%
    map2(seq_along(buffer), ~ setNames(.x, glue("bf{buffer}_{name}",
                                                name = names(veg_out[[.y]]))))

  nbi_out <- map(buffer, function(y)
    raster::extract(nri_indices[[plot_name]], tree_data[[plot_name]], buffer = y,
                    fun = mean, df = TRUE,
                    na.rm = TRUE))

  nbi_out %<>%
    map2(seq_along(buffer), ~ setNames(.x, glue("bf{buffer}_{name}",
                                                name = names(nbi_out[[.y]]))))

  # merge all data frames (buffers)
  all_veg <- bind_cols(veg_out)

  all_nbi <- bind_cols(nbi_out)

  tree_data[[plot_name]] %<>%
    bind_cols(all_veg) %>%
    bind_cols(all_nbi)

  return(tree_data[[plot_name]])
}

extract_bands_to_plot = function(plot_name, buffer, bf_name, tree_data, hyperspectral_bands) {

  plan(future::multisession, workers = ignore(15))

  # calculate buffered veg index
  # plan("multisession", workers = 4)
  out_bands <- future_map(buffer, function(x)
    raster::extract(hyperspectral_bands[[5:126]], tree_data, buffer = x,
                    fun = mean, df = TRUE,
                    na.rm = TRUE))

  out_bands %<>%
    map2(seq_along(buffer), ~ setNames(.x, glue("bf{buffer}_{name}",
                                                name = names(out_bands[[.y]]))))

  # merge all data frames (buffers)
  out_bands <- bind_cols(out_bands)

  points %<>%
    bind_cols(out_bands)

  return(points)
}

calc_veg_indices = function(hyperspecs, indices) {

  plan("multisession", workers = ignore(28))

  veg_y <- future_lapply(seq_along(hyperspecs), FUN = function(ii)
    vegindex(hyperspecs[[ii]], indices,
               filename =
                 str_replace(glue("data/hyperspectral/vi/{names(hyperspecs)[[ii]]}"), ".tif", ".grd"),
             bnames = indices, na.rm = TRUE)) %>%
    set_names(names(hyperspecs))

  #plan("multisession", workers = 10L)
  # plan(future.callr::callr, workers = ignore(28))
  #
  # future_imap(hyperspecs, ~
  #               vegindex(.x, indices,
  #                        filename =
  #                          str_replace(glue("data/hyperspectral/vi/{.y}"), ".tif", ".grd"),
  #                        na.rm = TRUE, bnames = indices))
}

calc_nri_indices = function(hyperspecs, indices) {

  #plan("multisession", workers = 7L)

  y <- lapply(seq_along(hyperspecs), FUN = function(ii)
    nbi_raster(hyperspecs[[ii]],
               filename =
                 str_replace(glue("data/hyperspectral/nri/nri-{names(hyperspecs)[[ii]]}"), ".tif", ".grd"),
               bnames_prefix = "NRI")) %>%
    set_names(names(hyperspecs))

  #plan("multisession", workers = ignore(7))
  #plan(future.callr::callr, workers = ignore(7))

  # future_imap(hyperspecs, ~
  #               nbi_raster(.x,
  #                          filename =
  #                            str_replace(glue("data/hyperspectral/nri/nri-{.y}"), ".tif", ".grd"),
  #                          bnames_prefix = "NRI"))
}


process_hyperspec = function(data, id, name, index, plots, name_out) {

  plan(future.callr::callr, workers = 28)

  # for later
  dir_create("data/hyperspectral/vi/")
  dir_create("data/hyperspectral/ndvi/")
  dir_create("data/hyperspectral/nri/")

  out = future_pmap(list(id, index, name_out), ~
                      process_hyperspec_helper(data = data, id = ..1,
                                               index = ..2, name_out = ..3,
                                               plots = plots))

  out %<>% set_names(name_out)
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
  out_veg <- future_map(buffer, function(x)
    raster::extract(veg_indices, tree_data, buffer = x,
                    fun = mean, df = TRUE,
                    na.rm = TRUE), mc.cores = cores)

  out_veg %<>%
    map2(seq_along(buffer), ~ setNames(.x, glue("bf{buffer}_{name}",
                                                name = names(out_veg[[.y]]))))

  out_nbi <- future_map(buffer, function(y)
    raster::extract(nri_indices, tree_data, buffer = y,
                    fun = mean, df = TRUE,
                    na.rm = TRUE))

  out_nbi %<>%
    map2(seq_along(buffer), ~ setNames(.x, glue("bf{buffer}_{name}",
                                                name = names(out_nbi[[.y]]))))

  # merge all data frames (buffers)
  all_veg <- bind_cols(out_veg)

  all_nbi <- bind_cols(out_nbi)

  points %<>%
    bind_cols(all_veg) %>%
    bind_cols(all_nbi)

  return(points)
}

extract_bands_to_plot = function(plot_name, buffer, bf_name, tree_data, hyperspectral_bands) {

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

  plan(future.callr::callr, workers = 10)

  future_imap(hyperspecs, ~
                vegindex(.x, indices,
                         filename =
                           str_replace(glue("data/hyperspectral/vi/{.y}"), ".tif", ".grd"),
                         na.rm = TRUE, bnames = indices))
}

calc_nri_indices = function(hyperspecs, indices) {

  plan(future.callr::callr, workers = 10)

  future_imap(hyperspecs, ~
                nbi_raster(.x,
                           filename =
                             str_replace(glue("data/hyperspectral/nri/nri-{.y}"), ".tif", ".grd"),
                           bnames_prefix = "NRI"))
}


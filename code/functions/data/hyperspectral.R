process_hyperspec <- function(data, id, name, index, plots, name_out, future_setup) {

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

extract_indices_to_plot = function(plot_name, buffer, cores, bf_name, tree_data,
                                   veg_indices, nri_indices) {

  # calculate buffered veg index
  out_veg <- pbmclapply(buffer, function(x)
    raster::extract(veg_indices, tree_data, buffer = x,
                    fun = mean, df = TRUE,
                    na.rm = TRUE), mc.cores = cores)

  out_veg %<>%
    map2(seq_along(buffer), ~ setNames(.x, glue("bf{buffer}_{name}",
                                                name = names(out_veg[[.y]]))))

  out_nbi <- pbmclapply(buffer, function(x)
    raster::extract(nri_indices, tree_data, buffer = x,
                    fun = mean, df = TRUE,
                    na.rm = TRUE) , mc.cores = cores)

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

extract_bands_to_plot = function(plot_name, buffer, cores, bf_name, tree_data, hyperspectral_bands) {

  # calculate buffered veg index

  # plan(multiprocess)
  # out_bands <- future_map(buffer, ~
  #   raster::extract(bands_ras[[5:126]], points, buffer = .x,
  #                   fun = mean, df = TRUE,
  #                   na.rm = TRUE),.progress = TRUE)

  out_bands <- pbmclapply(buffer, function(x)
    raster::extract(hyperspectral_bands[[5:126]], tree_data, buffer = x,
                    fun = mean, df = TRUE,
                    na.rm = TRUE), mc.cores = cores)

  out_bands %<>%
    map2(seq_along(buffer), ~ setNames(.x, glue("bf{buffer}_{name}",
                                                name = names(out_bands[[.y]]))))

  # merge all data frames (buffers)
  out_bands <- bind_cols(out_bands)

  points %<>%
    bind_cols(out_bands)

  return(points)
}

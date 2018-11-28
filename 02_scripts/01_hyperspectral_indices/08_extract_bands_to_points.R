# Packages ----------------------------------------------------------------

remotes::install_github("pat-s/hsdar")
needs(raster, hsdar, pbmcapply, glue, magrittr, sf, purrr, dplyr)


# define extract_to_plot fun ----------------------------------------------

extract_to_plot = function(plot_name, buffer, cores, bf_name) {
  points = st_read(glue("/data/patrick/mod/tree-per-tree/2016/{plot_name}/{plot_name}.gpkg"),
                   quiet = TRUE)

  bands_ras <- brick(glue("/data/patrick/mod/hyperspectral/atm-cropped/{plot_name}.tif"))

  # calculate buffered veg index

  # plan(multiprocess)
  # out_bands <- future_map(buffer, ~
  #   raster::extract(bands_ras[[5:126]], points, buffer = .x,
  #                   fun = mean, df = TRUE,
  #                   na.rm = TRUE),.progress = TRUE)

  out_bands <- pbmclapply(buffer, function(x)
    raster::extract(bands_ras[[5:126]], points, buffer = x,
                    fun = mean, df = TRUE,
                    na.rm = TRUE), mc.cores = cores)

  out_bands %<>%
    map2(seq_along(buffer), ~ setNames(.x, glue("bf{buffer}_{name}",
                                                name = names(out_bands[[.y]]))))

  # merge all data frames (buffers)
  out_bands <- bind_cols(out_bands)

  points %<>%
    bind_cols(out_bands)

  # .rda file (data frame)
  points %>%
    saveRDS(glue("~/00-inbox/all-bands-{plot_name}_{bf_name}.rda"))
}


# Apply function ---------------------------------------------------------

# plan(multiprocess)
# future_map(c("laukiz1", "laukiz2", "oiartzun", "luiando"), ~
#            extract_to_plot(.x, 2, "bf2"), .progress = TRUE)
pbmclapply(c("laukiz1", "laukiz2", "oiartzun", "luiando"),
           function(x) extract_to_plot(x, cores = 1, buffer = 2, bf_name = "bf2"),
           mc.cores = 4)

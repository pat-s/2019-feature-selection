# crop rasters
#future_setup1 = future_init(20)
data_hs_preprocessed = future_pmap(list(name_id, index, name_out), ~
                                      process_hyperspec(data = data_hs_raw, id = ..1,
                                                        index = ..2, name_out = ..3,
                                                        plots = plot_locations))

# create hyperspec rasters from cropped rasters
hyperspecs = map(data_hs_preprocessed, function(x) HyperSpecRaster(x, wavelength))

# calculate various indices for all plots
ndvi_rasters = pbmclapply(hyperspecs, function(x)
  vegindex(x, "NDVI2",
           filename = glue("data/hyperspectral/ndvi/ndvi2-{name}",
                           name = basename(x@file@name)),
           bnames = "NDVI"), mc.cores = 28)

veg_indices <- pbmclapply(hyperspecs, function(x)
  vegindex(x, indices,
           filename =
             str_replace(glue("data/hyperspectral/all-veg-indices/{name}",
                              name = basename(x@file@name)), ".tif", ".grd"),
           na.rm = TRUE, bnames = indices), mc.cores = 28)

nri_indices <- pbmclapply(hyperspecs, function(x)
  nbi_raster(x,
             filename = str_replace(glue("data/hyperspectral/",
                                         "narrow-band-indices/narrow-band-indices-{name}",
                                         name = basename(x@file@name)), ".tif", ".grd"),
             bnames_prefix = "NRI"), mc.cores = 15)

# extract all indices to tree data
trees_with_indices = pbmclapply(c("laukiz1", "laukiz2", "oiartzun", "luiando"),
                                function(x) extract_indices_to_plot(x, buffer = 2,
                                                                    cores = 1,
                                                                    bf_name = "bf2",
                                                                    tree_data = tree_per_tree,
                                                                    veg_indices = veg_indices,
                                                                    nri_indices = nri_indices),
                                mc.cores = 4)

# extract all indices to tree data
trees_with_bands = pbmclapply(c("laukiz1", "laukiz2", "oiartzun", "luiando"),
                              function(x) extract_bands_to_plot(x, buffer = 2,
                                                                cores = 1, bf_name = "bf2",
                                                                tree_data = tree_per_tree,
                                                                hyperspectral_bands = data_hs_preprocessed),
                              mc.cores = 4)

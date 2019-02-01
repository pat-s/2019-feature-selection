# crop rasters
data_hs_preprocessed = process_hyperspec(data = data_hs_raw, plots = plot_locations,
                                         name_out = name_out, index = index,
                                         id = name_id)

# create hyperspec rasters from cropped rasters
#hyperspecs = map(data_hs_preprocessed, ~ HyperSpecRaster(.x, wavelength))

# calculate various indices for all plots
ndvi_rasters = map(data_hs_preprocessed, ~ HyperSpecRaster(.x, wavelength)) %>%
  future_imap(~ vegindex(.x, "NDVI2",
                         filename = glue("data/hyperspectral/ndvi/ndvi2-{.y}"),
                         bnames = "NDVI"))

veg_indices = map(data_hs_preprocessed, ~ HyperSpecRaster(.x, wavelength)) %>%
  calc_veg_indices(indices)

nri_indices = map(data_hs_preprocessed, ~ HyperSpecRaster(.x, wavelength)) %>%
  calc_nri_indices(indices)

# extract all indices to tree data
trees_with_indices = future_map(c("laukiz1", "laukiz2", "oiartzun", "luiando"), ~
                                  extract_indices_to_plot(.x, buffer = 2,
                                                          bf_name = "bf2",
                                                          tree_data = tree_per_tree,
                                                          veg_indices = veg_indices,
                                                          nri_indices = nri_indices))

# extract all indices to tree data
trees_with_bands = future_map(c("laukiz1", "laukiz2", "oiartzun", "luiando"), ~
                                extract_bands_to_plot(.x, buffer = 2,
                                                      bf_name = "bf2",
                                                      tree_data = tree_per_tree,
                                                      hyperspectral_bands = data_hs_preprocessed))

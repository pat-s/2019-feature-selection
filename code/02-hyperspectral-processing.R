# crop hyperspectral rasters Mon Mar 11 22:27:14 2019
# ------------------------------

data_hs_preprocessed <- process_hyperspec(
  data = data_hs_raw, plots = plot_locations,
  name_out = name_out, index = index,
  id = name_id
)

# calculate various indices for all plots Mon Mar 11 21:56:51 2019
# ------------------------------
ndvi_rasters <- map(data_hs_preprocessed, ~ HyperSpecRaster(.x, wavelength)) %>%
  future_imap(~ vegindex(.x, "NDVI2",
    filename = glue("data/hyperspectral/ndvi/ndvi2-{.y}"),
    bnames = "NDVI"
  ))

veg_indices <- map(data_hs_preprocessed, ~ HyperSpecRaster(.x, wavelength)) %>%
  calc_veg_indices(indices)

nri_indices <- map(data_hs_preprocessed, ~ HyperSpecRaster(.x, wavelength)) %>%
  calc_nri_indices(indices)

# extract all indices to tree data Mon Mar 11 21:58:06 2019
# ------------------------------

trees_with_indices <- lapply(c("laukiz1", "laukiz2", "luiando", "oiartzun"),
  FUN = function(x) {
    extract_indices_to_plot(x,
      buffer = 2,
      tree_data = tree_per_tree,
      veg_indices = veg_indices,
      nri_indices = nri_indices
    )
  }
)

trees_with_bands <- lapply(c("laukiz1", "laukiz2", "luiando", "oiartzun"),
  FUN = function(x) {
    extract_bands_to_plot(x,
      buffer = 2,
      tree_data = tree_per_tree,
      hyperspectral_bands = data_hs_preprocessed
    )
  }
)

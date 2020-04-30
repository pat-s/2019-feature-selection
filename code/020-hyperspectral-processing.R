hyperspectral_processing_plan <- drake_plan(
  data_hs_preprocessed = target(
    process_hyperspec(
      data = data_hs_raw, plots = plot_locations,
      name_out = name_out, index = index,
      id = name_id
    )
  ),

  ndvi_rasters = target(
    map(data_hs_preprocessed, ~ HyperSpecRaster(.x, wavelength)) %>%
      future_imap(~ vegindex(.x, "NDVI2",
        filename = glue("data/hyperspectral/ndvi/ndvi2-{.y}"),
        bnames = "NDVI"
      ))
  ),

  veg_indices = target(
    map(data_hs_preprocessed, ~ HyperSpecRaster(.x, wavelength)) %>%
      calc_veg_indices(indices)
  ),

  nri_indices = target(
    map(data_hs_preprocessed, ~ HyperSpecRaster(.x, wavelength)) %>%
      calc_nri_indices(indices)
  ),

  trees_with_indices = target(
    list(
      extract_indices_to_plot(plot_names,
        buffer = buffer,
        tree_data = tree_per_tree,
        veg_indices = veg_indices,
        nri_indices = nri_indices
      )
    ),
    dynamic = cross(
      buffer, plot_names
    )
  ),

  trees_with_bands = target(
    list(
      extract_bands_to_plot(plot_names,
        buffer = buffer,
        tree_data = tree_per_tree,
        hyperspectral_bands = data_hs_preprocessed
      )
    ),
    dynamic = cross(
      buffer, plot_names
    )
  ),

  # corrected data from Jan 2020 -----------------------------------------------

  # trees_with_indices_corrected_buffer2 = target(
  #   lapply(c("laukiz1", "laukiz2", "luiando", "oiartzun"),
  #     FUN = function(x) {
  #       extract_indices_to_plot(x,
  #         buffer = 2,
  #         tree_data = tree_per_tree_corrected,
  #         veg_indices = veg_indices,
  #         nri_indices = nri_indices
  #       )
  #     }
  #   ),
  #   transform = map(buffer = c(0, 1, 1.5, 2))
  # ),

  buffer = c(1, 2, 3),
  plot_names = c("laukiz1", "laukiz2", "luiando", "oiartzun"),

  trees_with_indices_corrected_buffer2 = target(
    list(
      extract_indices_to_plot(plot_names,
        buffer = buffer,
        tree_data = tree_per_tree_corrected,
        veg_indices = veg_indices,
        nri_indices = nri_indices
      )
    ),
    dynamic = cross(
      buffer, plot_names
    )
  ),

  trees_with_indices_corrected_no_buffer = target(
    list(
      extract_indices_to_plot(plot_names,
        buffer = NULL,
        tree_data = tree_per_tree_corrected,
        veg_indices = veg_indices,
        nri_indices = nri_indices
      )
    ),
    dynamic = map(plot_names)
  ),

  trees_with_bands_corrected_buffer2 = target(
    list(
      extract_bands_to_plot(plot_names,
        buffer = buffer,
        tree_data = tree_per_tree_corrected,
        hyperspectral_bands = data_hs_preprocessed
      )
    ),
    dynamic = cross(
      buffer, plot_names
    )
  ),

  trees_with_bands_corrected_no_buffer = target(
    list(
      extract_bands_to_plot(plot_names,
        buffer = NULL,
        tree_data = tree_per_tree_corrected,
        hyperspectral_bands = data_hs_preprocessed
      )
    ),
    dynamic = map(plot_names)
  ),

  # spectral signatures for feature-importance.Rmd
  spec_sigs = target({
    speclibs <- lapply(data_hs_preprocessed[c(
      "laukiz1", "laukiz2",
      "luiando", "oiartzun"
    )], hsdar::speclib,
    wavelength = wavelength
    )
    spec_sig_num <- lapply(speclibs, function(x) as.numeric(spectra(apply(x, FUN = mean, na.rm = TRUE)))[5:126])
    spec_sig_num_scale <- lapply(spec_sig_num, function(x) {
      scale(x,
        center = FALSE,
        scale = max(x, na.rm = TRUE) / 2
      )
    })
    spec_sig_num_scale_df = purrr::map_dfc(spec_sig_num_scale, cbind) %>%
      set_colnames(c(
        "laukiz1", "laukiz2",
        "luiando", "oiartzun"
      )) %>%
      dplyr::mutate_all(as.numeric) %>%
      mutate(wavelength = seq(420, 995, 4.75)) %>%
      mutate(wavelength = round(wavelength))
  })
)

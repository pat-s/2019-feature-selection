hyperspectral_processing_plan <- drake_plan(
  data_hs_preprocessed_paper = target(
    process_hyperspec(
      data = data_hs_raw_paper, plots = plot_locations,
      name_out = name_out_paper, index = index_paper,
      id = name_id_paper
    )
  ),

  ndvi_rasters = target(
    map(data_hs_preprocessed_paper, ~ HyperSpecRaster(.x, wavelength)) %>%
      future_imap(~ vegindex(.x, "NDVI2",
        filename = glue("data/hyperspectral/ndvi/ndvi2-{.y}"),
        bnames = "NDVI"
      ))
  ),

  veg_indices = target(
    map(data_hs_preprocessed_paper, ~ HyperSpecRaster(.x, wavelength)) %>%
      calc_veg_indices(indices)
  ),

  nri_indices = target(
    map(data_hs_preprocessed_paper, ~ HyperSpecRaster(.x, wavelength)) %>%
      calc_nri_indices(indices)
  ),

  # corrected data from Jan 2020 -----------------------------------------------

  plot_names = c("laukiz1", "laukiz2", "luiando", "oiartzun"),

  trees_with_indices = target(
    list(
      extract_indices_to_plot(plot_names,
        buffer = NULL,
        tree_data = tree_per_tree,
        veg_indices = veg_indices,
        nri_indices = nri_indices
      )
    ),
    dynamic = cross(
      plot_names
    )
  ),

  trees_with_bands = target(
    list(
      extract_bands_to_plot(plot_names,
        buffer = NULL,
        tree_data = tree_per_tree,
        hyperspectral_bands = data_hs_preprocessed_paper
      )
    ),
    dynamic = cross(
      plot_names
    )
  ),

  # spectral signatures for feature-importance.Rmd
  spec_sigs = target({
    speclibs <- lapply(data_hs_preprocessed_paper[c(
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
    spec_sig_num_scale_df <- purrr::map_dfc(spec_sig_num_scale, cbind) %>%
      set_colnames(c(
        "laukiz1", "laukiz2",
        "luiando", "oiartzun"
      )) %>%
      dplyr::mutate_all(as.numeric) %>%
      mutate(wavelength = seq(420, 995, 4.75)) %>%
      mutate(wavelength = round(wavelength))
  })
)

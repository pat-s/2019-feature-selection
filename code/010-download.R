download_data_plan <- drake_plan(
  data_hs_raw_paper = target(
    download_hyperspectral("https://zenodo.org/record/3630302/files/hyperspectral.zip", paper = TRUE)
  ),
  plot_locations = target(
    download_locations("https://zenodo.org/record/3630302/files/plot-locations.gpkg")
  ),

  # tree_per_tree = target(
  #   download_trees("https://zenodo.org/record/3630302/files/tree-in-situ-data.zip") %>%
  #     set_names(c("laukiz1", "laukiz2", "luiando", "oiartzun"))
  # ),

  tree_per_tree = target({
    data_list <- download_trees("https://zenodo.org/record/3630302/files/tree-in-situ-data-corrected.zip") %>%
      purrr::map(~ dplyr::rename(., defoliation = DEFOLIATIO)) %>%
      purrr::map(~ sf::st_transform(., 32630))

    # data_list[[1]] %<>% dplyr::rename(x = X, y = Y)
    # data_list[[3]] %<>% dplyr::rename(x = X, y = Y)
    data_list %<>%
      set_names(c("laukiz1", "laukiz2", "luiando", "oiartzun"))
  }),
  forest_mask = target(
    download_forest_mask("https://zenodo.org/record/2653713/files/forest_mask.gpkg")
  ),
  name_id = target(
    c(
      "a busturi-axpe", "Laukiz I", "Laukiz II", "Laukiz III", "a altube",
      "a barazar", "Laricio defol. Urkiola.", "aguinaga pinaster radiata",
      "Oiartzun", "Pinast. Arza", "Pinas. Santa Koloma", "Rad. Menagaray 1",
      "Rad. Menagaray 2", "Ayala/Aiara", "Silvest. Nograro", "a caranca",
      "Picea Abornicano", "douglas 1", "douglas 2", "Rad. Altube",
      "a otxandio", "Laricio defol. Olaeta. pol", "Douglas Legutio",
      "Laricio defol.Gatzaga", "a azaceta", "a gipuzkoa",
      "Sequoia Legorreta", "Douglas Albiztur"
    )
  ),
  name_id_paper = target(
    c("Laukiz I", "Laukiz II", "Ayala/Aiara", "Oiartzun")
  ),
  name_out = target(
    c(
      "busturi", "laukiz1", "laukiz2", "laukiz3", "altube", "barazar",
      "laricio-defol-urkiola", "aguinaga-pinaster-radiata", "oiartzun",
      "pinast-arza", "pinas-santa-koloma", "rad-menagaray-1",
      "rad-menagaray-2", "luiando", "silvest-nograro", "caranca",
      "picea-abornicano", "douglas-1", "douglas-2", "rad-altube",
      "otxandio", "laricio-defol-olaeta", "douglas-legutio",
      "laricio-gatzaga", "azaceta", "gipuzkoa", "sequoia-legorreta",
      "douglas-albiztur"
    )
  ),
  name_out_paper = target(
    c("laukiz1", "laukiz2", "luiando", "oiartzun")
  ),

  # this specifies the index of the list entry which corresponds to the HS
  # raster of  either laukiz1, laukiz2, luiando or oairtzun processed in
  # process_hyperspec_helper()
  index_paper = target(
    c(1, 1, 3, 2)
  ),
  index = target(
    c(
      1, 2, 2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 11, 12, 13, 14, 16, 16, 16,
      17, 17, 18, 20, 21, 22, 22, 23
    )
  ),
  wavelength = target(
    c(
      404.08, 408.5, 412.92, 417.36, 421.81, 426.27, 430.73, 435.2,
      439.69, 444.18, 448.68, 453.18, 457.69, 462.22, 466.75, 471.29,
      475.83, 480.39, 484.95, 489.52, 494.09, 498.68, 503.26, 507.86,
      512.47, 517.08, 521.7, 526.32, 530.95, 535.58, 540.23, 544.88,
      549.54, 554.2, 558.86, 563.54, 568.22, 572.9, 577.6, 582.29,
      586.99, 591.7, 596.41, 601.13, 605.85, 610.58, 615.31, 620.05,
      624.79, 629.54, 634.29, 639.04, 643.8, 648.56, 653.33, 658.1,
      662.88, 667.66, 672.44, 677.23, 682.02, 686.81, 691.6, 696.4,
      701.21, 706.01, 710.82, 715.64, 720.45, 725.27, 730.09, 734.91,
      739.73, 744.56, 749.39, 754.22, 759.05, 763.89, 768.72, 773.56,
      778.4, 783.24, 788.08, 792.93, 797.77, 802.62, 807.47, 812.32,
      817.17, 822.02, 826.87, 831.72, 836.57, 841.42, 846.28, 851.13,
      855.98, 860.83, 865.69, 870.54, 875.39, 880.24, 885.09, 889.94,
      894.79, 899.64, 904.49, 909.34, 914.18, 919.03, 923.87, 928.71,
      933.55, 938.39, 943.23, 948.07, 952.9, 957.73, 962.56, 967.39,
      972.22, 977.04, 981.87, 986.68, 991.5, 996.31
    )
  ),

  # excluding the first four faulty bands
  wavelength_reduced = target(
    c(
      421.81, 426.27, 430.73, 435.2,
      439.69, 444.18, 448.68, 453.18, 457.69, 462.22, 466.75, 471.29,
      475.83, 480.39, 484.95, 489.52, 494.09, 498.68, 503.26, 507.86,
      512.47, 517.08, 521.7, 526.32, 530.95, 535.58, 540.23, 544.88,
      549.54, 554.2, 558.86, 563.54, 568.22, 572.9, 577.6, 582.29,
      586.99, 591.7, 596.41, 601.13, 605.85, 610.58, 615.31, 620.05,
      624.79, 629.54, 634.29, 639.04, 643.8, 648.56, 653.33, 658.1,
      662.88, 667.66, 672.44, 677.23, 682.02, 686.81, 691.6, 696.4,
      701.21, 706.01, 710.82, 715.64, 720.45, 725.27, 730.09, 734.91,
      739.73, 744.56, 749.39, 754.22, 759.05, 763.89, 768.72, 773.56,
      778.4, 783.24, 788.08, 792.93, 797.77, 802.62, 807.47, 812.32,
      817.17, 822.02, 826.87, 831.72, 836.57, 841.42, 846.28, 851.13,
      855.98, 860.83, 865.69, 870.54, 875.39, 880.24, 885.09, 889.94,
      894.79, 899.64, 904.49, 909.34, 914.18, 919.03, 923.87, 928.71,
      933.55, 938.39, 943.23, 948.07, 952.9, 957.73, 962.56, 967.39,
      972.22, 977.04, 981.87, 986.68, 991.5, 996.31
    )
  ),
  indices = target(
    c(
      "Boochs", "Boochs2", "CARI", "Carter", "Carter2", "Carter3", "Carter4", "Carter5",
      "Carter6", "CI", "CI2", "ClAInt", "CRI1", "CRI2", "CRI3", "CRI4", "D1", "D2",
      "Datt", "Datt2", "Datt3", "Datt4", "Datt5", "Datt6", "DD", "DDn", "DPI", "DWSI4",
      "EGFR", "EVI", "GDVI_2", "GDVI_3", "GDVI_4", "GI", "Gitelson",
      "Gitelson2", "GMI1", "GMI2", "Green NDVI", "Maccioni", "MCARI",
      "MCARI2", "mND705", "mNDVI", "MPRI", "MSAVI", "mSR",
      "mSR2", "mSR705", "MTCI", "MTVI", "NDVI", "NDVI2", "NDVI3",
      "NPCI", "OSAVI", "PARS", "PRI", "PRI_norm", "PRI*CI2", "PSRI",
      "PSSR", "PSND", "SPVI", "PWI", "RDVI", "REP_Li", "SAVI", "SIPI",
      "SPVI", "SR", "SR1", "SR2", "SR3", "SR4", "SR5", "SR6", "SR7",
      "SR8", "Sum_Dr1", "Sum_Dr2", "SRPI", "TCARI", "TCARI2", "TGI", "TVI", "Vogelmann",
      "Vogelmann2", "Vogelmann3", "Vogelmann4"
    )
  )
)

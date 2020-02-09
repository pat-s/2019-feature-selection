data_preprocessing_plan <- drake_plan(

  # read all datasets as list ----------------------------------------------------
  data_list_nri_vi_bands = target(
    list(
      "vi_nri" = trees_with_indices,
      "bands" = trees_with_bands
    )
  ),

  data_list_nri_vi_bands_corrected = target(
    list(
      "vi_nri" = trees_with_indices_corrected,
      "bands" = trees_with_bands_corrected
    )
  ),

  # clean datasets ---------------------------------------------------------------

  data_clean_single_plots = target(
    map(
      data_list_nri_vi_bands, ~ clean_single_plots(
        .x,
        c(
          "tree.number", "decoloration", "canker", "diameter", "height", "geom",
          "bf2_ID"
        ),
        remove_coords = FALSE
      )
    )
  ),

  data_clean_single_plots_corrected = target(
    map(
      data_list_nri_vi_bands_corrected,
      ~ clean_single_plots(
        .x,
        # marcos tree data col names differ among plots, hence the warnings of
        # somce columns not being available
        c(
          "diameter", "height", "zona", "tree.numbe", "DECOLORATI", "CANKER",
          "TREE_NUMBE", "heigth", "CANKERS", "tree_numbe", "geom"
        ),
        remove_coords = TRUE
      )
    )
  ),

  # extract coordinates of cleaned data ------------------------------------------

  data_clean_single_plots_coords = target(map(
    data_list_nri_vi_bands,
    ~ extract_coords(.x)
  )),
  data_clean_single_plots_coords_corrected = target(
    map(
      data_list_nri_vi_bands_corrected,
      ~ extract_coords(.x)
    )
  ),

  # Merge the dataframes of vi and nri -------------------------------------------

  # (stored in separate lists for each plot) into one dataset.
  # Possible variables with NAs are removed again, but this is
  # actually happening in `clean_single_plots()`.

  data_vi_nri_clean = target(
    as_tibble(rbindlist(data_clean_single_plots[[1]], fill = TRUE)) %>%
      Filter(function(x) !any(is.na(x)), .)
  ),
  coords_vi_nri_clean = target(
    as_tibble(rbindlist(data_clean_single_plots_coords[[1]]))
  ),

  data_bands_clean = target(
    as_tibble(rbindlist(data_clean_single_plots[[2]], fill = TRUE)) %>%
      Filter(function(x) !any(is.na(x)), .)
  ),
  coords_bands_clean = target(
    as_tibble(rbindlist(data_clean_single_plots_coords[[2]]))
  ),






  data_vi_nri_clean_corrected = target(
    as_tibble(rbindlist(data_clean_single_plots_corrected[[1]], fill = TRUE)) %>%
      Filter(function(x) !any(is.na(x)), .)
  ),
  coords_vi_nri_clean_corrected = target(
    as_tibble(rbindlist(data_clean_single_plots_coords_corrected[[1]]))
  ),

  data_bands_clean_corrected = target(
    as_tibble(rbindlist(data_clean_single_plots_corrected[[2]], fill = TRUE)) %>%
      Filter(function(x) !any(is.na(x)), .)
  ),
  coords_bands_clean_corrected = target(
    as_tibble(rbindlist(data_clean_single_plots_coords_corrected[[2]]))
  ),

  # modify defoliation value (we get errors if defol is exactly zero) ------------

  data_trim_defoliation = target(
    map(
      list(data_vi_nri_clean, data_bands_clean),
      ~ mutate_defol(.x)
    ) %>%
      set_names(c("data_vi_nri", "data_bands"))
  ),

  data_trim_defoliation_corrected = target(
    map(
      list(data_vi_nri_clean_corrected, data_bands_clean_corrected),
      ~ mutate_defol(.x)
    ) %>%
      set_names(c("data_vi_nri", "data_bands"))
  ),

  # split into feature sets ------------------------------------------------------

  nri_data = target(
    split_into_feature_sets(data_trim_defoliation, "nri")
  ),

  vi_data = target(
    split_into_feature_sets(data_trim_defoliation, "vi")
  ),

  bands_data = target(
    split_into_feature_sets(data_trim_defoliation, "bands")
  ),

  nri_vi_data = target(
    cbind(nri_data, vi_data) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  ),

  hr_nri_data = target(
    cbind(bands_data, nri_data) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  ),

  hr_vi_data = target(
    cbind(bands_data, vi_data) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  ),

  hr_nri_vi_data = target(
    cbind(bands_data, nri_data, vi_data) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  ),




  nri_data_corrected = target(
    split_into_feature_sets(data_trim_defoliation_corrected, "nri")
  ),

  vi_data_corrected = target(
    split_into_feature_sets(data_trim_defoliation_corrected, "vi")
  ),

  bands_data_corrected = target(
    split_into_feature_sets(data_trim_defoliation_corrected, "bands")
  ),

  nri_vi_data_corrected = target(
    cbind(nri_data_corrected, vi_data_corrected) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  ),

  hr_nri_data_corrected = target(
    cbind(bands_data_corrected, nri_data_corrected) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  ),

  hr_vi_data_corrected = target(
    cbind(bands_data_corrected, vi_data_corrected) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  ),

  hr_nri_vi_data_corrected = target(
    cbind(bands_data_corrected, nri_data_corrected, vi_data_corrected) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  )
)

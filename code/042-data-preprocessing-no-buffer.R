data_preprocessing_plan_no_buffer <- drake_plan(

  # read all datasets as list ----------------------------------------------------
    data_list_nri_vi_bands_corrected_no_buffer = target(
    list(
      "vi_nri" = trees_with_indices_corrected_no_buffer,
      "bands" = trees_with_bands_corrected_no_buffer
    )
  ),

  # clean datasets ---------------------------------------------------------------

  data_clean_single_plots_corrected_no_buffer = target(
    map(
      data_list_nri_vi_bands_corrected_no_buffer,
      ~ clean_single_plots(
        .x,
        # marcos tree data col names differ among plots, hence the warnings of
        # somce columns not being available
        c(
          "diameter", "height", "zona", "tree.numbe", "DECOLORATI", "CANKER",
          "TREE_NUMBE", "heigth", "CANKERS", "tree_numbe", "geom", "ID"
        ),
        remove_coords = TRUE
      )
    )
  ),

  # Merge the dataframes of vi and nri -------------------------------------------

  # (stored in separate lists for each plot) into one dataset.
  # Possible variables with NAs are removed again, but this is
  # actually happening in `clean_single_plots()`.

  data_vi_nri_clean_corrected_no_buffer = target(
    as_tibble(rbindlist(data_clean_single_plots_corrected_no_buffer[[1]], fill = TRUE)) %>%
      Filter(function(x) !any(is.na(x)), .)
  ),

  data_bands_clean_corrected_no_buffer = target(
    as_tibble(rbindlist(data_clean_single_plots_corrected_no_buffer[[2]], fill = TRUE)) %>%
      Filter(function(x) !any(is.na(x)), .)
  ),

  # modify defoliation value (we get errors if defol is exactly zero) ------------

  data_trim_defoliation_corrected_no_buffer = target(
    map(
      list(data_vi_nri_clean_corrected_no_buffer,
           data_bands_clean_corrected_no_buffer),
      ~ mutate_defol(.x)
    ) %>%
      set_names(c("data_vi_nri", "data_bands"))
  ),

  # split into feature sets ------------------------------------------------------

  nri_data_corrected_no_buffer = target(
    split_into_feature_sets(data_trim_defoliation_corrected_no_buffer, "nri")
  ),

  vi_data_corrected_no_buffer = target(
    split_into_feature_sets(data_trim_defoliation_corrected_no_buffer, "vi")
  ),

  bands_data_corrected_no_buffer = target(
    split_into_feature_sets(data_trim_defoliation_corrected_no_buffer, "bands")
  ),

  nri_vi_data_corrected_no_buffer = target(
    cbind(nri_data_corrected_no_buffer, vi_data_corrected_no_buffer) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  ),

  hr_nri_data_corrected_no_buffer = target(
    cbind(bands_data_corrected_no_buffer, nri_data_corrected_no_buffer) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  ),

  hr_vi_data_corrected_no_buffer = target(
    cbind(bands_data_corrected_no_buffer, vi_data_corrected_no_buffer) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  ),

  hr_nri_vi_data_corrected_no_buffer = target(
    cbind(bands_data_corrected_no_buffer, nri_data_corrected_no_buffer,
          vi_data_corrected_no_buffer) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  )
)

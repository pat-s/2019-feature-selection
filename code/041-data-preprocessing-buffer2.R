data_preprocessing_plan_buffer2 <- drake_plan(

  # read all datasets as list ----------------------------------------------------
  data_list_nri_vi_bands = target(
    list(
      "vi_nri" = trees_with_indices,
      "bands" = trees_with_bands
    )
  ),

  # [1:4] : 1m buffer
  # [5:8] : 2m buffer
  # [9:12] : 3m buffer
  # see 02-hyperspectral-preprocessing.R
  data_list_nri_vi_bands_corrected_buffer2 = target(
    list(
      "vi_nri" = trees_with_indices_corrected_buffer2[5:8],
      "bands" = trees_with_bands_corrected_buffer2[5:8]
    )
  ),

  # clean datasets ---------------------------------------------------------------

  data_clean_single_plots = target(
    map(
      data_list_nri_vi_bands, ~ clean_single_plots(
        .x,
        c(
          "tree.number", "decoloration", "canker", "diameter", "height", "geom",
          "bf2_ID", "ID"
        ),
        remove_coords = FALSE
      )
    )
  ),

  data_clean_single_plots_corrected_buffer2 = target(
    map(
      data_list_nri_vi_bands_corrected_buffer2,
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

  # extract coordinates of cleaned data ------------------------------------------

  data_clean_single_plots_coords = target(map(
    data_list_nri_vi_bands,
    ~ extract_coords(.x)
  )),
  data_clean_single_plots_coords_corrected = target(
    map(
      data_list_nri_vi_bands_corrected_buffer2,
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






  data_vi_nri_clean_corrected_buffer2 = target(
    as_tibble(rbindlist(data_clean_single_plots_corrected_buffer2[[1]], fill = TRUE)) %>%
      Filter(function(x) !any(is.na(x)), .)
  ),
  coords_vi_nri_clean_corrected = target(
    as_tibble(rbindlist(data_clean_single_plots_coords_corrected[[1]]))
  ),

  data_bands_clean_corrected_buffer2 = target(
    as_tibble(rbindlist(data_clean_single_plots_corrected_buffer2[[2]], fill = TRUE)) %>%
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

  data_trim_defoliation_corrected_buffer2 = target(
    map(
      list(data_vi_nri_clean_corrected_buffer2,
           data_bands_clean_corrected_buffer2),
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




  nri_data_corrected_buffer2 = target(
    split_into_feature_sets(data_trim_defoliation_corrected_buffer2, "nri")
  ),

  vi_data_corrected_buffer2 = target(
    split_into_feature_sets(data_trim_defoliation_corrected_buffer2, "vi")
  ),

  bands_data_corrected_buffer2 = target(
    split_into_feature_sets(data_trim_defoliation_corrected_buffer2, "bands")
  ),

  nri_vi_data_corrected_buffer2 = target(
    cbind(nri_data_corrected_buffer2, vi_data_corrected_buffer2) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  ),

  hr_nri_data_corrected_buffer2 = target(
    cbind(bands_data_corrected_buffer2, nri_data_corrected_buffer2) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  ),

  hr_vi_data_corrected_buffer2 = target(
    cbind(bands_data_corrected_buffer2, vi_data_corrected_buffer2) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  ),

  hr_nri_vi_data_corrected_buffer2 = target(
    cbind(bands_data_corrected_buffer2, nri_data_corrected_buffer2,
          vi_data_corrected_buffer2) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  )
)

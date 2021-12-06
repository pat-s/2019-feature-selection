data_preprocessing_plan <- drake_plan(

  # read all datasets as list ----------------------------------------------------

  # see 02-hyperspectral-preprocessing.R
  data_list_nri_vi_bands = target(
    list(
      "vi_nri" = trees_with_indices,
      "bands" = trees_with_bands
    )
  ),

  # clean datasets ---------------------------------------------------------------

  data_clean_single_plots = target(
    map(
      data_list_nri_vi_bands,
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

  data_clean_single_plots_coords = target(
    map(
      data_list_nri_vi_bands,
      ~ extract_coords(.x)
    )
  ),

  # Merge the dataframes of vi and nri -------------------------------------------

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

  # modify defoliation value (we get errors if defol is exactly zero) ------------

  data_trim_defoliation = target(
    map(
      list(
        data_vi_nri_clean,
        data_bands_clean
      ),
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
    cbind(
      bands_data, nri_data,
      vi_data
    ) %>%
      subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column
  ),

  # data with max correlation between features of 0.99 %>% ---------------------

  # removing the first column to not accidentally remove the response
  # therefore, we need to shift the results by one positon to account for this shift

  nri_data_trim_cor = target({
    inds <- caret::findCorrelation(cor(nri_data[, -1]),
      cutoff = 0.9999999999, exact = TRUE
    )
    if (length(inds) >= 1) {
      inds <- inds + 1
      nri_data[, -inds]
    } else {
      nri_data
    }
  }),
  vi_data_trim_cor = target({
    inds <- caret::findCorrelation(cor(vi_data[, -1]),
      cutoff = 0.9999999999, exact = TRUE
    )
    if (length(inds) >= 1) {
      inds <- inds + 1
      vi_data[, -inds]
    } else {
      vi_data
    }
  }),
  bands_data_trim_cor = target({
    inds <- caret::findCorrelation(cor(bands_data[, -1]),
      cutoff = 0.9999999999, exact = TRUE
    )
    if (length(inds) >= 1) {
      inds <- inds + 1
      bands_data[, -inds]
    } else {
      bands_data
    }
  }),
  nri_vi_data_trim_cor = target({
    inds <- caret::findCorrelation(cor(nri_vi_data[, -1]),
      cutoff = 0.9999999999, exact = TRUE
    )
    if (length(inds) >= 1) {
      inds <- inds + 1
      nri_vi_data[, -inds]
    } else {
      nri_vi_data
    }
  }),
  hr_nri_data_trim_cor = target({
    inds <- caret::findCorrelation(cor(hr_nri_data[, -1]),
      cutoff = 0.9999999999, exact = TRUE
    )
    if (length(inds) >= 1) {
      inds <- inds + 1
      hr_nri_data[, -inds]
    } else {
      hr_nri_vi_data
    }
  }),
  hr_vi_data_trim_cor = target({
    inds <- caret::findCorrelation(cor(hr_vi_data[, -1]),
      cutoff = 0.9999999999, exact = TRUE
    )
    if (length(inds) >= 1) {
      inds <- inds + 1
      hr_vi_data[, -inds]
    } else {
      hr_vi_data
    }
  }),
  hr_nri_vi_data_trim_cor = target({
    inds <- caret::findCorrelation(cor(hr_nri_vi_data[, -1]),
      cutoff = 0.9999999999, exact = TRUE
    )
    if (length(inds) >= 1) {
      inds <- inds + 1
      hr_nri_vi_data[, -inds]
    } else {
      hr_nri_vi_data
    }
  })
)

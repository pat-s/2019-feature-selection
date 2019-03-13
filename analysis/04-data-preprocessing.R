# read all datasets as list Mon Mar 11 22:28:38 2019 ------------------------------

data_list_nri_vi_bands = list("vi_nri" = trees_with_indices, "bands" = trees_with_bands)

# clean datasets Mon Mar 11 22:28:58 2019 ------------------------------

data_clean_single_plots = map(data_list_nri_vi_bands, ~ clean_single_plots(.x))

# extract coordinates of cleaned data Mon Mar 11 22:29:22 2019 ------------------------------

data_clean_single_plots_coords = map(data_list_nri_vi_bands, ~ extract_coords(.x))

# Merge the dataframes of vi and nri (stored in separate lists for each plot)
# into one dataset Mon Mar 11 22:29:37 2019 ------------------------------

data_vi_nri_clean = as_tibble(rbindlist(data_clean_single_plots[[1]], fill = TRUE)) %>%
  Filter(function(x) !any(is.na(x)), .)
coords_vi_nri_clean = as_tibble(rbindlist(data_clean_single_plots_coords[[1]]))

# FIXME - sehr viele NAs!
data_bands_clean = as_tibble(rbindlist(data_clean_single_plots[[2]], fill = TRUE)) %>%
  Filter(function(x) !any(is.na(x)), .)
coords_bands_clean = as_tibble(rbindlist(data_clean_single_plots_coords[[2]]))

# modify defoliation value (we get errors if defol is exactly zero) Mon Mar 11 22:31:36 2019 ------------------------------

data_trim_defoliation = map(list(data_vi_nri_clean), ~ mutate_defol(.x)) %>%
  set_names("data_vi_nri")

# split into feature sets Mon Mar 11 22:44:59 2019 ------------------------------

nri_data = split_in_feature_sets(data_trim_defoliation, "nri")

vi_data = split_in_feature_sets(data_trim_defoliation, "vi")

# bands_data = split_in_feature_sets(data_trim_defoliation, "bands")

nri_vi_data = cbind(nri_data, vi_data)

# log transform response variable Mon Mar 11 22:45:35 2019 ------------------------------

nri_data_log_transformed = log_response(nri_data, "defoliation")
vi_data_log_transformed = log_response(vi_data, "defoliation")
#bands_data_log_transformed = log_response(bands_data, "defoliation")
nri_vi_data_log_transformed = log_response(nri_vi_data, "defoliation")

# create tasks Mon Mar 11 22:46:03 2019 ------------------------------

nri_task = makeRegrTask(id = "defoliation-all-plots-NRI", data = nri_data_log_transformed,
                        target = "defoliation", coordinates = coords_vi_nri_clean,
                        blocking = factor(rep(1:4, c(479, 451, 300, 529))))

vi_task = makeRegrTask(id = "defoliation-all-plots-VI", data = vi_data_log_transformed,
                       target = "defoliation", coordinates = coords_vi_nri_clean,
                       blocking = factor(rep(1:4, c(479, 451, 300, 529))))

# bands_task = makeRegrTask(id = "defoliation-all-plots-bands", data = bands_data_log_transformed,
#                           target = "defoliation", coordinates = coords_bands,
#                           blocking = factor(rep(1:4, c(479, 451, 294, 529))))

nri_vi_task = makeRegrTask(id = "defoliation-all-plots-NRI-VI", data = nri_vi_data_log_transformed,
                           target = "defoliation", coordinates = coords_bands,
                           blocking = factor(rep(1:4, c(479, 451, 300, 529))))

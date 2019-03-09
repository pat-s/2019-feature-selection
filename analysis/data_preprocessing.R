data_ls = list("vi_nri" = trees_with_indices, "bands" = trees_with_bands)

plan(future.callr::callr, workers = ignore(2))
data_clean = future_imap(data_ls, ~ remove_na(.x))
coords = future_imap(data_ls, ~ extract_coords(.x))

# Merge into one datase
data_vi_nri_clean = as_tibble(rbindlist(data_clean[[1]], fill = TRUE)) %>%
  Filter(function(x) !any(is.na(x)), data_clean[[1]])

coords_vi_nri = as_tibble(rbindlist(coords[[1]]))

data_bands_clean = as_tibble(rbindlist(data_clean[[1]], fill = TRUE)) %>%
  Filter(function(x) !any(is.na(x)), data_clean[[1]])

coords_bands = as_tibble(rbindlist(coords[[1]]))

# modify defoliation value (we get errors if defol is exactly zero)
plan("multisession", workers = 2)
data_mod = future_map(list(data_vi_nri_clean, data_bands_clean), ~ mutate_defol(.x))

# split into feature sets -------------------------------------------------

data_nri = split_in_feature_sets(data_mod, "nri")

data_vi = split_in_feature_sets(data_mod, "vi")

data_bands = split_in_feature_sets(data_mod, "bands")

# log transform response variable -----------------------------------------

data_nri_log = log_response(data_nri, "defoliation")
data_vi_log = log_response(data_vi, "defoliation")
data_bands_log = log_response(data_bands, "defoliation")

# create tasks -----------------------------------------

task_vi = makeRegrTask(id = "defoliation-all-plots-VI", data = data_vi_log,
                       target = "defoliation", coordinates = coords_vi_nri,
                       blocking = factor(rep(1:4, c(479, 451, 291, 529))))

task_nri = makeRegrTask(id = "defoliation-all-plots-NRI", data = data_nri_log,
                        target = "defoliation", coordinates = coords_vi_nri,
                        blocking = factor(rep(1:4, c(479, 451, 291, 529))))

task_bands = makeRegrTask(id = "defoliation-all-plots-bands", data = data_bands_log,
                          target = "defoliation", coordinates = coords_bands,
                          blocking = factor(rep(1:4, c(479, 451, 294, 529))))

# read all datasets as list ----------------------------------------------------

data_list_nri_vi_bands <- list("vi_nri" = trees_with_indices, "bands" = trees_with_bands)

# clean datasets ---------------------------------------------------------------

data_clean_single_plots <- map(data_list_nri_vi_bands, ~ clean_single_plots(.x))

# extract coordinates of cleaned data ------------------------------------------


data_clean_single_plots_coords <- map(data_list_nri_vi_bands, ~ extract_coords(.x))

# Merge the dataframes of vi and nri -------------------------------------------

# (stored in separate lists for each plot) into one dataset.
# Possible variables with NAs are removed again, but this is
# actually happening in `clean_single_plots()`.

data_vi_nri_clean <- as_tibble(rbindlist(data_clean_single_plots[[1]], fill = TRUE)) %>%
  Filter(function(x) !any(is.na(x)), .)
coords_vi_nri_clean <- as_tibble(rbindlist(data_clean_single_plots_coords[[1]]))

data_bands_clean <- as_tibble(rbindlist(data_clean_single_plots[[2]], fill = TRUE)) %>%
  Filter(function(x) !any(is.na(x)), .)
coords_bands_clean <- as_tibble(rbindlist(data_clean_single_plots_coords[[2]]))

# modify defoliation value (we get errors if defol is exactly zero) ------------


data_trim_defoliation <- map(
  list(data_vi_nri_clean, data_bands_clean),
  ~ mutate_defol(.x)
) %>%
  set_names(c("data_vi_nri", "data_bands"))

# split into feature sets ------------------------------------------------------

nri_data <- split_into_feature_sets(data_trim_defoliation, "nri")

vi_data <- split_into_feature_sets(data_trim_defoliation, "vi")

bands_data <- split_into_feature_sets(data_trim_defoliation, "bands")

nri_vi_data <- cbind(nri_data, vi_data) %>%
  subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column

hr_nri_data <- cbind(bands_data, nri_data) %>%
  subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column

hr_vi_data <- cbind(bands_data, vi_data) %>%
  subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column

hr_nri_vi_data <- cbind(bands_data, nri_data, vi_data) %>%
  subset(select = which(!duplicated(names(.)))) # remove duplicate "defoliation" column

# log transform response variable ----------------------------------------------


nri_data_log_transformed <- log_response(nri_data, "defoliation")
vi_data_log_transformed <- log_response(vi_data, "defoliation")
bands_data_log_transformed <- log_response(bands_data, "defoliation")
nri_vi_data_log_transformed <- log_response(nri_vi_data, "defoliation")
hr_vi_data_log_transformed <- log_response(hr_vi_data, "defoliation")
hr_nri_data_log_transformed <- log_response(hr_nri_data, "defoliation")
hr_nri_vi_data_log_transformed <- log_response(hr_nri_vi_data, "defoliation")

# boxcox-transform response ----------------------------------------------------

nri_data_boxcox_transformed <- boxcox_response(nri_data, "defoliation")
vi_data_boxcox_transformed <- boxcox_response(vi_data, "defoliation")
bands_data_boxcox_transformed <- boxcox_response(bands_data, "defoliation")
nri_vi_data_boxcox_transformed <- boxcox_response(nri_vi_data, "defoliation")
hr_vi_data_boxcox_transformed <- boxcox_response(hr_vi_data, "defoliation")
hr_nri_data_boxcox_transformed <- boxcox_response(hr_nri_data, "defoliation")
hr_nri_vi_data_boxcox_transformed <- boxcox_response(hr_nri_vi_data, "defoliation")

# create tasks -----------------------------------------------------------------

# Boxcox transformed tasks

nri_task_log <- makeRegrTask(
  id = "defoliation-all-plots-NRI", data = nri_data_log_transformed,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

vi_task_log <- makeRegrTask(
  id = "defoliation-all-plots-VI", data = vi_data_log_transformed,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

hr_task_log <- makeRegrTask(
  id = "defoliation-all-plots-HR", data = bands_data_log_transformed,
  target = "defoliation", coordinates = coords_bands_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

nri_vi_task_log <- makeRegrTask(
  id = "defoliation-all-plots-NRI-VI", data = nri_vi_data_log_transformed,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

hr_nri_vi_task_log <- makeRegrTask(
  id = "defoliation-all-plots-HR-NRI-VI", data = hr_nri_vi_data_log_transformed,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

hr_vi_task_log <- makeRegrTask(
  id = "defoliation-all-plots-HR-VI", data = hr_vi_data_log_transformed,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

hr_nri_task_log <- makeRegrTask(
  id = "defoliation-all-plots-HR-NRI", data = hr_nri_data_log_transformed,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)


# Non-log transformed tasks ----------------------------------------------------

nri_task <- makeRegrTask(
  id = "defoliation-all-plots-NRI", data = nri_data,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

vi_task <- makeRegrTask(
  id = "defoliation-all-plots-VI", data = vi_data,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

hr_task <- makeRegrTask(
  id = "defoliation-all-plots-HR", data = bands_data,
  target = "defoliation", coordinates = coords_bands_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

nri_vi_task <- makeRegrTask(
  id = "defoliation-all-plots-NRI-VI", data = nri_vi_data,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

hr_nri_vi_task <- makeRegrTask(
  id = "defoliation-all-plots-HR-NRI-VI", data = hr_nri_vi_data,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

hr_vi_task <- makeRegrTask(
  id = "defoliation-all-plots-HR-VI", data = hr_vi_data,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

hr_nri_task <- makeRegrTask(
  id = "defoliation-all-plots-HR-NRI", data = hr_nri_data,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

# Boxcox transformed tasks

nri_task_boxcox <- makeRegrTask(
  id = "defoliation-all-plots-NRI", data = nri_data_boxcox_transformed,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

vi_task_boxcox <- makeRegrTask(
  id = "defoliation-all-plots-VI", data = vi_data_boxcox_transformed,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

hr_task_boxcox <- makeRegrTask(
  id = "defoliation-all-plots-HR", data = bands_data_boxcox_transformed,
  target = "defoliation", coordinates = coords_bands_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

nri_vi_task_boxcox <- makeRegrTask(
  id = "defoliation-all-plots-NRI-VI", data = nri_vi_data_boxcox_transformed,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

hr_nri_vi_task_boxcox <- makeRegrTask(
  id = "defoliation-all-plots-HR-NRI-VI", data = hr_nri_vi_data_boxcox_transformed,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

hr_vi_task_boxcox <- makeRegrTask(
  id = "defoliation-all-plots-HR-VI", data = hr_vi_data_boxcox_transformed,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

hr_nri_task_boxcox <- makeRegrTask(
  id = "defoliation-all-plots-HR-NRI", data = hr_nri_data_boxcox_transformed,
  target = "defoliation", coordinates = coords_vi_nri_clean,
  blocking = factor(rep(1:4, c(479, 451, 300, 529)))
)

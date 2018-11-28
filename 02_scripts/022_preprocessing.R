# Packages ----------------------------------------------------------------

needs(mlrCPO, tibble, data.table, magrittr, dplyr, purrr)

# Merge all plots into one DF ---------------------------------------------

data_vi_nri = readRDS("/data/patrick/mod/hyperspectral/data_clean_with_indices/vi_nri_clean_standardized_bf2.rda")
data_bands = readRDS("/data/patrick/mod/hyperspectral/data_clean_with_indices/bands_clean_standardized_bf2.rda")

coords_vi_nri = readRDS("/data/patrick/mod/hyperspectral/data_clean_with_indices/vi_nri_clean_standardized_bf2-coords.rda")
coords_bands = readRDS("/data/patrick/mod/hyperspectral/data_clean_with_indices/bands_clean_standardized_bf2-coords.rda")

# Merge into one dataset ---------------------------------------------

data_vi_nri = as_tibble(rbindlist(data_vi_nri, fill = TRUE))
data_vi_nri = Filter(function(x) !any(is.na(x)), data_vi_nri)
coords_vi_nri = as_tibble(rbindlist(coords_vi_nri))

# fill = FALSE here because column names differ between plots -> otherwise we get NA
data_bands = as_tibble(rbindlist(data_bands, fill = FALSE))
data_bands = Filter(function(x) !any(is.na(x)), data_bands)
coords_bands = as_tibble(rbindlist(coords_bands))

# transform defol = 0 values so that we do not get -inf when log transforming
out = map(list(data_vi_nri, data_bands), ~ {

  .x %<>%
    mutate(defoliation = case_when(.data$defoliation == 0 ~ 0.001,
                                   TRUE ~ as.numeric(defoliation)))
}) %>%
  set_names(c("data_vi_nri", "data_bands"))

# split into feature sets -------------------------------------------------

data_nri = out$data_vi_nri %>%
  select(matches("nri|defol"))

data_vi = out$data_vi_nri %>%
  select(-matches("nri"))

data_bands = out$data_bands

# create tasks -----------------------------------------

data_nri$defoliation = log(data_nri$defoliation)
data_vi$defoliation = log(data_vi$defoliation)
data_bands$defoliation = log(data_bands$defoliation)

task_vi = makeRegrTask(id = "defoliation-all-plots-VI", data = data_vi,
                       target = "defoliation", coordinates = coords_vi_nri,
                       blocking = factor(rep(1:4, c(479, 451, 291, 529))))

task_nri = makeRegrTask(id = "defoliation-all-plots-NRI", data = data_nri,
                        target = "defoliation", coordinates = coords_vi_nri,
                        blocking = factor(rep(1:4, c(479, 451, 291, 529))))

task_bands = makeRegrTask(id = "defoliation-all-plots-bands", data = data_bands,
                        target = "defoliation", coordinates = coords_bands,
                        blocking = factor(rep(1:4, c(479, 451, 294, 529))))

# log transform response variable -----------------------------------------

# task_vi %<>>%
#   cpoLogTrafoRegr()

# task_nri %<>>%
#   cpoLogTrafoRegr()

# save tasks --------------------------------------------------------------

saveRDS(task_vi, "~/00-inbox/task-VI-[paper3].rda")
saveRDS(task_nri, "~/00-inbox/task-NRI-[paper3].rda")
saveRDS(task_nri, "~/00-inbox/task-bands-[paper3].rda")

needs::needs(drake, hsdar, sf, raster, dplyr, purrr, glue, R.utils, pbmcapply,
             magrittr, stringr, ggplot2, furrr, data.table, mlrCPO, curl, stringr,
             fs)

# Plans -----------------------------------------------------------

data_plan = code_to_plan("analysis/data_preprocessing.R")
download_plan = code_to_plan("analysis/download.R")
hyperspectral_plan = code_to_plan("analysis/hyperspectral-processing.R")
# learners = code_to_plan("code/learner/learner.R")
# resampling = code_to_plan("code/mlr-settings/resampling.R")
# param_set = code_to_plan("code/mlr-settings/param-set.R")
# tune_ctrl = code_to_plan("code/mlr-settings/tune_ctrl_mbo.R")
# tuning_wrapper = code_to_plan("code/mlr-settings/tuning.R")
# sourceDirectory("code/benchmark/")
# sourceDirectory("code/prediction/")
# sourceDirectory("code/reports/")
#
sourceDirectory("R")

#  grouping for visualization -----------------------------------------------------------------------

data_plan$stage = "data"
download_plan$stage = "data"
hyperspectral_plan$stage = "data"
# resampling$stage = "mlr_settings"
# param_set$stage = "mlr_settings"
# tune_ctrl$stage = "mlr_settings"
# tuning_wrapper$stage = "learner"
# benchmark_plan$stage = "benchmark"
# prediction$stage = "prediction"
# reports$stage = "reports"

# # Combine all -------------------------------------------------------------
#
plan = bind_plans(data_plan, download_plan, hyperspectral_plan)

# set cores of targets

plan %<>%
  mutate(resources = case_when(target == "data_hs_preprocessed" ~
                                 list(list(cores = 20, gpus = 0)),
                               target == "coords" ~
                                 list(list(cores = 2, gpus = 0)),
                               TRUE ~ list(list(cores = 1, gpus = 0)))
  )

config = drake_config(plan)

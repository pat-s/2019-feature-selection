needs::needs(drake, hsdar, sf, raster, dplyr, purrr, glue, R.utils, pbmcapply,
             magrittr, stringr, ggplot2, furrr, data.table, mlrCPO)

# Plans -----------------------------------------------------------

data_plan = code_to_plan("code/data/data_preprocessing.R")
download_plan = code_to_plan("code/data/download.R")
hyperspectral_plan = code_to_plan("code/data/hyperspectral-processing.R")
# learners = code_to_plan("code/learner/learner.R")
# resampling = code_to_plan("code/mlr-settings/resampling.R")
# param_set = code_to_plan("code/mlr-settings/param-set.R")
# tune_ctrl = code_to_plan("code/mlr-settings/tune_ctrl_mbo.R")
# tuning_wrapper = code_to_plan("code/mlr-settings/tuning.R")
# sourceDirectory("code/benchmark/")
# sourceDirectory("code/prediction/")
# sourceDirectory("code/reports/")
#
sourceDirectory("code/functions/")
# source("https://raw.githubusercontent.com/mlr-org/mlr-extralearner/master/R/RLearner_classif_gam.R")
#
# # grouping for visualization
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

#
# # Combine all -------------------------------------------------------------
#
# plan_no_reports = bind_plans(data_plan, task, learners, resampling, param_set,
#                              tune_ctrl, tuning_wrapper, benchmark_plan, prediction)
# # For debugging target invalidation issues: https://github.com/ropensci/drake/issues/615
# plan_no_reports$command <- paste(
#   "{return(TRUE)\n {",
#   plan_no_reports$command,
#   "}}"
# )
#
# plan2 <- bind_plans(plan_no_reports, reports)
#
#
#
#
plan = bind_plans(data_plan, download_plan, hyperspectral_plan)

# set cores of targets
#plan$resources = list(list(cores = 1, gpus = 0))

plan %<>%
  mutate(resources = case_when(target == "data_hs_preprocessed" ~
                                 list(list(cores = 20, gpus = 0)),
                               target == "coords" ~
                                 list(list(cores = 2, gpus = 0)),
                               TRUE ~ list(list(cores = 1, gpus = 0)))
  )

#
# plan %<>% mutate(stage = as.factor(stage))
#
config = drake_config(plan)
# config2 = drake_config(plan2)
#
#
# # make(plan, keep_going = TRUE, console_log_file=stdout())
#
# # make(plan, targets = "bm_glm", keep_going = TRUE, console_log_file=stdout())
#
# # make(plan, targets = "pred_data", keep_going = TRUE, console_log_file=stdout())
#
# # make(plan, targets = "armillaria_data", keep_going = TRUE, console_log_file=stdout())
#
# # make(plan, targets = "slope", keep_going = TRUE, console_log_file=stdout())
#
# # make(plan, targets = "tasks", keep_going = TRUE, console_log_file=stdout(), jobs = 10)

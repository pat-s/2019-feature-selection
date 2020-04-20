# load packages ----------------------------------------------------------------

source("code/99-packages.R")

library("drake")
library("magrittr")
library("conflicted")
conflict_prefer("target", "drake")
conflict_prefer("pull", "dplyr")
suppressMessages(library("R.utils"))

# load mlr extra learner -------------------------------------------------------

source("https://raw.githubusercontent.com/mlr-org/mlr-extralearner/master/R/RLearner_regr_ranger_mtry_pow.R")

# source functions -------------------------------------------------------------

sourceDirectory("R")
# FIXME: This regex ignores the "project" folder temporarily
sourceDirectory("code")

# Combine all ------------------------------------------------------------------

plan_project <- bind_plans(
  download_data_plan,
  hyperspectral_processing_plan,
  sentinel_processing_plan,
  data_preprocessing_plan_buffer2,

  learner_project_plan,
  ps_project_plan,
  resampling_plan_project,
  task_project_plan,

  tune_ctrl_xgboost_project,
  tune_xgboost_plan_project,
  train_xgboost_plan_project,

  reports_plan_project
)

plan_paper <- bind_plans(
  download_data_plan,
  hyperspectral_processing_plan,
  # sentinel_processing_plan,

  data_preprocessing_plan_buffer2,
  data_preprocessing_plan_no_buffer,

  tasks_plan_buffer2,
  tasks_plan_no_buffer,

  filter_eda_plan,
  param_sets_plan,
  learners_plan,
  filter_wrapper_plan,
  resampling_plan,
  tune_ctrl_plan,
  tune_wrapper_plan,

  benchmark_plan_buffer2,
  # benchmark_plan_no_buffer,

  bm_aggregated_plan_buffer2,
  # bm_aggregated_plan_no_buffer,

  # train_plan,
  feature_imp_plan,
  reports_plan_paper
)

options(
  clustermq.scheduler = "slurm",
  clustermq.template = "~/papers/2019-feature-selection/slurm_clustermq.tmpl"
)

# plan_project %<>% dplyr::mutate(stage = as.factor(stage))
# plan_paper %<>% dplyr::mutate(stage = as.factor(stage))


# project ----------------------------------------------------------------------

drake_config(plan_project,
  targets = "prediction_df",
  verbose = 2, lazy_load = "eager",
  log_make = "log/drake-project.log",
  caching = "worker",
  template = list(
    log_file = "log/worker-project%a.log",
    n_cpus = 4,
    memory = 6000,
    partition = "all",
    job_name = "pred-defol"
  ),
  prework = list(
    quote(load_packages()),
    quote(set.seed(1, "L'Ecuyer-CMRG")),
    quote(future::plan(future::multisession))
    # quote(parallelStart(
    #   mode = "multicore",
    #   cpus = 12,
    #   level = "mlr.resample"
    # ))
  ),
  garbage_collection = TRUE,
  jobs = 1,
  parallelism = "clustermq",
  lock_envir = FALSE,
  keep_going = FALSE
)

# paper -----------------------------------------------------------------------

# not running in parallel because mclapply gets stuck sometimes
#
drake_config(plan_paper,
   targets = c(
  #   "spectral_signatures_wfr", "response_normality_wfr", "filter_correlations_wfr",
     "feature_importance_wfr", "eval_performance_wfr"
   ),
  verbose = 1,
  lazy_load = "eager",
  packages = NULL,
  log_make = "log/drake.log",
  caching = "master",
  template = list(
    log_file = "log/worker%a.log", n_cpus = 1,
    memory = 4000, job_name = "paper2",
    partition = "all"
  ),
  prework = list(
    quote(load_packages()),
    # quote(future::plan(callr, workers = 4)),
    quote(set.seed(1, "L'Ecuyer-CMRG")),
    quote(parallelStart(
      mode = "multicore",
      cpus = 4,
      level = "mlr.resample",
      mc.cleanup = TRUE,
      mc.preschedule = FALSE
    ))
  ),
  garbage_collection = TRUE, jobs = 2, parallelism = "clustermq",
  keep_going = FALSE, recover = TRUE, lock_envir = TRUE, lock_cache = FALSE
)

#
# drake_config(plan_paper,
#   targets = c("benchmark_tune_results_hr_nri_vi"),
#   verbose = 1,
#   lazy_load = "eager",
#   packages = NULL,
#   log_make = "log/drake2.log",
#   caching = "master",
#   template = list(
#     log_file = "log/worker2%a.log", n_cpus = 4,
#     memory = "4GB", job_name = "paper2", partition = "all"
#   ),
#   prework = list(
#     quote(load_packages()),
#     # quote(future::plan(callr, workers = 4)),
#     quote(set.seed(1, "L'Ecuyer-CMRG")),
#     quote(parallelStart(
#       mode = "multicore",
#       cpus = 4,
#       level = "mlr.resample",
#       mc.cleanup = TRUE,
#       mc.preschedule = FALSE
#     ))
#   ),
#   garbage_collection = TRUE, jobs = 3, parallelism = "clustermq",
#   keep_going = FALSE, recover = FALSE, lock_envir = TRUE, lock_cache = FALSE
# )

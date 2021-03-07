# load packages ----------------------------------------------------------------

source("code/099-packages.R")

library("drake")
library("magrittr")
library("conflicted")
conflict_prefer("target", "drake", quiet = TRUE)
conflict_prefer("pull", "dplyr", quiet = TRUE)
conflict_prefer("filter", "dplyr", quiet = TRUE)
suppressMessages(library("R.utils"))

options(clustermq.scheduler = "slurm")
# suppressPackageStartupMessages(library(future.clustermq))
# future::plan("clustermq")

Sys.setenv(DISPLAY = ":99")

# load mlr extra learner -------------------------------------------------------

source("https://raw.githubusercontent.com/mlr-org/mlr-extralearner/master/R/RLearner_regr_ranger_mtry_pow.R")

# source functions -------------------------------------------------------------

sourceDirectory("R")
sourceDirectory("code")

# Combine all ------------------------------------------------------------------

plan_project <- bind_plans(
  download_data_plan,
  hyperspectral_processing_plan,
  sentinel_processing_plan,
  data_preprocessing_plan,

  learner_project_plan,
  ps_project_plan,
  resampling_plan_project,
  tasks_plan,
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

  data_preprocessing_plan,

  tasks_plan,

  filter_eda_plan,
  param_sets_plan,
  learners_plan,
  filter_wrapper_plan,
  resampling_plan,
  tune_ctrl_plan,
  tune_wrapper_plan,

  benchmark_plan,

  bm_aggregated_plan,

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

# drake_config(plan_project,
#   # targets = "eda_wfr",
#   verbose = 1, lazy_load = "eager",
#   log_make = "log/drake-project.log",
#   caching = "worker",
#   template = list(
#     log_file = "log/worker-project%a.log",
#     n_cpus = 4,
#     memory = 20000,
#     partition = "all",
#     job_name = "pred-defol"
#   ),
#   prework = list(
#     quote(load_packages()),
#     quote(set.seed(1, "L'Ecuyer-CMRG")),
#     quote(future::plan(future::multisession, workers = 2))
#     # quote(parallelStart(
#     #   mode = "multicore",
#     #   cpus = 12,
#     #   level = "mlr.resample"
#     # ))
#   ),
#   garbage_collection = TRUE,
#   jobs = 4,
#   parallelism = "clustermq",
#   lock_envir = FALSE,
#   keep_going = FALSE
# )

# paper -----------------------------------------------------------------------

# config for long running tasks
drake_config(plan_paper,
   targets = c(
     c("tree_per_tree", "veg_indices", "nri_indices")
     # c("task_new_buffer07_reduced_cor")
   ),
  verbose = 1,
  lazy_load = "eager",
  packages = NULL,
  log_make = "log/drake-BM.log",
  caching = "main",
  template = list(
    # 60 unique workers with 4 cores/3.5G RAM on partition c0-c5
    log_file = "log/worker-BM%a.log", n_cpus = 4,
    memory = 3500, job_name = "paper2-BM",
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
      # level = "mlr.selectFeatures", # for MC feature selection
      mc.cleanup = TRUE,
      mc.preschedule = FALSE
    ))
  ),
  garbage_collection = TRUE,
  jobs = 3, parallelism = "clustermq",
  keep_going = FALSE, recover = FALSE, lock_envir = FALSE, lock_cache = FALSE
)

# config for sequential, quick tasks
# drake_config(plan_paper,
#   targets = c("eval_performance_wfr", "spectral_signatures_wfr", "filter_correlation_wfr"),
#   verbose = 1,
#   lazy_load = "eager",
#   packages = NULL,
#   log_make = "log/drake2.log",
#   caching = "main",
#   template = list(
#     log_file = "log/worker-single%a.log",
#     n_cpus = 4, memory = 4000,
#     job_name = "paper2-single", partition = "all"
#   ),
#   prework = list(
#     quote(load_packages()),
#     # quote(future::plan(callr, workers = 4)),
#     quote(set.seed(1, "L'Ecuyer-CMRG"))#,
#     # quote(parallelStart(
#     #   mode = "multicore",
#     #   cpus = 4,
#     #   level = "mlr.resample",
#     #   mc.cleanup = TRUE,
#     #   mc.preschedule = FALSE
#     # ))
#   ),
#   garbage_collection = TRUE, jobs = 3, parallelism = "clustermq",
#   keep_going = FALSE, recover = FALSE, lock_envir = TRUE, lock_cache = FALSE
# )

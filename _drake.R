# load R packages --------------------------------------------------------------

source("code/099-packages.R")

# create log directory
fs::dir_create("log")

library("drake")
library("magrittr")
library("conflicted")
conflict_prefer("target", "drake", quiet = TRUE)
conflict_prefer("pull", "dplyr", quiet = TRUE)
conflict_prefer("filter", "dplyr", quiet = TRUE)
suppressMessages(library("R.utils"))

Sys.setenv(DISPLAY = ":99")

options(
  # set this to "slurm" if you have access to a Slurm cluster
  clustermq.scheduler = "multicore",
  clustermq.template = "~/papers/2019-feature-selection/slurm_clustermq.tmpl"
)

# load mlr extra learner -------------------------------------------------------

source("https://raw.githubusercontent.com/mlr-org/mlr-extralearner/master/R/RLearner_regr_ranger_mtry_pow.R") # nolint

# source functions -------------------------------------------------------------

R.utils::sourceDirectory("R")
R.utils::sourceDirectory("code")

# Combine all plans ------------------------------------------------------------

plan_paper <- bind_plans(
  download_data_plan,
  hyperspectral_processing_plan,

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

  feature_imp_plan,
  reports_plan_paper
)

# paper ------------------------------------------------------------------------

# config for long running tasks
drake_config(plan_paper,
   targets = c(
     # replace this with the target name that should be computed
    #  c("eda_wfr")
    "benchmark_no_models"
   ),
  verbose = 1,
  lazy_load = "eager",
  packages = NULL,
  log_make = "log/drake-BM.log",
  caching = "main",
  template = list(
    log_file = "log/worker-BM%a.log", n_cpus = 4,
    memory = 3500, job_name = "paper2-BM",
    partition = "all"
  ),
  prework = list(
    quote(load_packages()),
    # seed for parallel tasks
    quote(set.seed(1, "L'Ecuyer-CMRG")),
    # intra-target parallelization (when running CV with mlr)
    quote(parallelStart(
      mode = "multicore",
      cpus = 4,
      level = "mlr.resample",
      # level = "mlr.selectFeatures", # for mlr feature importance calculation
      mc.cleanup = TRUE,
      mc.preschedule = FALSE
    ))
  ),
  garbage_collection = TRUE,
  jobs = 1,
  parallelism = "clustermq",
  keep_going = FALSE, recover = FALSE, lock_envir = FALSE, lock_cache = FALSE
)

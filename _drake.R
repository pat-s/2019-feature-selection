suppressPackageStartupMessages(library(drake))
suppressPackageStartupMessages(library(hsdar))
suppressPackageStartupMessages(library(sf))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(purrr))
suppressPackageStartupMessages(library(glue))
suppressPackageStartupMessages(library(R.utils))
suppressPackageStartupMessages(library(future))
suppressPackageStartupMessages(library(future.callr))
suppressPackageStartupMessages(library(future.apply))
suppressPackageStartupMessages(library(magrittr))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(furrr))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(mlrCPO))
suppressPackageStartupMessages(library(curl))
suppressPackageStartupMessages(library(fs))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(mapview))
suppressPackageStartupMessages(library(raster))

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

config = drake_config(plan)

options(
  clustermq.scheduler = "slurm",
  clustermq.template = "~/paper-hyperspectral/slurm_clustermq.tmpl"
)

# global within-target parallelism if not set specifically within a function
plan(future.callr::callr, workers = ignore(4))

drake_config(plan, verbose = 2, targets = "trees_with_indices", lazy_load = "promise", console_log_file = "log/drake.log",
             cache_log_file = "log/cache2.log",
             caching = "worker", template = list(log_file = "log/worker%a.log", n_cpus= 16),
             garbage_collection = TRUE, jobs = 1, parallelism = "clustermq")

source("analysis/99-packages.R")

# Plans -----------------------------------------------------------

download_plan = code_to_plan("analysis/01-download.R")
hyperspectral_plan = code_to_plan("analysis/02-hyperspectral-processing.R")
data_plan = code_to_plan("analysis/04-data-preprocessing.R")
learners = code_to_plan("analysis/05-modeling/learner.R")
resampling = code_to_plan("analysis/05-modeling/resamp.R")
param_set = code_to_plan("analysis/05-modeling/param-set.R")
tune_ctrl = code_to_plan("analysis/05-modeling/tune-ctrl.R")
tuning = code_to_plan("analysis/05-modeling/tune.R")
train = code_to_plan("analysis/05-modeling/train.R")
task = code_to_plan("analysis/05-modeling/task.R")
#
sourceDirectory("R")

#  grouping for visualization -----------------------------------------------------------------------

download_plan$stage = "download"
hyperspectral_plan$stage = "hyperspectral_preprocessing"
data_plan$stage = "data"

learners$stage = "modeling"
resampling$stage = "modeling"
param_set$stage = "modeling"
tune_ctrl$stage = "modeling"
tuning$stage = "modeling"
train$stage = "modeling"
task$stage = "modeling"
# benchmark_plan$stage = "benchmark"
# prediction$stage = "prediction"
# reports$stage = "reports"

# # Combine all -------------------------------------------------------------
#
plan = bind_plans(data_plan, download_plan, hyperspectral_plan, learners,
                  resampling, param_set, tune_ctrl, tuning, train, task)

plan %<>% mutate(stage = as.factor(stage))

options(
  clustermq.scheduler = "slurm",
  clustermq.template = "~/paper-hyperspectral/slurm_clustermq.tmpl"
)

# global within-target parallelism if not set specifically within a function
#plan(future.callr::callr, workers = ignore(7))

drake_config(plan, verbose = 2, targets = "train_xgboost", lazy_load = "promise", console_log_file = "log/drake.log",
             cache_log_file = "log/cache3.log",
             caching = "worker", template = list(log_file = "log/worker%a.log", n_cpus= 16),
             prework = quote(future::plan(future::multisession, workers = 3)),
             garbage_collection = TRUE, jobs = 1, parallelism = "clustermq")

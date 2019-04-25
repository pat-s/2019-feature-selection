source("analysis/99-packages.R")

# Plans -----------------------------------------------------------

download_plan = code_to_plan("analysis/01-download.R")
hyperspectral_plan = code_to_plan("analysis/02-hyperspectral-processing.R")
sentinel_plan = code_to_plan("analysis/03-sentinel-processing.R")
data_plan = code_to_plan("analysis/04-data-preprocessing.R")
learners_plan = code_to_plan("analysis/05-modeling/learner.R")
resampling_plan = code_to_plan("analysis/05-modeling/resamp.R")
param_set_plan = code_to_plan("analysis/05-modeling/param-set.R")
tune_ctrl_plan = code_to_plan("analysis/05-modeling/tune-ctrl.R")
tuning_plan = code_to_plan("analysis/05-modeling/tune.R")
train_plan = code_to_plan("analysis/05-modeling/train.R")
task_plan = code_to_plan("analysis/05-modeling/task.R")
source("analysis/06-reports.R")
#
sourceDirectory("R")

#  grouping for visualization -----------------------------------------------------------------------

download_plan$stage = "download"
hyperspectral_plan$stage = "hyperspectral_preprocessing"
data_plan$stage = "data"

learners_plan$stage = "modeling"
resampling_plan$stage = "modeling"
param_set_plan$stage = "modeling"
tune_ctrl_plan$stage = "modeling"
tuning_plan$stage = "modeling"
train_plan$stage = "modeling"
task_plan$stage = "modeling"
# benchmark_plan$stage = "benchmark"
# prediction$stage = "prediction"
reports_plan$stage = "reports"

# # Combine all -------------------------------------------------------------
#
plan = bind_plans(data_plan, download_plan, hyperspectral_plan, learners_plan,
                  resampling_plan, param_set_plan, tune_ctrl_plan, tuning_plan,
                  train_plan, task_plan, reports_plan, sentinel_plan
                  )
options(clustermq.scheduler = "slurm",
        clustermq.template = "~/papers/2019-feature-selection/slurm_clustermq.tmpl")

plan %<>% mutate(stage = as.factor(stage))

drake_config(plan,
             verbose = 2, targets = "hr_task", lazy_load = "promise",
             console_log_file = "log/drake.log", cache_log_file = "log/cache3.log",
             caching = "worker",
             template = list(log_file = "log/worker%a.log", n_cpus = 16, memory = 120000),
             prework = quote(future::plan(future::multisession, workers = 3)),
             garbage_collection = TRUE, jobs = 1, parallelism = "clustermq"
)

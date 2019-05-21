source("analysis/99-packages.R")

# Plans -----------------------------------------------------------

download_plan = code_to_plan("analysis/01-download.R")
hyperspectral_plan = code_to_plan("analysis/02-hyperspectral-processing.R")
sentinel_plan = code_to_plan("analysis/03-sentinel-processing.R")
data_plan = code_to_plan("analysis/04-data-preprocessing.R")

# project
learners_plan = code_to_plan("analysis/05-modeling/project/learner.R")
resampling_plan = code_to_plan("analysis/05-modeling/project/resamp.R")
param_set_plan = code_to_plan("analysis/05-modeling/project/param-set.R")
tune_ctrl_plan = code_to_plan("analysis/05-modeling/project/tune-ctrl.R")
tuning_plan = code_to_plan("analysis/05-modeling/project/tune.R")
train_plan = code_to_plan("analysis/05-modeling/project/train.R")
task_plan = code_to_plan("analysis/05-modeling/project/task.R")

# paper
learners_paper_plan = code_to_plan("analysis/05-modeling/paper/learner.R")
resampling_paper_plan = code_to_plan("analysis/05-modeling/paper/resampling.R")
param_set_paper_plan = code_to_plan("analysis/05-modeling/paper/param-sets.R")
tune_ctrl_paper_plan = code_to_plan("analysis/05-modeling/paper/tune-ctrl.R")
tuning_paper_plan = code_to_plan("analysis/05-modeling/paper/tune-wrapper.R")
bm_paper_plan = code_to_plan("analysis/06-benchmark-matrix.R")

source("analysis/07-reports.R")

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
bm_paper_plan$stage = "benchmark"
# prediction$stage = "prediction"
reports_plan$stage = "reports"

# # Combine all -------------------------------------------------------------
#
plan_project = bind_plans(data_plan, download_plan, hyperspectral_plan, learners_plan,
                          resampling_plan, param_set_plan, tune_ctrl_plan, train_plan,
                          task_plan, reports_plan, sentinel_plan
)

plan_paper = bind_plans(data_plan, download_plan, hyperspectral_plan, learners_paper_plan,
                        resampling_paper_plan, param_set_paper_plan, tune_ctrl_paper_plan,
                        tuning_paper_plan, bm_paper_plan
)

options(clustermq.scheduler = "slurm",
        clustermq.template = "~/papers/2019-feature-selection/slurm_clustermq.tmpl")

plan %<>% mutate(stage = as.factor(stage))


# project -----------------------------------------------------------------

# drake_config(plan_project,
#              verbose = 2, targets = "nri_task", lazy_load = "promise",
#              console_log_file = "log/drake.log", cache_log_file = "log/cache3.log",
#              caching = "worker",
#              template = list(log_file = "log/worker%a.log", n_cpus = 3, memory = 50000),
#              prework = quote(future::plan(future::multisession, workers = 3)),
#              garbage_collection = TRUE, jobs = 1, parallelism = "clustermq"
# )

# paper -------------------------------------------------------------------

drake_config(plan_paper,
             verbose = 2, targets = "nri_task", lazy_load = "promise",
             console_log_file = "log/drake.log", cache_log_file = "log/cache3.log",
             caching = "worker",
             template = list(log_file = "log/worker%a.log", n_cpus = 3, memory = 50000),
             prework = quote(future::plan(future::multisession, workers = 3)),
             garbage_collection = TRUE, jobs = 1, parallelism = "clustermq"
)

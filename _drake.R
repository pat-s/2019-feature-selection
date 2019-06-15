source("code/99-packages.R")

# Plans -----------------------------------------------------------

download_plan = code_to_plan("code/01-download.R")
hyperspectral_plan = code_to_plan("code/02-hyperspectral-processing.R")
sentinel_plan = code_to_plan("code/03-sentinel-processing.R")
data_plan = code_to_plan("code/04-data-preprocessing.R")

# project
learners_plan = code_to_plan("code/05-modeling/project/learner.R")
resampling_plan = code_to_plan("code/05-modeling/project/resamp.R")
param_set_plan = code_to_plan("code/05-modeling/project/param-set.R")
tune_ctrl_plan = code_to_plan("code/05-modeling/project/tune-ctrl.R")
tuning_plan = code_to_plan("code/05-modeling/project/tune.R")
train_plan = code_to_plan("code/05-modeling/project/train.R")
task_plan = code_to_plan("code/05-modeling/project/task.R")

# paper
learners_paper_plan = code_to_plan("code/05-modeling/paper/learner.R")
resampling_paper_plan = code_to_plan("code/05-modeling/paper/resampling.R")
param_set_paper_plan = code_to_plan("code/05-modeling/paper/param-sets.R")
tune_ctrl_paper_plan = code_to_plan("code/05-modeling/paper/tune-ctrl.R")
filter_paper_plan = code_to_plan("code/05-modeling/paper/filter-wrapper.R")
pca_paper_plan = code_to_plan("code/05-modeling/paper/pca-wrapper.R")
tuning_paper_plan = code_to_plan("code/05-modeling/paper/tune-wrapper.R")
source("code/06-benchmark-matrix.R")

source("code/07-reports.R")

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
bm_plan$stage = "benchmark"
# prediction$stage = "prediction"
reports_plan_paper$stage = "reports"

# # Combine all -------------------------------------------------------------
#
plan_project = bind_plans(data_plan, download_plan, hyperspectral_plan, learners_plan,
                          resampling_plan, param_set_plan, tune_ctrl_plan, train_plan,
                          tuning_plan, task_plan, reports_plan_project, sentinel_plan
)

plan_paper = bind_plans(data_plan, download_plan, hyperspectral_plan, learners_paper_plan,
                        resampling_paper_plan, param_set_paper_plan, tune_ctrl_paper_plan,
                        filter_paper_plan, tuning_paper_plan, bm_plan, reports_plan_paper,
                        pca_paper_plan
)

options(clustermq.scheduler = "slurm",
        clustermq.template = "~/papers/2019-feature-selection/slurm_clustermq.tmpl")

plan_project %<>% mutate(stage = as.factor(stage))
plan_paper %<>% mutate(stage = as.factor(stage))


# project -----------------------------------------------------------------

# drake_config(plan_project,
#              verbose = 2, targets = "defoliation_maps_wfr", lazy_load = "promise",
#              console_log_file = "log/drake.log", cache_log_file = "log/cache3.log",
#              caching = "worker",
#              template = list(log_file = "log/worker%a.log", n_cpus = 3, memory = 50000),
#              prework = quote(future::plan(future::multisession, workers = 3)),
#              garbage_collection = TRUE, jobs = 1, parallelism = "clustermq"
# )

# paper -------------------------------------------------------------------

# drake_config(plan_paper,
#              verbose = 2, lazy_load = "promise",
#              console_log_file = "log/drake.log", cache_log_file = "log/cache3.log",
#              caching = "worker",
#              template = list(log_file = "log/worker%a.log", n_cpus = 4, memory = 40000),
#              prework = quote(future::plan(future::multiprocess, workers = 4)),
#              garbage_collection = TRUE, jobs = 4, parallelism = "clustermq"
# )


drake_config(plan_paper, target = c("spectral_signatures_wfr", "eda_wfr"),
             verbose = 2, lazy_load = "promise",
             console_log_file = "log/drake2.log",
             caching = "worker",
             template = list(log_file = "log/2-worker%a.log", n_cpus = 1, memory = 10000),
             #prework = quote(future::plan(future::multiprocess, workers = 4)),
             garbage_collection = TRUE, jobs = 1, parallelism = "clustermq"
)

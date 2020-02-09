# load packages ----------------------------------------------------------------

source("code/99-packages.R")

library("drake")
library("magrittr")
suppressMessages(library("R.utils"))

# load mlr extra learner -------------------------------------------------------

source("https://raw.githubusercontent.com/mlr-org/mlr-extralearner/master/R/RLearner_regr_ranger_mtry_pow.R")

# Plans ------------------------------------------------------------------------

# project
# learners_plan = code_to_plan("code/05-modeling/project/learner.R")
# resampling_plan = code_to_plan("code/05-modeling/project/resamp.R")
# param_set_plan = code_to_plan("code/05-modeling/project/param-set.R")
# tune_ctrl_plan = code_to_plan("code/05-modeling/project/tune-ctrl.R")
# tuning_plan = code_to_plan("code/05-modeling/project/tune.R")
# train_plan = code_to_plan("code/05-modeling/project/train.R")
# task_plan = code_to_plan("code/05-modeling/project/task.R")

sourceDirectory("R")
# FIXME: This regex ignores the "project" folder temporarily
sourceDirectory("code")

# # Combine all ----------------------------------------------------------------

# plan_project = bind_plans(data_plan, download_plan, hyperspectral_plan, learners_plan,
#                           resampling_plan, param_set_plan, tune_ctrl_plan, train_plan,
#                           tuning_plan, task_plan, reports_plan_project, sentinel_plan
# )

plan_paper = bind_plans(download_data_plan,
                        hyperspectra_processing_plan,
                        sentinel_processing_plan,
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
                        train_plan,
                        feature_imp_plan
)

options(clustermq.scheduler = "slurm",
        clustermq.template = "~/papers/2019-feature-selection/slurm_clustermq.tmpl")

# plan_project %<>% dplyr::mutate(stage = as.factor(stage))
# plan_paper %<>% dplyr::mutate(stage = as.factor(stage))


# project ----------------------------------------------------------------------

# drake_config(plan_paper,
#              verbose = 2, lazy_load = "eager",
#              console_log_file = "log/drake.log",
#              caching = "worker",
#              template = list(log_file = "log/worker%a.log", n_cpus = 4, memory = "12G", job_name = "paper2"),
#              # prework = list(
#              #   #uote(future::plan(future::multisession, workers = 25))#,
#              #   #quote(future::plan(future.callr::callr, workers = 4))
#              #   quote(parallelStart(
#              #     mode = "multicore", cpus = ignore(25)))
#              # ),
#              prework = list(quote(set.seed(1, "L'Ecuyer-CMRG")),
#                             quote(parallelStart(mode = "multicore", cpus = 4, level = "mlr.resample"))
#              ),
#              garbage_collection = TRUE, jobs = 55, parallelism = "clustermq", lock_envir = FALSE,
#              keep_going = TRUE
# )

# paper -----------------------------------------------------------------------

# not running in parallel because mclapply gets stuck sometimes

drake_config(plan_paper,
             # targets = c("bm_vi_task_svm_borda_mbo", "bm_vi_task_xgboost_borda_mbo",
             #             "bm_vi_task_rf_borda_mbo"),
             # targets = c("bm_hr_task_corrected_xgboost_borda_mbo", "bm_hr_task_corrected_xgboost_cmim_mbo",
             #             "bm_hr_task_corrected_rf_mrmr_mbo", "bm_hr_task_corrected_xgboost_mrmr_mbo",
             #             "bm_hr_task_corrected_svm_carscore_mbo"),
             targets = "benchmark_no_models_new",
             #targets = c("vi_task", "hr_task", "nri_task", "hr_nri_vi_task", "hr_nri_task", "hr_vi_task"),
             verbose = 2,
             lazy_load = "eager",
             packages = NULL,
             console_log_file = "log/drake.log",
             caching = "master",
             template = list(log_file = "log/worker%a.log", n_cpus = 4,
                             memory = 6000, job_name = "paper2",
                             partition = "all"),
             # prework = quote(future::plan(future::multisession, workers = 4)),
             prework = list(quote(load_packages()),
                            #quote(future::plan(callr, workers = 4)),
                            quote(set.seed(1, "L'Ecuyer-CMRG")),
                            quote(parallelStart(mode = "multicore",
                                                cpus = 4,
                                                #level = "mlr.resample",
                                                mc.cleanup = TRUE,
                                                mc.preschedule = FALSE))
             ),
             garbage_collection = TRUE, jobs = 40, parallelism = "clustermq",
             keep_going = TRUE, recover = TRUE, lock_envir = TRUE, lock_cache = FALSE
)


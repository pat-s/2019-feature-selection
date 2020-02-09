# see https://ropenscilabs.github.io/drake-manual/plans.html#large-plans

benchmark_plan <- drake_plan(

  tasks_bm_old = list(
    task_old_hr,
    task_old_vi,
    task_old_nri,
    task_old_hr_nri,
    task_old_nri_vi,
    task_old_hr_nri_vi
  ),

  tasks_bm_new = list(
    task_new_hr,
    task_new_vi,
    task_new_nri,
    task_new_hr_nri,
    task_new_nri_vi,
    task_new_hr_nri_vi
  ),

  learners_penalized = list(
    lrn_lasso,
    lrn_ridge
  ),

  benchmark_no_models_new = target(
    benchmark(
      learners = tune_wrappers_mbo,
      tasks = tasks_bm_new[[1]],
      models = FALSE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean)
      )
    ),
    dynamic = cross(tune_wrappers_mbo, tasks_bm_new)
  ),

  benchmark_no_models_new_penalized = target(
    benchmark(
      learners = learners_penalized[[1]],
      tasks = tasks_bm_new[[1]],
      models = FALSE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean)
      )
    ),
    dynamic = cross(learners_penalized, tasks_bm_new)
  ),

  benchmark_no_models_old = target(
    benchmark(
      learners = tune_wrappers_mbo,
      tasks = tasks_bm[[1]],
      models = FALSE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean)
      )
    ),
    dynamic = cross(tune_wrappers_mbo, tasks_bm_old)
  ),
)

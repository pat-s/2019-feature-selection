# see https://ropenscilabs.github.io/drake-manual/plans.html#large-plans

benchmark_plan_no_buffer <- drake_plan(

  benchmark_no_models_new_no_buffer = target(
    benchmark(
      learners = tune_wrappers_mbo,
      tasks = task_new_no_buffer,
      models = FALSE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean)
      )
    ),
    dynamic = cross(tune_wrappers_mbo, task_new_no_buffer)
  ),

  benchmark_no_models_new_penalized_no_buffer = target(
    benchmark(
      learners = learners_penalized[[1]],
      tasks = task_new_no_buffer[[1]],
      models = FALSE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean)
      )
    ),
    dynamic = cross(learners_penalized, task_new_no_buffer)
  ),

  benchmark_models_new_penalized_no_buffer = target(
    benchmark(
      learners = learners_penalized[[1]],
      tasks = task_new_no_buffer[[1]],
      models = TRUE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean)
      )
    ),
    dynamic = cross(learners_penalized, task_new_no_buffer)
  ),

  # used in response-normality.Rmd
  benchmark_models_new_no_buffer = target(
    benchmark(
      learners = learners_keep_models[[1]],
      tasks = task_new_no_buffer[[1]],
      models = TRUE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean)
      )
    ),
    dynamic = cross(learners_keep_models, task_new_no_buffer)
  )
)

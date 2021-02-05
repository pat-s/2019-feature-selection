# see https://ropenscilabs.github.io/drake-manual/plans.html#large-plans

benchmark_plan_buffer2 <- drake_plan(

  learners_penalized = list(
    lrn_lasso,
    lrn_ridge
  ),

  learners_keep_models = list(
    tune_wrappers_mbo %>%
      keep(~ "SVM MBO MRMR" %in% .x$id)
  ),

  benchmark_no_models_new_buffer2 = target(
    benchmark(
      learners = tune_wrappers_mbo,
      tasks = task_new_buffer2_reduced_cor,
      models = FALSE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean),
        setAggregation(rsq, test.mean)
      )
    ),
    dynamic = cross(tune_wrappers_mbo, task_new_buffer2_reduced_cor)
  ),

  tune_wrappers_mbo_inspect_tune = tune_wrappers_mbo[c(1, 20, 15)],
  task_hr_nri_vi = task_new_buffer2_reduced_cor[6],
  benchmark_tune_results_hr_nri_vi = target(
    benchmark(
      learners = tune_wrappers_mbo_inspect_tune,
      tasks = task_hr_nri_vi,
      models = FALSE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean),
        setAggregation(rsq, test.mean)
      ),
      keep.extract = TRUE
    ),
    # SVM: Relief
    # RF: Car
    # XG: Borda
    dynamic = cross(tune_wrappers_mbo_inspect_tune, task_hr_nri_vi)
  ),

  benchmark_models_new_penalized_mbo_buffer2 = target(
    benchmark(
      learners = learners_penalized,
      tasks = task_new_buffer2,
      models = TRUE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean),
        setAggregation(rsq, test.mean)
      )
    ),
    dynamic = cross(learners_penalized, task_new_buffer2)
  ),

  benchmark_no_models_new_penalized_mbo_buffer2 = target(
    benchmark(
      learners = learners_penalized,
      tasks = task_new_buffer2,
      models = FALSE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean),
        setAggregation(rsq, test.mean)
      )
    ),
    dynamic = cross(learners_penalized, task_new_buffer2)
  ),

  # used in response-normality.Rmd
  benchmark_models_new_buffer2 = target(
    benchmark(
      learners = learners_keep_models[[1]],
      tasks = task_new_buffer2,
      models = TRUE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean),
        setAggregation(rsq, test.mean)
      )
    ),
    dynamic = cross(learners_keep_models[[1]], task_new_buffer2)
  ),

  benchmark_no_models_old_buffer2 = target(
    benchmark(
      learners = tune_wrappers_mbo,
      tasks = task_old_buffer2,
      models = FALSE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean),
        setAggregation(rsq, test.mean)
      )
    ),
    dynamic = cross(tune_wrappers_mbo, task_old_buffer2)
  ),

  benchmark_models_new_penalized_mbo_buffer2_trim_cor = target(
    benchmark(
      learners = learners_penalized,
      tasks = task_new_buffer2,
      models = TRUE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean),
        setAggregation(rsq, test.mean)
      )
    ),
    dynamic = cross(learners_penalized, task_new_buffer2_reduced_cor)
  ),
)

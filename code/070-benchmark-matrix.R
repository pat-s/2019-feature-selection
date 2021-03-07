# see https://ropenscilabs.github.io/drake-manual/plans.html#large-plans

benchmark_plan <- drake_plan(

  learners_penalized = list(
    lrn_lasso,
    lrn_ridge
  ),

  learners_keep_models = list(
    tune_wrappers_mbo %>%
      keep(~ "SVM MBO MRMR" %in% .x$id)
  ),

  tune_wrappers_mbo_xg = tune_wrappers_mbo[7:12],

  # 174 targets
  benchmark_no_models = target(
    benchmark(
      learners = tune_wrappers_mbo_xg[[1]],
      tasks = task_reduced_cor,
      models = FALSE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean),
        setAggregation(rsq, test.mean),
        setAggregation(expvar, test.mean)
      )
    ),
    dynamic = cross(tune_wrappers_mbo_xg, task_reduced_cor),
    resources = list(ncpus = 4, memory = 3500, njobs = 174)
  ),

  tune_wrappers_mbo_inspect_tune = tune_wrappers_mbo[c(1, 20, 15)],
  task_hr_nri_vi = task_reduced_cor[6],

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
        setAggregation(rsq, test.mean),
        setAggregation(expvar, test.mean)
      ),
      keep.extract = TRUE
    ),
    # SVM: Relief
    # RF: Car
    # XG: Borda
    dynamic = cross(tune_wrappers_mbo_inspect_tune, task_hr_nri_vi)
  ),

  benchmark_models_penalized_mbo = target(
    benchmark(
      learners = learners_penalized,
      tasks = task,
      models = TRUE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean),
        setAggregation(rsq, test.mean),
        setAggregation(expvar, test.mean)
      )
    ),
    dynamic = cross(learners_penalized, task)
  ),

  benchmark_no_models_penalized_mbo = target(
    benchmark(
      learners = learners_penalized,
      tasks = task,
      models = FALSE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean),
        setAggregation(rsq, test.mean),
        setAggregation(expvar, test.mean)
      )
    ),
    dynamic = cross(learners_penalized, task)
  ),

  # used in response-normality.Rmd
  benchmark_models = target(
    benchmark(
      learners = learners_keep_models[[1]],
      tasks = task,
      models = TRUE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean),
        setAggregation(rsq, test.mean),
        setAggregation(expvar, test.mean)
      )
    ),
    dynamic = cross(learners_keep_models[[1]], task)
  ),


  benchmark_models_penalized_mbo_trim_cor = target(
    benchmark(
      learners = learners_penalized,
      tasks = task,
      models = TRUE,
      keep.pred = TRUE,
      resamplings = makeResampleDesc("CV", fixed = TRUE),
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean),
        setAggregation(rsq, test.mean),
        setAggregation(expvar, test.mean)
      )
    ),
    dynamic = cross(learners_penalized, task_reduced_cor)
  ),
)

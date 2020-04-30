tune_xgboost_plan_project <- drake_plan(
  tune_xgboost = target(
    tune_wrapper(
      learner = lrn_xgboost,
      tune.control = tune_ctrl_xgboost, show.info = TRUE,
      par.set = ps_xgboost, resampling = resampl_inner,
      measure = list(rmse), task = task_7_most_imp
    )
  )
)

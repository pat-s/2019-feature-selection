learner_project_plan <- drake_plan(
  lrn_xgboost_proj = target(
    makeLearner("regr.xgboost",
      par.vals = list(
        objective = "reg:linear",
        eval_metric = "error"
      )
    )
  )
)

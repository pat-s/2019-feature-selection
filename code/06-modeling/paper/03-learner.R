learners_plan <- drake_plan(

  # Random Forest --------------------------------------------------------------
  lrn_rf = target(
    makeLearner(
      "regr.ranger.pow"
    )
  ),

  # XGBOOST --------------------------------------------------------------------

  lrn_xgboost = target(
    makeLearner(
      "regr.xgboost",
      par.vals = list(
        objective = "reg:linear",
        eval_metric = "error"
      )
    )
  ),

  # SVM ------------------------------------------------------------------------

  lrn_svm = target(
    makeLearner(
      "regr.ksvm",
      scaled = FALSE,
      fit = FALSE
    )
  ),

  # LASSO ----------------------------------------------------------------------

  lrn_lasso = target(
    makeLearner("regr.glmnet",
      id = "Lasso-CV",
      alpha = 1,
      standardize = FALSE,
      intercept = FALSE
    )
  ),

  # lrn_lassocv = target(
  #   makeLearner("regr.cvglmnet",
  #     id = "Lasso-CV",
  #     alpha = 1,
  #     standardize = FALSE,
  #     intercept = FALSE
  #   )
  # ),

  # RIDGE ----------------------------------------------------------------------

  lrn_ridge = target(
    makeLearner("regr.glmnet",
      id = "Ridge-CV",
      alpha = 0,
      standardize = FALSE,
      intercept = FALSE
    )
  )

  # lrn_ridgecv = target(
  #   makeLearner("regr.cvglmnet",
  #     id = "Ridge-CV",
  #     alpha = 0,
  #     standardize = FALSE,
  #     intercept = FALSE
  #   )
  # )
)

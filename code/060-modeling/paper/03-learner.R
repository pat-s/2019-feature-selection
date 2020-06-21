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

  # how to tune lambda for glmnet:
  # https://stats.stackexchange.com/a/415248/101464

  # We tune param 's' manually by supplying our own vector for 's'
  lrn_lasso = target(
    makeLearner("regr.glmnet",
      id = "Lasso-MBO",
      alpha = 1,
      standardize = FALSE
    )
  ),

  lrn_lassocv = target(
    makeLearner("regr.glmnet",
      id = "Lasso-CV",
      alpha = 1,
      lambda = seq(0, 10, 1),
      standardize = FALSE
    )
  ),

  # RIDGE ----------------------------------------------------------------------

  # We tune param 's' manually by supplying our own vector for 's'
  lrn_ridge = target(
    makeLearner("regr.glmnet",
      id = "Ridge-MBO",
      alpha = 0,
      standardize = FALSE
    )
  ),

  lrn_ridgecv = target(
    makeLearner("regr.glmnet",
      id = "Ridge-CV",
      alpha = 0,
      lambda = seq(0, 10, 1),
      standardize = FALSE
    )
  )
)

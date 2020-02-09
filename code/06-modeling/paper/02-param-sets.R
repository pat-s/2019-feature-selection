param_sets_plan <- drake_plan(

  # XGBOOST --------------------------------------------------------------------

  ps_xgboost_filter = target(
    makeParamSet(
      makeIntegerParam("nrounds", lower = 10, upper = 600),
      makeNumericParam("colsample_bytree", lower = 0.3, upper = 0.7),
      makeNumericParam("subsample", lower = 0.25, upper = 1),
      makeIntegerParam("max_depth", lower = 1, upper = 10),
      makeNumericParam("gamma", lower = 0, upper = 10),
      makeNumericParam("eta", lower = 0.001, upper = 0.6),
      makeNumericParam("min_child_weight", lower = 0, upper = 20),
      makeNumericParam("fw.perc", lower = 0, upper = 1)
    )
  ),

  ps_xgboost = target(
    makeParamSet(
      makeIntegerParam("nrounds", lower = 10, upper = 600),
      makeNumericParam("colsample_bytree", lower = 0.3, upper = 0.7),
      makeNumericParam("subsample", lower = 0.25, upper = 1),
      makeIntegerParam("max_depth", lower = 1, upper = 10),
      makeNumericParam("gamma", lower = 0, upper = 10),
      makeNumericParam("eta", lower = 0.001, upper = 0.6),
      makeNumericParam("min_child_weight", lower = 0, upper = 20)
    )
  ),

  ps_xgboost_pca = target(
    makeParamSet(
      makeIntegerParam("nrounds", lower = 10, upper = 600),
      makeNumericParam("colsample_bytree", lower = 0.3, upper = 0.7),
      makeNumericParam("subsample", lower = 0.25, upper = 1),
      makeIntegerParam("max_depth", lower = 1, upper = 10),
      makeNumericParam("gamma", lower = 0, upper = 10),
      makeNumericParam("eta", lower = 0.001, upper = 0.6),
      makeNumericParam("min_child_weight", lower = 0, upper = 20),
      makeIntegerParam("ppc.pcaComp", lower = 1, upper = 10)
    )
  ),

  # SVM ------------------------------------------------------------------------

  ps_svm_filter = target(
    makeParamSet(
      makeNumericParam("C",
        lower = -10, upper = 10,
        trafo = function(x) 2^x
      ),
      makeNumericParam("sigma",
        lower = -5, upper = 5,
        trafo = function(x) 2^x
      ),
      makeNumericParam("fw.perc", lower = 0, upper = 1)
    )
  ),

  ps_svm = target(
    makeParamSet(
      makeNumericParam("C",
        lower = -10, upper = 10,
        trafo = function(x) 2^x
      ),
      makeNumericParam("sigma",
        lower = -5, upper = 5,
        trafo = function(x) 2^x
      )
    )
  ),

  ps_svm_pca = target(
    makeParamSet(
      makeNumericParam("C",
        lower = -10, upper = 10,
        trafo = function(x) 2^x
      ),
      makeNumericParam("sigma",
        lower = -5, upper = 5,
        trafo = function(x) 2^x
      ),
      makeIntegerParam("ppc.pcaComp", lower = 1, upper = 10)
    )
  ),

  # Random Forest --------------------------------------------------------------

  ps_rf_filter = target(
    makeParamSet(
      makeNumericParam("mtry.power", lower = 0, upper = 0.5),
      makeIntegerParam("min.node.size", lower = 1, upper = 10),
      makeNumericParam("sample.fraction", lower = 0.2, upper = 0.9),
      makeNumericParam("fw.perc", lower = 0, upper = 1)
    )
  ),

  ps_rf = target(
    makeParamSet(
      makeNumericParam("mtry.power", lower = 0, upper = 0.5),
      makeIntegerParam("min.node.size", lower = 1, upper = 10),
      makeNumericParam("sample.fraction", lower = 0.2, upper = 0.9)
    )
  ),

  ps_rf_pca = target(
    makeParamSet(
      makeNumericParam("mtry.power", lower = 0, upper = 0.5),
      makeIntegerParam("min.node.size", lower = 1, upper = 10),
      makeNumericParam("sample.fraction", lower = 0.2, upper = 0.9),
      makeIntegerParam("ppc.pcaComp", lower = 1, upper = 10)
    )
  ),

  # RIDGE ----------------------------------------------------------------------

  quan_ridge = target({

    # calculate lower and upper boundaries of param set for RR
    # SPECIAL:
    # Actually, we would need to calculate one ParamSet per Task (because we need
    # to calculate min and max lambda for each ParamSet. But this would mean
    # having multiple learner IDs which we would need to apply to all tasks to be
    # able to use `mergeBenchmarkResult()` on them later This makes no sense with
    # task specific ParamSets, hence we create one universal ParamSet Consisting
    # of of the 80% quantile from the min and max of the smallest and largest
    # task, respectively)

    lambda_ridge_vi_train <- train(lrn_ridge, task_new_vi)
    lambda_ridge_hr_nri_vi_train <- train(lrn_ridge, task_new_hr_nri_vi)

    lambda_ridge_min_vi <- min(lambda_ridge_vi_train$learner.model$lambda)
    lambda_ridge_max_hr_nri_vi <- max(lambda_ridge_hr_nri_vi_train$learner.model$lambda)

    quantile(
      x = c(lambda_ridge_min_vi, lambda_ridge_max_hr_nri_vi),
      probs = c(0.20, 0.80)
    )
  }),

  ps_ridge = target(
    makeParamSet(
      makeNumericParam("s",
        lower = quan_ridge[1],
        upper = quan_ridge[2]
      )
    )
  ),

  # LASSO ---------------------------------------------------------------------

  quan_lasso = target({

    # calculate lower and upper boundaries of param set for RR
    # SPECIAL:
    # Actually, we would need to calculate one ParamSet per Task (because we
    # need to calculate min and max lambda for each ParamSet. But this would
    # mean having multiple learner IDs which we would need to apply to all tasks
    # to be able to use `mergeBenchmarkResult()` on them later This makes no
    # sense with task specific ParamSets, hence we create one universal ParamSet
    # consisting of of the 80% quantile from the min and max of the smallest and
    # largest task, respectively)

    lambda_lasso_vi_train <- train(lrn_lasso, task_new_vi)
    lambda_lasso_hr_nri_vi_train <- train(lrn_lasso, task_new_hr_nri_vi)

    lambda_lasso_min_vi <- min(lambda_lasso_vi_train$learner.model$lambda)
    lambda_lasso_max_hr_nri_vi <- max(lambda_lasso_hr_nri_vi_train$learner.model$lambda)

    quantile(
      x = c(lambda_lasso_min_vi, lambda_lasso_max_hr_nri_vi),
      probs = c(0.10, 0.90)
    )
  }),

  ps_lasso = target(
    makeParamSet(makeNumericParam("s",
      lower = quan_lasso[1],
      upper = quan_lasso[2]
    ))
  )

)

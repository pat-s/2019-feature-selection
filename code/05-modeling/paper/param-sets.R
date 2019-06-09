# XGBOOST -----------------------------------------------------------------

ps_xgboost_filter = makeParamSet(
  makeIntegerParam("nrounds", lower = 10, upper = 600),
  makeNumericParam("colsample_bytree", lower = 0.3, upper = 0.7),
  makeNumericParam("subsample", lower = 0.25, upper = 1),
  makeIntegerParam("max_depth", lower = 1, upper = 10),
  makeNumericParam("gamma", lower = 0, upper = 10),
  makeNumericParam("eta", lower = 0.001, upper = 0.6),
  makeNumericParam("min_child_weight", lower = 0, upper = 20),
  makeNumericParam("fw.perc", lower = 0, upper = 1)
)

ps_xgboost = makeParamSet(
  makeIntegerParam("nrounds", lower = 10, upper = 600),
  makeNumericParam("colsample_bytree", lower = 0.3, upper = 0.7),
  makeNumericParam("subsample", lower = 0.25, upper = 1),
  makeIntegerParam("max_depth", lower = 1, upper = 10),
  makeNumericParam("gamma", lower = 0, upper = 10),
  makeNumericParam("eta", lower = 0.001, upper = 0.6),
  makeNumericParam("min_child_weight", lower = 0, upper = 20)
)

# SVM ---------------------------------------------------------------------

ps_svm_filter = makeParamSet(
  makeNumericParam("cost", lower = -10, upper = 10,
                   trafo = function(x) 2 ^ x),
  makeNumericParam("gamma", lower = -5, upper = 5,
                   trafo = function(x) 2 ^ x),
  makeNumericParam("fw.perc", lower = 0, upper = 1)
)

ps_svm = makeParamSet(
  makeNumericParam("cost", lower = -10, upper = 10,
                   trafo = function(x) 2 ^ x),
  makeNumericParam("gamma", lower = -5, upper = 5,
                   trafo = function(x) 2 ^ x)
)

# Random Forest -----------------------------------------------------------

ps_rf_filter = makeParamSet(
  makeIntegerParam("mtry", lower = 1, upper = 90),
  makeIntegerParam("min.node.size", lower = 1, upper = 10),
  makeNumericParam("sample.fraction", lower = 0.2, upper = 0.9),
  makeNumericParam("fw.perc", lower = 0, upper = 1)
)

ps_rf = makeParamSet(
  makeIntegerParam("mtry", lower = 1, upper = 90),
  makeIntegerParam("min.node.size", lower = 1, upper = 10),
  makeNumericParam("sample.fraction", lower = 0.2, upper = 0.9)
)

# RIDGE ---------------------------------------------------------------------

# calculate lower and upper boundaries of param set for RR
lambda_ridge_min_nri = train(lrn_ridge, nri_task)
lambda_ridge_min_vi = train(lrn_ridge, vi_task)
lambda_ridge_min_hr = train(lrn_ridge, hr_task)
lambda_ridge_min = which.min(c(lambda_ridge_min_nri, lambda_ridge_min_vi, lambda_ridge_min_hr))

lambda_ridge_max_nri = train(lrn_ridge, nri_task)
lambda_ridge_max_vi = train(lrn_ridge, vi_task)
lambda_ridge_max_hr = train(lrn_ridge, hr_task)
lambda_ridge_max = which.max(c(lambda_ridge_max_nri, lambda_ridge_max_vi, lambda_ridge_max_hr))

ps_ridge_filter <- makeParamSet(makeNumericParam("s", lower = lambda_ridge_min,
                                                 upper = lambda_ridge_max),
                                makeNumericParam("fw.perc", lower = 0, upper = 1)
)

ps_ridge <- makeParamSet(makeNumericParam("s", lower = lambda_ridge_min,
                                          upper = lambda_ridge_max)
)

# LASSO ---------------------------------------------------------------------

# calculate lower and upper boundaries of param set for RR
lambda_lasso_min_nri = train(lrn_lasso, nri_task)
lambda_lasso_min_vi = train(lrn_lasso, vi_task)
lambda_lasso_min_hr = train(lrn_lasso, hr_task)
lambda_lasso_min = which.min(c(lambda_lasso_min_nri, lambda_lasso_min_vi, lambda_lasso_min_hr))

lambda_lasso_max_nri = train(lrn_lasso, nri_task)
lambda_lasso_max_vi = train(lrn_lasso, vi_task)
lambda_lasso_max_hr = train(lrn_lasso, hr_task)
lambda_lasso_max = which.max(c(lambda_lasso_max_nri, lambda_lasso_max_vi, lambda_lasso_max_hr))

ps_lasso_filter <- makeParamSet(makeNumericParam("s", lower = lambda_lasso_min,
                                                 upper = lambda_lasso_max),
                                makeNumericParam("fw.perc", lower = 0, upper = 1)
)

ps_lasso <- makeParamSet(makeNumericParam("s", lower = lambda_lasso_min,
                                          upper = lambda_lasso_max)
)

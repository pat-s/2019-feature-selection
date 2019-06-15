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

ps_xgboost_pca =  makeParamSet(
    makeIntegerParam("nrounds", lower = 10, upper = 600),
    makeNumericParam("colsample_bytree", lower = 0.3, upper = 0.7),
    makeNumericParam("subsample", lower = 0.25, upper = 1),
    makeIntegerParam("max_depth", lower = 1, upper = 10),
    makeNumericParam("gamma", lower = 0, upper = 10),
    makeNumericParam("eta", lower = 0.001, upper = 0.6),
    makeNumericParam("min_child_weight", lower = 0, upper = 20),
    makeIntegerParam("ppc.pcaComp", lower = 1, upper = 10)
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

ps_svm_pca =  makeParamSet(
    makeNumericParam("cost", lower = -10, upper = 10,
                     trafo = function(x) 2 ^ x),
    makeNumericParam("gamma", lower = -5, upper = 5,
                     trafo = function(x) 2 ^ x),
    makeIntegerParam("ppc.pcaComp", lower = 1, upper = 10)
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

ps_rf_pca = makeParamSet(
    makeIntegerParam("mtry", lower = 1, upper = 90),
    makeIntegerParam("min.node.size", lower = 1, upper = 10),
    makeNumericParam("sample.fraction", lower = 0.2, upper = 0.9),
    makeIntegerParam("ppc.pcaComp", lower = 1, upper = 10)
)

# RIDGE ---------------------------------------------------------------------

# calculate lower and upper boundaries of param set for RR
lambda_ridge_min_nri = train(lrn_ridge, nri_task)
lambda_ridge_min_vi = train(lrn_ridge, vi_task)
lambda_ridge_min_hr = train(lrn_ridge, hr_task)
lambda_ridge_min = which.min(c(min(lambda_ridge_min_nri$learner.model$lambda), 
                               min(lambda_ridge_min_vi$learner.model$lambda), 
                               min(lambda_ridge_min_hr$learner.model$lambda)
))

lambda_ridge_max_nri = train(lrn_ridge, nri_task)
lambda_ridge_max_vi = train(lrn_ridge, vi_task)
lambda_ridge_max_hr = train(lrn_ridge, hr_task)
lambda_ridge_max = which.max(c(max(lambda_ridge_max_nri$learner.model$lambda), 
                               max(lambda_ridge_max_vi$learner.model$lambda), 
                               max(lambda_ridge_max_hr$learner.model$lambda)
))

ps_ridge_filter <- makeParamSet(makeNumericParam("s", lower = lambda_ridge_min,
                                                 upper = lambda_ridge_max),
                                makeNumericParam("fw.perc", lower = 0, upper = 1)
)

ps_ridge <- makeParamSet(makeNumericParam("s", lower = lambda_ridge_min,
                                          upper = lambda_ridge_max)
)

ps_ridge_pca = makeParamSet(
    makeNumericParam("s", lower = lambda_ridge_min, upper = lambda_ridge_max),
    makeIntegerParam("ppc.pcaComp", lower = 1, upper = 10)
)

# LASSO ---------------------------------------------------------------------

# calculate lower and upper boundaries of param set for RR
lambda_lasso_min_nri = train(lrn_lasso, nri_task)
lambda_lasso_min_vi = train(lrn_lasso, vi_task)
lambda_lasso_min_hr = train(lrn_lasso, hr_task)
lambda_lasso_min = which.min(c(min(lambda_lasso_min_nri$learner.model$lambda), 
                               min(lambda_lasso_min_vi$learner.model$lambda), 
                               min(lambda_lasso_min_hr$learner.model$lambda)
))

lambda_lasso_max_nri = train(lrn_lasso, nri_task)
lambda_lasso_max_vi = train(lrn_lasso, vi_task)
lambda_lasso_max_hr = train(lrn_lasso, hr_task)
lambda_lasso_max = which.max(c(max(lambda_lasso_max_nri$learner.model$lambda), 
                               max(lambda_lasso_max_vi$learner.model$lambda), 
                               max(lambda_lasso_max_hr$learner.model$lambda)
))


ps_lasso_filter <- makeParamSet(makeNumericParam("s", lower = lambda_lasso_min,
                                                 upper = lambda_lasso_max),
                                makeNumericParam("fw.perc", lower = 0, upper = 1)
)

ps_lasso <- makeParamSet(makeNumericParam("s", lower = lambda_lasso_min,
                                          upper = lambda_lasso_max)
)

ps_lasso_pca = makeParamSet(
    makeNumericParam("s", lower = lambda_lasso_min,upper = lambda_lasso_max),
    makeIntegerParam("ppc.pcaComp", lower = 1, upper = 10)
)

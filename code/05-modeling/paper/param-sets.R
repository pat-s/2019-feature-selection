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
  makeNumericParam("C", lower = -10, upper = 10,
                   trafo = function(x) 2 ^ x),
  makeNumericParam("sigma", lower = -5, upper = 5,
                   trafo = function(x) 2 ^ x),
  makeNumericParam("fw.perc", lower = 0, upper = 1)
)

ps_svm = makeParamSet(
  makeNumericParam("C", lower = -10, upper = 10,
                   trafo = function(x) 2 ^ x),
  makeNumericParam("sigma", lower = -5, upper = 5,
                   trafo = function(x) 2 ^ x)
)

ps_svm_pca =  makeParamSet(
  makeNumericParam("C", lower = -10, upper = 10,
                   trafo = function(x) 2 ^ x),
  makeNumericParam("sigma", lower = -5, upper = 5,
                   trafo = function(x) 2 ^ x),
  makeIntegerParam("ppc.pcaComp", lower = 1, upper = 10)
)

# Random Forest -----------------------------------------------------------

ps_rf_filter = makeParamSet(
  makeNumericParam("mtry.power", lower = 0, upper = 0.5),
  makeIntegerParam("min.node.size", lower = 1, upper = 10),
  makeNumericParam("sample.fraction", lower = 0.2, upper = 0.9),
  makeNumericParam("fw.perc", lower = 0, upper = 1)
)

ps_rf = makeParamSet(
  makeNumericParam("mtry.power", lower = 0, upper = 0.5),
  makeIntegerParam("min.node.size", lower = 1, upper = 10),
  makeNumericParam("sample.fraction", lower = 0.2, upper = 0.9)
)

ps_rf_pca = makeParamSet(
  makeNumericParam("mtry.power", lower = 0, upper = 0.5),
  makeIntegerParam("min.node.size", lower = 1, upper = 10),
  makeNumericParam("sample.fraction", lower = 0.2, upper = 0.9),
  makeIntegerParam("ppc.pcaComp", lower = 1, upper = 10)
)

# RIDGE ---------------------------------------------------------------------

# calculate lower and upper boundaries of param set for RR
lambda_ridge_nri_train = train(lrn_ridge, nri_task)
lambda_ridge_vi_train  = train(lrn_ridge, vi_task)
lambda_ridge_hr_train  = train(lrn_ridge, hr_task)
lambda_ridge_hr_nri_train  = train(lrn_ridge, hr_nri_task)
lambda_ridge_hr_vi_train  = train(lrn_ridge, hr_vi_task)
lambda_ridge_hr_nri_vi_train  = train(lrn_ridge, hr_nri_vi_task)

lambda_ridge_min_nri = min(lambda_ridge_nri_train$learner.model$lambda)
lambda_ridge_min_vi = min(lambda_ridge_vi_train$learner.model$lambda)
lambda_ridge_min_hr = min(lambda_ridge_hr_train$learner.model$lambda)
lambda_ridge_min_hr_nri = min(lambda_ridge_hr_nri_train$learner.model$lambda)
lambda_ridge_min_hr_nri_vi = min(lambda_ridge_hr_nri_vi_train$learner.model$lambda)
lambda_ridge_min_hr_vi = min(lambda_ridge_hr_vi_train$learner.model$lambda)

# lambda_ridge_min = which.min(c(min(lambda_ridge_min_nri$learner.model$lambda),
#                                min(lambda_ridge_min_vi$learner.model$lambda),
#                                min(lambda_ridge_min_hr$learner.model$lambda)
# ))

lambda_ridge_max_nri = max(lambda_ridge_nri_train$learner.model$lambda)
lambda_ridge_max_vi = max(lambda_ridge_vi_train$learner.model$lambda)
lambda_ridge_max_hr = max(lambda_ridge_hr_train$learner.model$lambda)
lambda_ridge_max_hr_nri = max(lambda_ridge_hr_nri_train$learner.model$lambda)
lambda_ridge_max_hr_nri_vi = max(lambda_ridge_hr_nri_vi_train$learner.model$lambda)
lambda_ridge_max_hr_vi = max(lambda_ridge_hr_vi_train$learner.model$lambda)


# lambda_ridge_max = which.max(c(max(lambda_ridge_max_nri$learner.model$lambda),
#                                max(lambda_ridge_max_vi$learner.model$lambda),
#                                max(lambda_ridge_max_hr$learner.model$lambda)
# ))


ps_ridge_hr <- makeParamSet(makeNumericParam("s", lower = lambda_ridge_min_hr,
                                          upper = lambda_ridge_max_hr)
)

ps_ridge_nri <- makeParamSet(makeNumericParam("s", lower = lambda_ridge_min_nri,
                                             upper = lambda_ridge_max_nri)
)

ps_ridge_vi <- makeParamSet(makeNumericParam("s", lower = lambda_ridge_min_vi,
                                             upper = lambda_ridge_max_vi)
)

ps_ridge_hr_nri <- makeParamSet(makeNumericParam("s", lower = lambda_ridge_min_hr_nri,
                                             upper = lambda_ridge_max_hr_nri)
)

ps_ridge_hr_vi <- makeParamSet(makeNumericParam("s", lower = lambda_ridge_min_hr_vi,
                                             upper = lambda_ridge_max_hr_vi)
)

ps_ridge_hr_nri_vi <- makeParamSet(makeNumericParam("s", lower = lambda_ridge_min_hr_nri_vi,
                                             upper = lambda_ridge_max_hr_nri_vi)
)

# LASSO ---------------------------------------------------------------------

# calculate lower and upper boundaries of param set for LASSO
lambda_lasso_nri_train = train(lrn_lasso, nri_task)
lambda_lasso_vi_train  = train(lrn_lasso, vi_task)
lambda_lasso_hr_train  = train(lrn_lasso, hr_task)
lambda_lasso_hr_nri_train  = train(lrn_lasso, hr_nri_task)
lambda_lasso_hr_vi_train  = train(lrn_lasso, hr_vi_task)
lambda_lasso_hr_nri_vi_train  = train(lrn_lasso, hr_nri_vi_task)

lambda_lasso_min_nri = min(lambda_lasso_nri_train$learner.model$lambda)
lambda_lasso_min_vi = min(lambda_lasso_vi_train$learner.model$lambda)
lambda_lasso_min_hr = min(lambda_lasso_hr_train$learner.model$lambda)
lambda_lasso_min_hr_nri = min(lambda_lasso_hr_nri_train$learner.model$lambda)
lambda_lasso_min_hr_nri_vi = min(lambda_lasso_hr_nri_vi_train$learner.model$lambda)
lambda_lasso_min_hr_vi = min(lambda_lasso_hr_vi_train$learner.model$lambda)

lambda_lasso_max_nri = max(lambda_lasso_nri_train$learner.model$lambda)
lambda_lasso_max_vi = max(lambda_lasso_vi_train$learner.model$lambda)
lambda_lasso_max_hr = max(lambda_lasso_hr_train$learner.model$lambda)
lambda_lasso_max_hr_nri = max(lambda_lasso_hr_nri_train$learner.model$lambda)
lambda_lasso_max_hr_nri_vi = max(lambda_lasso_hr_nri_vi_train$learner.model$lambda)
lambda_lasso_max_hr_vi = max(lambda_lasso_hr_vi_train$learner.model$lambda)


ps_lasso_hr <- makeParamSet(makeNumericParam("s", lower = lambda_lasso_min_hr,
                                             upper = lambda_lasso_max_hr)
)

ps_lasso_nri <- makeParamSet(makeNumericParam("s", lower = lambda_lasso_min_nri,
                                              upper = lambda_lasso_max_nri)
)

ps_lasso_vi <- makeParamSet(makeNumericParam("s", lower = lambda_lasso_min_vi,
                                             upper = lambda_lasso_max_vi)
)

ps_lasso_hr_nri <- makeParamSet(makeNumericParam("s", lower = lambda_lasso_min_hr_nri,
                                                 upper = lambda_lasso_max_hr_nri)
)

ps_lasso_hr_vi <- makeParamSet(makeNumericParam("s", lower = lambda_lasso_min_hr_vi,
                                                upper = lambda_lasso_max_hr_vi)
)

ps_lasso_hr_nri_vi <- makeParamSet(makeNumericParam("s", lower = lambda_lasso_min_hr_nri_vi,
                                                    upper = lambda_lasso_max_hr_nri_vi)
)

# LM -----------------------------------------------------------

ps_lm_filter = makeParamSet(
  makeNumericParam("fw.perc", lower = 0, upper = 1)
)

ps_lm_pca = makeParamSet(
  makeIntegerParam("ppc.pcaComp", lower = 1, upper = 10)
)

# XGBOOST -----------------------------------------------------------------

ps_xgboost = makeParamSet(
  makeIntegerParam("nrounds", lower = 10, upper = 600),
  makeNumericParam("colsample_bytree", lower = 0.3, upper = 0.7),
  makeNumericParam("subsample", lower = 0.25, upper = 1),
  makeIntegerParam("max_depth", lower = 1, upper = 10),
  makeNumericParam("gamma", lower = 0, upper = 10),
  makeNumericParam("eta", lower = 0.001, upper = 0.6),
  makeNumericParam("min_child_weight", lower = 0, upper = 20),
  makeNumericParam("fw.perc", lower = 0, upper = 1),
  makeIntegerVectorParam("fw.basal.methods", len = 8,
                         lower = 0, upper = 1,
                         trafo = function(x) c("carscore", "cforest.importance",
                                               "FSelectorRcpp_information.gain",
                                               "FSelectorRcpp_symmetrical.uncertainty",
                                               "linear.correlation",
                                               "mrmr",
                                               "ranger.impurity",
                                               "ranger.permutation",
                                               "rank.correlation",
                                               "univariate.model.score",
                                               "variance")[as.logical(x)])
)

# SVM ---------------------------------------------------------------------

ps_svm = makeParamSet(
  makeNumericParam("C", lower = -10, upper = 10,
                   trafo = function(x) 2 ^ x),
  makeNumericParam("sigma", lower = -5, upper = 5,
                   trafo = function(x) 2 ^ x),
  makeNumericParam("fw.perc", lower = 0, upper = 1),
  makeIntegerVectorParam("fw.basal.methods", len = 8,
                         lower = 0, upper = 1,
                         trafo = function(x) c("carscore", "cforest.importance",
                                               "FSelectorRcpp_information.gain",
                                               "FSelectorRcpp_symmetrical.uncertainty",
                                               "linear.correlation",
                                               "mrmr",
                                               "ranger.impurity",
                                               "ranger.permutation",
                                               "rank.correlation",
                                               "univariate.model.score",
                                               "variance")[as.logical(x)])
)

# Random Forest -----------------------------------------------------------

ps_rf = makeParamSet(
  makeIntegerParam("mtry", lower = 1, upper = 90),
  makeIntegerParam("min.node.size", lower = 1, upper = 10),
  makeNumericParam("sample.fraction", lower = 0.2, upper = 0.9),
  makeIntegerVectorParam("fw.basal.methods", len = 8,
                         lower = 0, upper = 1,
                         trafo = function(x) c("carscore", "cforest.importance",
                                               "FSelectorRcpp_information.gain",
                                               "FSelectorRcpp_symmetrical.uncertainty",
                                               "linear.correlation",
                                               "mrmr",
                                               "ranger.impurity",
                                               "ranger.permutation",
                                               "rank.correlation",
                                               "univariate.model.score",
                                               "variance")[as.logical(x)])
)

# RIDGE ---------------------------------------------------------------------

ps_ridge <- makeParamSet(makeNumericParam("s", lower = lambda_ridge_min,
                                          upper = lambda_ridge_max),
                         makeIntegerVectorParam("fw.basal.methods", len = 8,
                                                lower = 0, upper = 1,
                                                trafo = function(x) c("carscore", "cforest.importance",
                                                                      "FSelectorRcpp_information.gain",
                                                                      "FSelectorRcpp_symmetrical.uncertainty",
                                                                      "linear.correlation",
                                                                      "mrmr",
                                                                      "ranger.impurity",
                                                                      "ranger.permutation",
                                                                      "rank.correlation",
                                                                      "univariate.model.score",
                                                                      "variance")[as.logical(x)])
)

# LASSO ---------------------------------------------------------------------

ps_lasso <- makeParamSet(makeNumericParam("s", lower = lambda_lasso_min,
                                          upper = lambda_lasso_max),
                         makeIntegerVectorParam("fw.basal.methods", len = 8,
                                                lower = 0, upper = 1,
                                                trafo = function(x) c("carscore", "cforest.importance",
                                                                      "FSelectorRcpp_information.gain",
                                                                      "FSelectorRcpp_symmetrical.uncertainty",
                                                                      "linear.correlation",
                                                                      "mrmr",
                                                                      "ranger.impurity",
                                                                      "ranger.permutation",
                                                                      "rank.correlation",
                                                                      "univariate.model.score",
                                                                      "variance")[as.logical(x)])
)

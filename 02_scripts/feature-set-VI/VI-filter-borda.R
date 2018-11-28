remotes::install_github(c("pat-s/mlr@fs-pat-all", "pat-s/ParamHelpers@distinct"))
library(mlr)
library(mlrMBO)
library(magrittr)

# Task ----------------

task = readRDS("/data/patrick/mod/paper3/task/task-VI-[paper3].rda")

# Learners ---------------------

lrn_xgboost <- makeLearner("regr.xgboost",
                           par.vals = list(
                             objective = "reg:linear",
                             eval_metric = "error"
                           )) %>%
  makeFilterWrapper(fw.method = "E-Borda", cache = TRUE)

lrn_ksvm <- makeLearner("regr.ksvm",
                        kernel = "rbfdot") %>%
  makeFilterWrapper(fw.method = "E-Borda", cache = TRUE)

lrn_rf <- makeLearner(
  "regr.ranger") %>%
  makeFilterWrapper(fw.method = "E-Borda", cache = TRUE)

lrn_ridge <- makeLearner("regr.glmnet", id = "ridge",
                         alpha = 0,
                         standardize = FALSE,
                         intercept = FALSE) %>%
  makeFilterWrapper(fw.method = "E-Borda", cache = TRUE)

ridge_train = train(makeLearner("regr.glmnet",
                                alpha = 0, standardize = FALSE),
                    task)
lambda_ridge_min = min(ridge_train$learner.model$lambda)
lambda_ridge_max = max(ridge_train$learner.model$lambda)

lrn_lasso <- makeLearner("regr.glmnet", id = "lasso",
                         alpha = 1,
                         standardize = FALSE,
                         intercept = FALSE) %>%
  makeFilterWrapper(fw.method = "E-Borda", cache = TRUE)

lasso_train = train(makeLearner("regr.glmnet", id = "elnet",
                                alpha = 1, standardize = FALSE),
                    task)
lambda_lasso_min = min(lasso_train$learner.model$lambda)
lambda_lasso_max = max(lasso_train$learner.model$lambda)

lrn_elnet <- makeLearner("regr.glmnet",
                         standardize = FALSE,
                         intercept = FALSE) %>%
  makeFilterWrapper(fw.method = "E-Borda", cache = TRUE)

lambda_elnet_min = min(lasso_train$learner.model$lambda)
lambda_elnet_max = max(ridge_train$learner.model$lambda)

# Resampling ----------------

inner <- makeResampleDesc("CV", fixed = TRUE)
outer <- makeResampleDesc("CV", fixed = TRUE)

# Param sets ----------------

ps_xgboost = makeParamSet(
  makeIntegerParam("nrounds", lower = 10, upper = 600),
  makeNumericParam("colsample_bytree", lower = 0.3, upper = 0.7),
  makeNumericParam("subsample", lower = 0.25, upper = 1),
  makeIntegerParam("max_depth", lower = 1, upper = 10),
  makeNumericParam("gamma", lower = 0, upper = 10),
  makeNumericParam("eta", lower = 0.001, upper = 0.6),
  makeNumericParam("min_child_weight", lower = 0, upper = 20),
  makeIntegerVectorParam("fw.basal.methods", len = 8,
                         lower = 0, upper = 1,
                         trafo = function(x) c("carscore", "cforest.importance",
                                               "FSelectorRcpp_information.gain", "FSelectorRcpp_symmetrical.uncertainty", "linear.correlation",
                                               "mrmr",  "ranger.impurity",
                                               "ranger.permutation", "rank.correlation", "univariate.model.score",
                                               "variance")[as.logical(x)]),
  makeNumericParam("fw.perc", lower = 0, upper = 1)
)

ps_svm = makeParamSet(
  makeNumericParam("C", lower = -10, upper = 10,
                   trafo = function(x) 2 ^ x),
  makeNumericParam("sigma", lower = -5, upper = 5,
                   trafo = function(x) 2 ^ x),
  makeNumericParam("fw.perc", lower = 0, upper = 1),
  makeIntegerVectorParam("fw.basal.methods", len = 8,
                         lower = 0, upper = 1,
                         trafo = function(x) c("carscore", "cforest.importance",
                                               "FSelectorRcpp_information.gain", "FSelectorRcpp_symmetrical.uncertainty", "linear.correlation",
                                               "mrmr",  "ranger.impurity",
                                               "ranger.permutation", "rank.correlation", "univariate.model.score",
                                               "variance")[as.logical(x)])
)

ps_rf = makeParamSet(
  makeIntegerParam("mtry", lower = 1, upper = 90),
  makeIntegerParam("min.node.size", lower = 1, upper = 10),
  makeNumericParam("sample.fraction", lower = 0.2, upper = 0.9),
  makeIntegerVectorParam("fw.basal.methods", len = 8,
                         lower = 0, upper = 1,
                         trafo = function(x) c("carscore", "cforest.importance",
                                               "FSelectorRcpp_information.gain", "FSelectorRcpp_symmetrical.uncertainty", "linear.correlation",
                                               "mrmr",  "ranger.impurity",
                                               "ranger.permutation", "rank.correlation", "univariate.model.score",
                                               "variance")[as.logical(x)])
)

ps_ridge <- makeParamSet(makeNumericParam("s", lower = lambda_ridge_min,
                                          upper = lambda_ridge_max),
                         makeIntegerVectorParam("fw.basal.methods", len = 8,
                                                lower = 0, upper = 1,
                                                trafo = function(x) c("carscore", "cforest.importance",
                                                                      "FSelectorRcpp_information.gain", "FSelectorRcpp_symmetrical.uncertainty", "linear.correlation",
                                                                      "mrmr",  "ranger.impurity",
                                                                      "ranger.permutation", "rank.correlation", "univariate.model.score",
                                                                      "variance")[as.logical(x)])
)

# values = c("carscore", "cforest.importance", "FSelector_chi.squared", "FSelectorRcpp_gain.ratio",
#            "FSelectorRcpp_information.gain", "FSelectorRcpp_symmetrical.uncertainty", "linear.correlation",
#            "mrmr", "FSelector_oneR", "ranger.impurity",
#            "ranger.permutation", "rank.correlation", "FSelector_relief", "univariate.model.score",
#            "variance")

ps_lasso <- makeParamSet(makeNumericParam("s", lower = lambda_lasso_min,
                                          upper = lambda_lasso_max),
                         makeIntegerVectorParam("fw.basal.methods", len = 8,
                                                lower = 0, upper = 1,
                                                trafo = function(x) c("carscore", "cforest.importance",
                                                                      "FSelectorRcpp_information.gain", "FSelectorRcpp_symmetrical.uncertainty", "linear.correlation",
                                                                      "mrmr",  "ranger.impurity",
                                                                      "ranger.permutation", "rank.correlation", "univariate.model.score",
                                                                      "variance")[as.logical(x)])
)

ps_elnet <- makeParamSet(makeNumericParam("s", lower = lambda_elnet_min,
                                          upper = lambda_elnet_max),
                         makeNumericParam("alpha", lower = 0.1, upper = 0.9),
                         makeIntegerVectorParam("fw.basal.methods", len = 8,
                                                lower = 0, upper = 1,
                                                trafo = function(x) c("carscore", "cforest.importance",
                                                                      "FSelectorRcpp_information.gain", "FSelectorRcpp_symmetrical.uncertainty", "linear.correlation",
                                                                      "mrmr",  "ranger.impurity",
                                                                      "ranger.permutation", "rank.correlation", "univariate.model.score",
                                                                      "variance")[as.logical(x)])
)

# Tuning ctrl ---------------------------

# ctrl = makeMBOControl(propose.points = 1L)
# ctrl = setMBOControlTermination(ctrl, iters = 20L)
# ctrl = setMBOControlInfill(ctrl, crit = crit.ei)
#
# tune.ctrl_xgboost = makeTuneControlMBO(mbo.control = ctrl,
#                                        mbo.design = generateDesign(n = 30,
#                                                                    par.set = ps_xgboost))
# tune.ctrl_svm = makeTuneControlMBO(mbo.control = ctrl,
#                                    mbo.design = generateDesign(n = 30,
#                                                                par.set = ps_svm))
#
# tune.ctrl_rf = makeTuneControlMBO(mbo.control = ctrl,
#                                   mbo.design = generateDesign(n = 30,
#                                                               par.set = ps_rf))
#
# tune.ctrl_ridge = makeTuneControlMBO(mbo.control = ctrl,
#                                      mbo.design = generateDesign(n = 30,
#                                                                  par.set = ps_ridge))
#
# tune.ctrl_lasso = makeTuneControlMBO(mbo.control = ctrl,
#                                      mbo.design = generateDesign(n = 30,
#                                                                  par.set = ps_lasso))
#
# tune.ctrl_elnet = makeTuneControlMBO(mbo.control = ctrl,
#                                      mbo.design = generateDesign(n = 30,
#                                                                  par.set = ps_elnet))

tune.ctrl_xgboost = makeTuneControlRandom(maxit = 100L)
tune.ctrl_svm = makeTuneControlRandom(maxit = 100L)
tune.ctrl_rf = makeTuneControlRandom(maxit = 100L)
tune.ctrl_ridge = makeTuneControlRandom(maxit = 100L)
tune.ctrl_lasso = makeTuneControlRandom(maxit = 100L)
tune.ctrl_elnet = makeTuneControlRandom(maxit = 100L)

# Tune Wrappers  ---------------------------

tune_wrapper_svm = makeTuneWrapper(lrn_ksvm, resampling = inner,
                                   par.set = ps_svm,
                                   control = tune.ctrl_svm, show.info = TRUE,
                                   measures = list(rmse))

tune_wrapper_xgboost = makeTuneWrapper(lrn_xgboost, resampling = inner,
                                       par.set = ps_xgboost,
                                       control = tune.ctrl_xgboost,
                                       show.info = TRUE, measures = list(rmse))

tune_wrapper_rf = makeTuneWrapper(lrn_rf, resampling = inner,
                                  par.set = ps_rf,
                                  control = tune.ctrl_rf,
                                  show.info = TRUE, measures = list(rmse))

tune_wrapper_ridge = makeTuneWrapper(lrn_ridge, resampling = inner,
                                     par.set = ps_ridge,
                                     control = tune.ctrl_ridge,
                                     show.info = TRUE, measures = list(rmse))

tune_wrapper_lasso = makeTuneWrapper(lrn_lasso, resampling = inner,
                                     par.set = ps_lasso,
                                     control = tune.ctrl_lasso,
                                     show.info = TRUE, measures = list(rmse))

tune_wrapper_elnet = makeTuneWrapper(lrn_elnet, resampling = inner,
                                     par.set = ps_elnet,
                                     control = tune.ctrl_elnet,
                                     show.info = TRUE, measures = list(rmse))


learners = list(tune_wrapper_svm, tune_wrapper_xgboost, tune_wrapper_rf,
                tune_wrapper_ridge, tune_wrapper_lasso, tune_wrapper_elnet)

# Benchmark ---------------------------

library(parallelMap)
parallelStart(mode = "multicore", cpus = 30, level = "mlr.tuneParams",
              mc.set.seed = TRUE)
set.seed(12345, kind = "L'Ecuyer-CMRG")

bmr <- benchmark(learners, task,
                 resampling = outer,
                 show.info = TRUE, measures = list(rmse))

parallelStop()
saveRDS(bmr, "~/00-inbox/bmr-VI-E_Borda-[paper3].rda")

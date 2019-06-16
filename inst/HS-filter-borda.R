remotes::install_github("pat-s/mlr@fs-pat-all")
library(mlr)
library(mlrMBO)
library(magrittr)

# Task ----------------

# Read data

data = readRDS("/data/patrick/mod/hyperspectral/data_clean_with_indices/data_clean_standardized_bf2.rda")
coords = readRDS("/data/patrick/mod/hyperspectral/data_clean_with_indices/data_clean_standardized_bf2-coords.rda")

# Merge into one dataset

data = tibble::as_tibble(data.table::rbindlist(data, fill = TRUE))
data = Filter(function(x) !any(is.na(x)), data)
coords = tibble::as_tibble(data.table::rbindlist(coords))

task = makeRegrTask(id = "defoliation-all-plots", data = data,
                    target = "defoliation", coordinates = coords,
                    blocking = factor(rep(1:4, c(479, 451, 291, 529))))

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

# Resampling ----------------

inner <- makeResampleDesc("CV", fixed = TRUE)
outer <- makeResampleDesc("CV", fixed = TRUE)

# Param sets ----------------

ps_xgboost <- makeParamSet(
  makeIntegerParam("nrounds", lower = 10, upper = 600),
  makeNumericParam("colsample_bytree", lower = 0.3, upper = 0.7),
  makeNumericParam("subsample", lower = 0.25, upper = 1),
  makeIntegerParam("max_depth", lower = 1, upper = 10),
  makeNumericParam("gamma", lower = 0, upper = 10),
  makeNumericParam("eta", lower = 0.001, upper = 0.6),
  makeNumericParam("min_child_weight", lower = 0, upper = 20),
  makeDiscreteVectorParam("fw.basal.methods", len = 8,
                          values = c("carscore", "cforest.importance", "FSelector_chi.squared", "FSelectorRcpp_gain.ratio",
                                     "FSelectorRcpp_information.gain", "FSelectorRcpp_symmetrical.uncertainty", "linear.correlation",
                                     "mrmr", "FSelector_oneR", "ranger.impurity",
                                     "ranger.permutation", "rank.correlation", "FSelector_relief", "univariate.model.score",
                                     "variance")),
  makeNumericParam("fw.perc", lower = 0, upper = 1)
)

ps_svm <- makeParamSet(
  makeNumericParam("C", lower = -15, upper = 15,
                   trafo = function(x) 2 ^ x),
  makeNumericParam("sigma", lower = -15, upper = 15,
                   trafo = function(x) 2 ^ x),
  makeNumericParam("fw.perc", lower = 0, upper = 1),
  makeDiscreteVectorParam("fw.basal.methods", len = 8,
                          values = c("carscore", "cforest.importance", "FSelector_chi.squared", "FSelectorRcpp_gain.ratio",
                                     "FSelectorRcpp_information.gain", "FSelectorRcpp_symmetrical.uncertainty", "linear.correlation",
                                     "mrmr", "FSelector_oneR", "ranger.impurity",
                                     "ranger.permutation", "rank.correlation", "FSelector_relief", "univariate.model.score",
                                     "variance"))
)

# Tuning ctrl ---------------------------

ctrl = makeMBOControl(propose.points = 1L)
ctrl = setMBOControlTermination(ctrl, iters = 20L)
ctrl = setMBOControlInfill(ctrl, crit = crit.ei)

tune.ctrl_xgboost = makeTuneControlMBO(mbo.control = ctrl,
                                       mbo.design = generateDesign(n = 30,
                                                                   par.set = ps_xgboost_chi.squared))
tune.ctrl_svm = makeTuneControlMBO(mbo.control = ctrl,
                                   mbo.design = generateDesign(n = 30,
                                                               par.set = ps_svm_chi.squared))

# Tune Wrappers  ---------------------------

tune_wrapper_svm = makeTuneWrapper(lrn_ksvm, resampling = inner,
                                   par.set = ps_svm_chi.squared,
                                   control = tune.ctrl_svm, show.info = TRUE,
                                   measures = list(rmse))

tune_wrapper_xgboost = makeTuneWrapper(lrn_xgboost, resampling = inner,
                                       par.set = ps_xgboost_chi.squared,
                                       control = tune.ctrl_xgboost,
                                       show.info = TRUE, measures = list(rmse))


learners = list(tune_wrapper_svm, tune_wrapper_xgboost)

# Benchmark ---------------------------

library(parallelMap)
parallelStart(mode = "multicore", cpus = 30, level = "mlrMBO.feval",
              mc.set.seed = TRUE)
set.seed(12345, kind = "L'Ecuyer-CMRG")

bmr <- benchmark(learners, task,
                 resampling = outer,
                 show.info = TRUE, measures = list(rmse))

parallelStop()
saveRDS(bmr, "~/00-inbox/e-borda-[paper3].rda")

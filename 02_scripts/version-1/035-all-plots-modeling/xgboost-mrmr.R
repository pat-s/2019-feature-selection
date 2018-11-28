devtools::install_github("mlr-org/mlr@featsel_praznik")

library(mlr)
library(mlrMBO)
library(tibble)
library(purrr)
library(magrittr)
library(data.table)

# Read data

data = readRDS("/data/patrick/mod/hyperspectral/data_clean_with_indices/data_clean_standardized_bf2.rda")
coords = readRDS("/data/patrick/mod/hyperspectral/data_clean_with_indices/data_clean_standardized_bf2-coords.rda")

# Merge into one dataset

data = as_tibble(rbindlist(data, fill = TRUE))
data = Filter(function(x) !any(is.na(x)), data)
coords = as_tibble(rbindlist(coords))

# Task ----------------

task = makeRegrTask(id = "defoliation-all-plots", data = data,
                    target = "defoliation", coordinates = coords,
                    blocking = factor(rep(1:4, c(479, 451, 291, 529))))

# Resampling ----------------

inner <- makeResampleDesc("CV", fixed = TRUE)
outer <- makeResampleDesc("CV", fixed = TRUE)

# Learners ----------------

lrn_xgboost <- makeLearner("regr.xgboost",
                           par.vals = list(
                             objective = "reg:linear",
                             eval_metric = "error"
                           )) %>%
  makeFilterWrapper()


lrn_ksvm <- makeLearner("regr.ksvm",
                        kernel = "rbfdot") %>%
  makeFilterWrapper()

# Param sets ----------------

ps_xgboost_mrmr <- makeParamSet(
  makeIntegerParam("nrounds", lower = 10, upper = 600),
  makeNumericParam("colsample_bytree", lower = 0.3, upper = 0.7),
  makeNumericParam("subsample", lower = 0.25, upper = 1),
  makeIntegerParam("max_depth", lower = 1, upper = 10),
  makeNumericParam("gamma", lower = 0, upper = 10),
  makeNumericParam("eta", lower = 0.001, upper = 0.6),
  makeNumericParam("min_child_weight", lower = 0, upper = 20),
  makeDiscreteParam("fw.method", "mrmr"),
  makeNumericParam("fw.perc", lower = 0, upper = 1)
)


ps_svm_mrmr <- makeParamSet(
  makeNumericParam("C", lower = -15, upper = 15,
                   trafo = function(x) 2 ^ x),
  makeNumericParam("sigma", lower = -15, upper = 15,
                   trafo = function(x) 2 ^ x),
  makeDiscreteParam("fw.method", "FSelectorRcpp.infogain"),
  makeNumericParam("fw.perc", lower = 0, upper = 1)
)

# Tuning ctrl ---------------------------

ctrl = makeMBOControl(propose.points = 1L)
ctrl = setMBOControlTermination(ctrl, iters = 20L)
ctrl = setMBOControlInfill(ctrl, crit = crit.ei)
tune.ctrl_xgboost = makeTuneControlMBO(mbo.control = ctrl,
                                       mbo.design = generateDesign(n = 30,
                                                                   par.set = ps_xgboost_mrmr))
tune.ctrl_svm = makeTuneControlMBO(mbo.control = ctrl,
                                   mbo.design = generateDesign(n = 30,
                                                               par.set = ps_svm_mrmr))

# Wrappers  ---------------------------

tune_wrapper_svm_mrmr <- makeTuneWrapper(lrn_ksvm, resampling = inner, par.set = ps_svm_mrmr,
                                         control = tune.ctrl_svm, show.info = TRUE,
                                         measures = list(rmse))

tune_wrapper_xgboost_mrmr <- makeTuneWrapper(lrn_xgboost, resampling = inner,
                                             par.set = ps_xgboost_mrmr,
                                             control = tune.ctrl_xgboost, show.info = TRUE,
                                             measures = list(rmse))

learners = list(tune_wrapper_svm_mrmr, tune_wrapper_xgboost_mrmr)

# Benchmark ---------------------------

library(parallelMap)
parallelStart(mode = "multicore", cpus = 10, level = "mlrMBO.feval",
              mc.set.seed = TRUE)
set.seed(12345, kind = "L'Ecuyer-CMRG")
resa_out <- benchmark(learners, task,
                      resampling = outer,
                      show.info = TRUE, measures = list(rmse))

parallelStop()
saveRDS(resa_out, "/data/patrick/mod/hyperspectral/spcv/all-plots-xgboost-svm-infogain.rda")

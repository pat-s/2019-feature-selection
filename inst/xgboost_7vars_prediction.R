library(mlr)
library(mlrMBO)
library(iml)
library(glue)
library(sf)
library(dplyr)
library(tibble)
library(purrr)
library(magrittr)
library(data.table)
library(pbmcapply)
library(ggpubr)

data = readRDS("/data/patrick/mod/hyperspectral/data_clean_with_indices/data_clean_not-standardized_bf2.rda")
coords = readRDS("/data/patrick/mod/hyperspectral/data_clean_with_indices/data_clean_standardized_bf2-coords.rda")



data = as_tibble(rbindlist(data, fill = TRUE))
data = Filter(function(x) !any(is.na(x)), data)
coords = as_tibble(rbindlist(coords))


indices_shared = names(data)
saveRDS(indices_shared, "/data/patrick/mod/hyperspectral/data_clean_with_indices/indices-shared-by-all-plots-bf2.rda")


task = makeRegrTask(id = "all_plots", data = data,
                    target = "defoliation", coordinates = coords,
                    blocking = factor(rep(1:4, c(479, 451, 291, 529))))

data_7 = data %>%
  dplyr::select(defoliation, bf2_EVI, bf2_GDVI_4, bf2_GDVI_3, bf2_GDVI_2, bf2_D1, bf2_mNDVI, bf2_mSR) %>%
  as_tibble()


# summary(data_7)


# Histograms of all variables to remove outlier

# DataExplorer::plot_histogram(data_7)


# Limit EVI
# low: 0
# max: 100

data_7 %<>%
  mutate(bf2_EVI = case_when(bf2_EVI < 0 ~ 0, bf2_EVI > 1.5 ~ 1.5, TRUE ~ as.numeric(bf2_EVI))) %>%
  mutate(bf2_mSR = case_when(bf2_mSR < -3 ~ -3, bf2_mSR > 4 ~ 4, TRUE ~ as.numeric(bf2_mSR))) %>%
  mutate(bf2_D1 = case_when(bf2_D1 > 2.5 ~ 2.5, TRUE ~ as.numeric(bf2_D1))) %>%
  mutate(bf2_GDVI_4 = case_when(bf2_GDVI_4 < -4 ~ -4, TRUE ~ as.numeric(bf2_GDVI_4))) %>%
  mutate(bf2_GDVI_3 = case_when(bf2_GDVI_3 < -4 ~ -4, TRUE ~ as.numeric(bf2_GDVI_3))) %>%
  mutate(bf2_GDVI_2 = case_when(bf2_GDVI_2 < -4 ~ -4, TRUE ~ as.numeric(bf2_GDVI_2))) %>%
  mutate(bf2_mNDVI = case_when(bf2_mNDVI < -3 ~ -3, TRUE ~ as.numeric(bf2_mNDVI)))


task_7 = makeRegrTask(id = "all_plots", data = data_7,
                      target = "defoliation", coordinates = coords,
                      blocking = factor(rep(1:4, c(479, 451, 291, 529))))


#### Tuning

lrn_xgboost <- makeLearner("regr.xgboost",
                           par.vals = list(
                             objective = "reg:squarederror",
                             eval_metric = "error"
                           ))

ps_xgboost <- makeParamSet(
  makeIntegerParam("nrounds", lower = 10, upper = 600),
  makeNumericParam("colsample_bytree", lower = 0.3, upper = 0.7),
  makeNumericParam("subsample", lower = 0.25, upper = 1),
  makeIntegerParam("max_depth", lower = 1, upper = 10),
  makeNumericParam("gamma", lower = 0, upper = 10),
  makeNumericParam("eta", lower = 0.001, upper = 0.6),
  makeNumericParam("min_child_weight", lower = 0, upper = 20)
)

ctrl = makeMBOControl(propose.points = 1L)
ctrl = setMBOControlTermination(ctrl, iters = 20L)
ctrl = setMBOControlInfill(ctrl, crit = crit.ei)
tune.ctrl = makeTuneControlMBO(mbo.control = ctrl,
                               mbo.design = generateDesign(n = 30,
                                                           par.set = ps_xgboost))

inner <- makeResampleDesc("CV", fixed = TRUE)
outer <- makeResampleDesc("CV", fixed = TRUE)


configureMlr(on.learner.error = "warn", on.error.dump = TRUE)
library(parallelMap)
parallelStart(mode = "multicore", level = "mlrMBO.feval", cpus = 48,
              mc.set.seed = TRUE)
set.seed(12345)
xgboost_tuned = tuneParams(lrn_xgboost, task = task_7, resampling = inner,
                           par.set = ps_xgboost, control = tune.ctrl,
                           show.info = TRUE, measure = list(rmse))
parallelStop()
saveRDS(xgboost_tuned, "/data/patrick/mod/tmp/tuning_hyperspectral/xgboost_tuned_blocking_7vars.rda")

test = readRDS("/data/patrick/mod/tmp/tuning_hyperspectral/xgboost_tuned_blocking_7vars.rda")


#### Train


xgboost_tuned = readRDS("/data/patrick/mod/tmp/tuning_hyperspectral/xgboost_tuned_blocking.rda")
lrn_xgboost = setHyperPars(makeLearner("regr.xgboost"),
                           par.vals = xgboost_tuned$x)
m = train(lrn_xgboost, task_7)
saveRDS(m, "/data/patrick/mod/hyperspectral/prediction/xgboost_trained_tuned_7vars.rda")

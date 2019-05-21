# SVM ---------------------------------------------------------------------

svm = makeTuneWrapper(filter_wrapper_svm, resampling = inner,
                                   par.set = ps_svm,
                                   control = tune.ctrl_svm, show.info = TRUE,
                                   measures = list(rmse))

# XGBOOST -----------------------------------------------------------------

xgboost = makeTuneWrapper(filter_wrapper_xgboost, resampling = inner,
                                       par.set = ps_xgboost,
                                       control = tune.ctrl_xgboost,
                                       show.info = TRUE, measures = list(rmse))

# Random Forest -----------------------------------------------------------

rf = makeTuneWrapper(filter_wrapper_rf, resampling = inner,
                                  par.set = ps_rf,
                                  control = tune.ctrl_rf,
                                  show.info = TRUE, measures = list(rmse))

# RIDGE ---------------------------------------------------------------------

ridge = makeTuneWrapper(filter_wrapper_ridge, resampling = inner,
                                     par.set = ps_ridge,
                                     control = tune.ctrl_ridge,
                                     show.info = TRUE, measures = list(rmse))

# LASSO ---------------------------------------------------------------------

lasso = makeTuneWrapper(filter_wrapper_lasso, resampling = inner,
                                     par.set = ps_lasso,
                                     control = tune.ctrl_lasso,
                                     show.info = TRUE, measures = list(rmse))

# SVM ---------------------------------------------------------------------

svm_borda = makeTuneWrapper(filter_wrapper_svm_borda, resampling = inner,
                            par.set = ps_svm_filter,
                            control = tune.ctrl_svm, show.info = TRUE,
                            measures = list(rmse))

svm_info.gain = makeTuneWrapper(filter_wrapper_svm_info.gain, resampling = inner,
                                par.set = ps_svm_filter,
                                control = tune.ctrl_svm, show.info = TRUE,
                                measures = list(rmse))

svm_gain.ratio = makeTuneWrapper(filter_wrapper_svm_gain.ratio, resampling = inner,
                                 par.set = ps_svm_filter,
                                 control = tune.ctrl_svm, show.info = TRUE,
                                 measures = list(rmse))

svm_variance = makeTuneWrapper(filter_wrapper_svm_variance, resampling = inner,
                               par.set = ps_svm_filter,
                               control = tune.ctrl_svm, show.info = TRUE,
                               measures = list(rmse))

svm_rank.cor = makeTuneWrapper(filter_wrapper_svm_rank.cor, resampling = inner,
                               par.set = ps_svm_filter,
                               control = tune.ctrl_svm, show.info = TRUE,
                               measures = list(rmse))

svm_linear.cor = makeTuneWrapper(filter_wrapper_svm_linear.cor, resampling = inner,
                                 par.set = ps_svm_filter,
                                 control = tune.ctrl_svm, show.info = TRUE,
                                 measures = list(rmse))

svm_mrmr = makeTuneWrapper(filter_wrapper_svm_mrmr, resampling = inner,
                           par.set = ps_svm_filter,
                           control = tune.ctrl_svm, show.info = TRUE,
                           measures = list(rmse))

svm_cmim = makeTuneWrapper(filter_wrapper_svm_cmim, resampling = inner,
                           par.set = ps_svm_filter,
                           control = tune.ctrl_svm, show.info = TRUE,
                           measures = list(rmse))

svm_carscore = makeTuneWrapper(filter_wrapper_svm_carscore, resampling = inner,
                               par.set = ps_svm_filter,
                               control = tune.ctrl_svm, show.info = TRUE,
                               measures = list(rmse))

svm_no_filter = makeTuneWrapper(lrn_svm, resampling = inner,
                                par.set = ps_svm,
                                control = tune.ctrl_svm, show.info = TRUE,
                                measures = list(rmse))

svm_pca = makeTuneWrapper(pca_wrapper_svm, resampling = inner,
                          par.set = ps_svm_pca,
                          control = tune.ctrl_svm, show.info = TRUE,
                          measures = list(rmse))

# XGBOOST -----------------------------------------------------------------

xgboost_borda = makeTuneWrapper(filter_wrapper_xgboost_borda, resampling = inner,
                                par.set = ps_xgboost_filter,
                                control = tune.ctrl_xgboost,
                                show.info = TRUE, measures = list(rmse))

xgboost_info.gain = makeTuneWrapper(filter_wrapper_xgboost_info.gain, resampling = inner,
                                    par.set = ps_xgboost_filter,
                                    control = tune.ctrl_xgboost, show.info = TRUE,
                                    measures = list(rmse))

xgboost_gain.ratio = makeTuneWrapper(filter_wrapper_xgboost_gain.ratio, resampling = inner,
                                     par.set = ps_xgboost_filter,
                                     control = tune.ctrl_xgboost, show.info = TRUE,
                                     measures = list(rmse))

xgboost_variance = makeTuneWrapper(filter_wrapper_xgboost_variance, resampling = inner,
                                   par.set = ps_xgboost_filter,
                                   control = tune.ctrl_xgboost, show.info = TRUE,
                                   measures = list(rmse))

xgboost_rank.cor = makeTuneWrapper(filter_wrapper_xgboost_rank.cor, resampling = inner,
                                   par.set = ps_xgboost_filter,
                                   control = tune.ctrl_xgboost, show.info = TRUE,
                                   measures = list(rmse))

xgboost_linear.cor = makeTuneWrapper(filter_wrapper_xgboost_linear.cor, resampling = inner,
                                     par.set = ps_xgboost_filter,
                                     control = tune.ctrl_xgboost, show.info = TRUE,
                                     measures = list(rmse))

xgboost_mrmr = makeTuneWrapper(filter_wrapper_xgboost_mrmr, resampling = inner,
                               par.set = ps_xgboost_filter,
                               control = tune.ctrl_xgboost, show.info = TRUE,
                               measures = list(rmse))

xgboost_cmim = makeTuneWrapper(filter_wrapper_xgboost_cmim, resampling = inner,
                               par.set = ps_xgboost_filter,
                               control = tune.ctrl_xgboost, show.info = TRUE,
                               measures = list(rmse))

xgboost_carscore = makeTuneWrapper(filter_wrapper_xgboost_carscore, resampling = inner,
                                   par.set = ps_xgboost_filter,
                                   control = tune.ctrl_xgboost, show.info = TRUE,
                                   measures = list(rmse))

xgboost_no_filter = makeTuneWrapper(lrn_xgboost, resampling = inner,
                                    par.set = ps_xgboost,
                                    control = tune.ctrl_xgboost, show.info = TRUE,
                                    measures = list(rmse))

xgboost_pca = makeTuneWrapper(pca_wrapper_xgboost, resampling = inner,
                              par.set = ps_xgboost_pca,
                              control = tune.ctrl_xgboost, show.info = TRUE,
                              measures = list(rmse))

# Random Forest -----------------------------------------------------------

rf_borda = makeTuneWrapper(filter_wrapper_rf_borda, resampling = inner,
                           par.set = ps_rf_filter,
                           control = tune.ctrl_rf, show.info = TRUE,
                           measures = list(rmse))

rf_info.gain = makeTuneWrapper(filter_wrapper_rf_info.gain, resampling = inner,
                               par.set = ps_rf_filter,
                               control = tune.ctrl_rf, show.info = TRUE,
                               measures = list(rmse))

rf_gain.ratio = makeTuneWrapper(filter_wrapper_rf_gain.ratio, resampling = inner,
                                par.set = ps_rf_filter,
                                control = tune.ctrl_rf, show.info = TRUE,
                                measures = list(rmse))

rf_variance = makeTuneWrapper(filter_wrapper_rf_variance, resampling = inner,
                              par.set = ps_rf_filter,
                              control = tune.ctrl_rf, show.info = TRUE,
                              measures = list(rmse))

rf_rank.cor = makeTuneWrapper(filter_wrapper_rf_rank.cor, resampling = inner,
                              par.set = ps_rf_filter,
                              control = tune.ctrl_rf, show.info = TRUE,
                              measures = list(rmse))

rf_linear.cor = makeTuneWrapper(filter_wrapper_rf_linear.cor, resampling = inner,
                                par.set = ps_rf_filter,
                                control = tune.ctrl_rf, show.info = TRUE,
                                measures = list(rmse))

rf_mrmr = makeTuneWrapper(filter_wrapper_rf_mrmr, resampling = inner,
                          par.set = ps_rf_filter,
                          control = tune.ctrl_rf, show.info = TRUE,
                          measures = list(rmse))

rf_cmim = makeTuneWrapper(filter_wrapper_rf_cmim, resampling = inner,
                          par.set = ps_rf_filter,
                          control = tune.ctrl_rf, show.info = TRUE,
                          measures = list(rmse))

rf_carscore = makeTuneWrapper(filter_wrapper_rf_carscore, resampling = inner,
                              par.set = ps_rf_filter,
                              control = tune.ctrl_rf, show.info = TRUE,
                              measures = list(rmse))

rf_no_filter = makeTuneWrapper(lrn_rf, resampling = inner,
                               par.set = ps_rf,
                               control = tune.ctrl_rf, show.info = TRUE,
                               measures = list(rmse))

rf_pca = makeTuneWrapper(pca_wrapper_rf, resampling = inner,
                         par.set = ps_rf_pca,
                         control = tune.ctrl_rf, show.info = TRUE,
                         measures = list(rmse))

# RIDGE ---------------------------------------------------------------------

ridge_borda = makeTuneWrapper(filter_wrapper_ridge_borda, resampling = inner,
                              par.set = ps_ridge_filter,
                              control = tune.ctrl_ridge,
                              show.info = TRUE, measures = list(rmse))

ridge_info.gain = makeTuneWrapper(filter_wrapper_ridge_info.gain, resampling = inner,
                                  par.set = ps_ridge_filter,
                                  control = tune.ctrl_ridge, show.info = TRUE,
                                  measures = list(rmse))

ridge_gain.ratio = makeTuneWrapper(filter_wrapper_ridge_gain.ratio, resampling = inner,
                                   par.set = ps_ridge_filter,
                                   control = tune.ctrl_ridge, show.info = TRUE,
                                   measures = list(rmse))

ridge_variance = makeTuneWrapper(filter_wrapper_ridge_variance, resampling = inner,
                                 par.set = ps_ridge_filter,
                                 control = tune.ctrl_ridge, show.info = TRUE,
                                 measures = list(rmse))

ridge_rank.cor = makeTuneWrapper(filter_wrapper_ridge_rank.cor, resampling = inner,
                                 par.set = ps_ridge_filter,
                                 control = tune.ctrl_ridge, show.info = TRUE,
                                 measures = list(rmse))

ridge_linear.cor = makeTuneWrapper(filter_wrapper_ridge_linear.cor, resampling = inner,
                                   par.set = ps_ridge_filter,
                                   control = tune.ctrl_ridge, show.info = TRUE,
                                   measures = list(rmse))

ridge_mrmr = makeTuneWrapper(filter_wrapper_ridge_mrmr, resampling = inner,
                             par.set = ps_ridge_filter,
                             control = tune.ctrl_ridge, show.info = TRUE,
                             measures = list(rmse))

ridge_cmim = makeTuneWrapper(filter_wrapper_ridge_cmim, resampling = inner,
                             par.set = ps_ridge_filter,
                             control = tune.ctrl_ridge, show.info = TRUE,
                             measures = list(rmse))

ridge_carscore = makeTuneWrapper(filter_wrapper_ridge_carscore, resampling = inner,
                                 par.set = ps_ridge_filter,
                                 control = tune.ctrl_ridge, show.info = TRUE,
                                 measures = list(rmse))

ridge_no_filter = makeTuneWrapper(lrn_ridge, resampling = inner,
                                  par.set = ps_ridge,
                                  control = tune.ctrl_ridge, show.info = TRUE,
                                  measures = list(rmse))

ridge_pca = makeTuneWrapper(pca_wrapper_ridge, resampling = inner,
                            par.set = ps_ridge_pca,
                            control = tune.ctrl_ridge, show.info = TRUE,
                            measures = list(rmse))

# LASSO ---------------------------------------------------------------------

lasso_borda = makeTuneWrapper(filter_wrapper_lasso_borda, resampling = inner,
                              par.set = ps_lasso_filter,
                              control = tune.ctrl_lasso,
                              show.info = TRUE, measures = list(rmse))

lasso_info.gain = makeTuneWrapper(filter_wrapper_lasso_info.gain, resampling = inner,
                                  par.set = ps_lasso_filter,
                                  control = tune.ctrl_lasso, show.info = TRUE,
                                  measures = list(rmse))

lasso_gain.ratio = makeTuneWrapper(filter_wrapper_lasso_gain.ratio, resampling = inner,
                                   par.set = ps_lasso_filter,
                                   control = tune.ctrl_lasso, show.info = TRUE,
                                   measures = list(rmse))

lasso_variance = makeTuneWrapper(filter_wrapper_lasso_variance, resampling = inner,
                                 par.set = ps_lasso_filter,
                                 control = tune.ctrl_lasso, show.info = TRUE,
                                 measures = list(rmse))

lasso_rank.cor = makeTuneWrapper(filter_wrapper_lasso_rank.cor, resampling = inner,
                                 par.set = ps_lasso_filter,
                                 control = tune.ctrl_lasso, show.info = TRUE,
                                 measures = list(rmse))

lasso_linear.cor = makeTuneWrapper(filter_wrapper_lasso_linear.cor, resampling = inner,
                                   par.set = ps_lasso_filter,
                                   control = tune.ctrl_lasso, show.info = TRUE,
                                   measures = list(rmse))

lasso_mrmr = makeTuneWrapper(filter_wrapper_lasso_mrmr, resampling = inner,
                             par.set = ps_lasso_filter,
                             control = tune.ctrl_lasso, show.info = TRUE,
                             measures = list(rmse))

lasso_cmim = makeTuneWrapper(filter_wrapper_lasso_cmim, resampling = inner,
                             par.set = ps_lasso_filter,
                             control = tune.ctrl_lasso, show.info = TRUE,
                             measures = list(rmse))

lasso_carscore = makeTuneWrapper(filter_wrapper_lasso_carscore, resampling = inner,
                                 par.set = ps_lasso_filter,
                                 control = tune.ctrl_lasso, show.info = TRUE,
                                 measures = list(rmse))

lasso_no_filter = makeTuneWrapper(lrn_lasso, resampling = inner,
                                  par.set = ps_lasso,
                                  control = tune.ctrl_lasso, show.info = TRUE,
                                  measures = list(rmse))

lasso_pca = makeTuneWrapper(pca_wrapper_lasso, resampling = inner,
                            par.set = ps_lasso_pca,
                            control = tune.ctrl_lasso, show.info = TRUE,
                            measures = list(rmse))

# lm ---------------------------------------------------------------------

lm_borda = makeTuneWrapper(filter_wrapper_lm_borda, resampling = inner,
                           par.set = ps_lm_filter,
                           control = tune.ctrl_lm,
                           show.info = TRUE, measures = list(rmse))

lm_info.gain = makeTuneWrapper(filter_wrapper_lm_info.gain, resampling = inner,
                               par.set = ps_lm_filter,
                               control = tune.ctrl_lm, show.info = TRUE,
                               measures = list(rmse))

lm_gain.ratio = makeTuneWrapper(filter_wrapper_lm_gain.ratio, resampling = inner,
                                par.set = ps_lm_filter,
                                control = tune.ctrl_lm, show.info = TRUE,
                                measures = list(rmse))

lm_variance = makeTuneWrapper(filter_wrapper_lm_variance, resampling = inner,
                              par.set = ps_lm_filter,
                              control = tune.ctrl_lm, show.info = TRUE,
                              measures = list(rmse))

lm_rank.cor = makeTuneWrapper(filter_wrapper_lm_rank.cor, resampling = inner,
                              par.set = ps_lm_filter,
                              control = tune.ctrl_lm, show.info = TRUE,
                              measures = list(rmse))

lm_linear.cor = makeTuneWrapper(filter_wrapper_lm_linear.cor, resampling = inner,
                                par.set = ps_lm_filter,
                                control = tune.ctrl_lm, show.info = TRUE,
                                measures = list(rmse))

lm_mrmr = makeTuneWrapper(filter_wrapper_lm_mrmr, resampling = inner,
                          par.set = ps_lm_filter,
                          control = tune.ctrl_lm, show.info = TRUE,
                          measures = list(rmse))

lm_cmim = makeTuneWrapper(filter_wrapper_lm_cmim, resampling = inner,
                          par.set = ps_lm_filter,
                          control = tune.ctrl_lm, show.info = TRUE,
                          measures = list(rmse))

lm_carscore = makeTuneWrapper(filter_wrapper_lm_carscore, resampling = inner,
                              par.set = ps_lm_filter,
                              control = tune.ctrl_lm, show.info = TRUE,
                              measures = list(rmse))

lm_pca = makeTuneWrapper(pca_wrapper_lm, resampling = inner,
                         par.set = ps_lm_pca,
                         control = tune.ctrl_lm, show.info = TRUE,
                         measures = list(rmse))

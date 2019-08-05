# SVM ---------------------------------------------------------------------

svm_borda = makeTuneWrapper(filter_wrapper_svm_borda, resampling = inner,
                            par.set = ps_svm_filter,
                            control = tune.ctrl_svm, show.info = TRUE,
                            measures = list(rmse)) %>%
  magrittr::inset("id", "SVM Borda")

svm_info.gain = makeTuneWrapper(filter_wrapper_svm_info.gain, resampling = inner,
                                par.set = ps_svm_filter,
                                control = tune.ctrl_svm, show.info = TRUE,
                                measures = list(rmse)) %>%
  magrittr::inset("id", "SVM Info Gain")

svm_gain.ratio = makeTuneWrapper(filter_wrapper_svm_gain.ratio, resampling = inner,
                                 par.set = ps_svm_filter,
                                 control = tune.ctrl_svm, show.info = TRUE,
                                 measures = list(rmse)) %>%
  magrittr::inset("id", "SVM Gain Ratio")

svm_relief = makeTuneWrapper(filter_wrapper_svm_relief, resampling = inner,
                             par.set = ps_svm_filter,
                             control = tune.ctrl_svm, show.info = TRUE,
                             measures = list(rmse)) %>%
  magrittr::inset("id", "SVM Relief")

svm_variance = makeTuneWrapper(filter_wrapper_svm_variance, resampling = inner,
                               par.set = ps_svm_filter,
                               control = tune.ctrl_svm, show.info = TRUE,
                               measures = list(rmse)) %>%
  magrittr::inset("id", "SVM Variance")

svm_rank.cor = makeTuneWrapper(filter_wrapper_svm_rank.cor, resampling = inner,
                               par.set = ps_svm_filter,
                               control = tune.ctrl_svm, show.info = TRUE,
                               measures = list(rmse)) %>%
  magrittr::inset("id", "SVM Spearman")

svm_linear.cor = makeTuneWrapper(filter_wrapper_svm_linear.cor, resampling = inner,
                                 par.set = ps_svm_filter,
                                 control = tune.ctrl_svm, show.info = TRUE,
                                 measures = list(rmse)) %>%
  magrittr::inset("id", "SVM Pearson")

svm_mrmr = makeTuneWrapper(filter_wrapper_svm_mrmr, resampling = inner,
                           par.set = ps_svm_filter,
                           control = tune.ctrl_svm, show.info = TRUE,
                           measures = list(rmse)) %>%
  magrittr::inset("id", "SVM MRMR")

svm_cmim = makeTuneWrapper(filter_wrapper_svm_cmim, resampling = inner,
                           par.set = ps_svm_filter,
                           control = tune.ctrl_svm, show.info = TRUE,
                           measures = list(rmse)) %>%
  magrittr::inset("id", "SVM CMIM")

svm_carscore = makeTuneWrapper(filter_wrapper_svm_carscore, resampling = inner,
                               par.set = ps_svm_filter,
                               control = tune.ctrl_svm, show.info = TRUE,
                               measures = list(rmse)) %>%
  magrittr::inset("id", "SVM Car")

svm_no_filter = makeTuneWrapper(lrn_svm, resampling = inner,
                                par.set = ps_svm,
                                control = tune.ctrl_svm, show.info = TRUE,
                                measures = list(rmse)) %>%
  magrittr::inset("id", "SVM")

svm_pca = makeTuneWrapper(pca_wrapper_svm, resampling = inner,
                          par.set = ps_svm_pca,
                          control = tune.ctrl_svm, show.info = TRUE,
                          measures = list(rmse)) %>%
  magrittr::inset("id", "SVM PCA")

# XGBOOST -----------------------------------------------------------------

xgboost_borda = makeTuneWrapper(filter_wrapper_xgboost_borda, resampling = inner,
                                par.set = ps_xgboost_filter,
                                control = tune.ctrl_xgboost,
                                show.info = TRUE, measures = list(rmse)) %>%
  magrittr::inset("id", "XG Borda")

xgboost_info.gain = makeTuneWrapper(filter_wrapper_xgboost_info.gain, resampling = inner,
                                    par.set = ps_xgboost_filter,
                                    control = tune.ctrl_xgboost, show.info = TRUE,
                                    measures = list(rmse)) %>%
  magrittr::inset("id", "XG Info Gain")

xgboost_gain.ratio = makeTuneWrapper(filter_wrapper_xgboost_gain.ratio, resampling = inner,
                                     par.set = ps_xgboost_filter,
                                     control = tune.ctrl_xgboost, show.info = TRUE,
                                     measures = list(rmse))%>%
  magrittr::inset("id", "XG Gain Ratio")

xgboost_relief = makeTuneWrapper(filter_wrapper_xgboost_relief, resampling = inner,
                                 par.set = ps_xgboost_filter,
                                 control = tune.ctrl_xgboost, show.info = TRUE,
                                 measures = list(rmse)) %>%
  magrittr::inset("id", "XG Relief")

xgboost_variance = makeTuneWrapper(filter_wrapper_xgboost_variance, resampling = inner,
                                   par.set = ps_xgboost_filter,
                                   control = tune.ctrl_xgboost, show.info = TRUE,
                                   measures = list(rmse)) %>%
  magrittr::inset("id", "XG Variance")

xgboost_rank.cor = makeTuneWrapper(filter_wrapper_xgboost_rank.cor, resampling = inner,
                                   par.set = ps_xgboost_filter,
                                   control = tune.ctrl_xgboost, show.info = TRUE,
                                   measures = list(rmse)) %>%
  magrittr::inset("id", "XG Spearman")

xgboost_linear.cor = makeTuneWrapper(filter_wrapper_xgboost_linear.cor, resampling = inner,
                                     par.set = ps_xgboost_filter,
                                     control = tune.ctrl_xgboost, show.info = TRUE,
                                     measures = list(rmse)) %>%
  magrittr::inset("id", "XG Pearson")

xgboost_mrmr = makeTuneWrapper(filter_wrapper_xgboost_mrmr, resampling = inner,
                               par.set = ps_xgboost_filter,
                               control = tune.ctrl_xgboost, show.info = TRUE,
                               measures = list(rmse)) %>%
  magrittr::inset("id", "XG MRMR")

xgboost_cmim = makeTuneWrapper(filter_wrapper_xgboost_cmim, resampling = inner,
                               par.set = ps_xgboost_filter,
                               control = tune.ctrl_xgboost, show.info = TRUE,
                               measures = list(rmse)) %>%
  magrittr::inset("id", "XG CMIM")

xgboost_carscore = makeTuneWrapper(filter_wrapper_xgboost_carscore, resampling = inner,
                                   par.set = ps_xgboost_filter,
                                   control = tune.ctrl_xgboost, show.info = TRUE,
                                   measures = list(rmse)) %>%
  magrittr::inset("id", "XG Car")

xgboost_no_filter = makeTuneWrapper(lrn_xgboost, resampling = inner,
                                    par.set = ps_xgboost,
                                    control = tune.ctrl_xgboost, show.info = TRUE,
                                    measures = list(rmse)) %>%
  magrittr::inset("id", "XG")

xgboost_pca = makeTuneWrapper(pca_wrapper_xgboost, resampling = inner,
                              par.set = ps_xgboost_pca,
                              control = tune.ctrl_xgboost, show.info = TRUE,
                              measures = list(rmse)) %>%
  magrittr::inset("id", "XG PCA")

# Random Forest -----------------------------------------------------------

rf_borda = makeTuneWrapper(filter_wrapper_rf_borda, resampling = inner,
                           par.set = ps_rf_filter,
                           control = tune.ctrl_rf, show.info = TRUE,
                           measures = list(rmse)) %>%
  magrittr::inset("id", "RF Borda")

rf_info.gain = makeTuneWrapper(filter_wrapper_rf_info.gain, resampling = inner,
                               par.set = ps_rf_filter,
                               control = tune.ctrl_rf, show.info = TRUE,
                               measures = list(rmse))  %>%
  magrittr::inset("id", "RF Info Gain")

rf_gain.ratio = makeTuneWrapper(filter_wrapper_rf_gain.ratio, resampling = inner,
                                par.set = ps_rf_filter,
                                control = tune.ctrl_rf, show.info = TRUE,
                                measures = list(rmse))  %>%
  magrittr::inset("id", "RF Gain Ratio")

rf_relief = makeTuneWrapper(filter_wrapper_rf_relief, resampling = inner,
                            par.set = ps_rf_filter,
                            control = tune.ctrl_rf, show.info = TRUE,
                            measures = list(rmse))  %>%
  magrittr::inset("id", "RF Relief")

rf_variance = makeTuneWrapper(filter_wrapper_rf_variance, resampling = inner,
                              par.set = ps_rf_filter,
                              control = tune.ctrl_rf, show.info = TRUE,
                              measures = list(rmse))  %>%
  magrittr::inset("id", "RF Variance")

rf_rank.cor = makeTuneWrapper(filter_wrapper_rf_rank.cor, resampling = inner,
                              par.set = ps_rf_filter,
                              control = tune.ctrl_rf, show.info = TRUE,
                              measures = list(rmse))  %>%
  magrittr::inset("id", "RF Spearman")

rf_linear.cor = makeTuneWrapper(filter_wrapper_rf_linear.cor, resampling = inner,
                                par.set = ps_rf_filter,
                                control = tune.ctrl_rf, show.info = TRUE,
                                measures = list(rmse))  %>%
  magrittr::inset("id", "RF Pearson")

rf_mrmr = makeTuneWrapper(filter_wrapper_rf_mrmr, resampling = inner,
                          par.set = ps_rf_filter,
                          control = tune.ctrl_rf, show.info = TRUE,
                          measures = list(rmse))  %>%
  magrittr::inset("id", "RF MRMR")

rf_cmim = makeTuneWrapper(filter_wrapper_rf_cmim, resampling = inner,
                          par.set = ps_rf_filter,
                          control = tune.ctrl_rf, show.info = TRUE,
                          measures = list(rmse))  %>%
  magrittr::inset("id", "RF CMIM")

rf_carscore = makeTuneWrapper(filter_wrapper_rf_carscore, resampling = inner,
                              par.set = ps_rf_filter,
                              control = tune.ctrl_rf, show.info = TRUE,
                              measures = list(rmse))  %>%
  magrittr::inset("id", "RF Car")

rf_no_filter = makeTuneWrapper(lrn_rf, resampling = inner,
                               par.set = ps_rf,
                               control = tune.ctrl_rf, show.info = TRUE,
                               measures = list(rmse))  %>%
  magrittr::inset("id", "RF")

rf_pca = makeTuneWrapper(pca_wrapper_rf, resampling = inner,
                         par.set = ps_rf_pca,
                         control = tune.ctrl_rf, show.info = TRUE,
                         measures = list(rmse))  %>%
  magrittr::inset("id", "RF PCA")

# RIDGE ---------------------------------------------------------------------


ridge_hr = makeTuneWrapper(lrn_ridge, resampling = inner,
                           par.set = ps_ridge_hr,
                           control = tune.ctrl_ridge, show.info = TRUE,
                           measures = list(rmse))  %>%
  magrittr::inset("id", "RIDGE HR")

ridge_vi = makeTuneWrapper(lrn_ridge, resampling = inner,
                           par.set = ps_ridge_vi,
                           control = tune.ctrl_ridge, show.info = TRUE,
                           measures = list(rmse))  %>%
  magrittr::inset("id", "RIDGE VI")

ridge_nri = makeTuneWrapper(lrn_ridge, resampling = inner,
                           par.set = ps_ridge_nri,
                           control = tune.ctrl_ridge, show.info = TRUE,
                           measures = list(rmse))  %>%
  magrittr::inset("id", "RIDGE NRI")

ridge_hr_nri = makeTuneWrapper(lrn_ridge, resampling = inner,
                            par.set = ps_ridge_hr_nri,
                            control = tune.ctrl_ridge, show.info = TRUE,
                            measures = list(rmse))  %>%
  magrittr::inset("id", "RIDGE HR NRI")

ridge_hr_vi = makeTuneWrapper(lrn_ridge, resampling = inner,
                            par.set = ps_ridge_hr_vi,
                            control = tune.ctrl_ridge, show.info = TRUE,
                            measures = list(rmse))  %>%
  magrittr::inset("id", "RIDGE HR VI")

ridge_hr_nri_vi = makeTuneWrapper(lrn_ridge, resampling = inner,
                              par.set = ps_ridge_hr_nri_vi,
                              control = tune.ctrl_ridge, show.info = TRUE,
                              measures = list(rmse))  %>%
  magrittr::inset("id", "RIDGE HR NRI VI")

# LASSO ---------------------------------------------------------------------

lasso_hr = makeTuneWrapper(lrn_lasso, resampling = inner,
                           par.set = ps_lasso_hr,
                           control = tune.ctrl_lasso, show.info = TRUE,
                           measures = list(rmse))  %>%
  magrittr::inset("id", "lasso HR")

lasso_vi = makeTuneWrapper(lrn_lasso, resampling = inner,
                           par.set = ps_lasso_vi,
                           control = tune.ctrl_lasso, show.info = TRUE,
                           measures = list(rmse))  %>%
  magrittr::inset("id", "lasso VI")

lasso_nri = makeTuneWrapper(lrn_lasso, resampling = inner,
                            par.set = ps_lasso_nri,
                            control = tune.ctrl_lasso, show.info = TRUE,
                            measures = list(rmse))  %>%
  magrittr::inset("id", "lasso nri")

lasso_hr_nri = makeTuneWrapper(lrn_lasso, resampling = inner,
                               par.set = ps_lasso_hr_nri,
                               control = tune.ctrl_lasso, show.info = TRUE,
                               measures = list(rmse))  %>%
  magrittr::inset("id", "lasso hr_nri")

lasso_hr_vi = makeTuneWrapper(lrn_lasso, resampling = inner,
                              par.set = ps_lasso_hr_vi,
                              control = tune.ctrl_lasso, show.info = TRUE,
                              measures = list(rmse))  %>%
  magrittr::inset("id", "lasso hr_vi")

lasso_hr_nri_vi = makeTuneWrapper(lrn_lasso, resampling = inner,
                                  par.set = ps_lasso_hr_nri_vi,
                                  control = tune.ctrl_lasso, show.info = TRUE,
                                  measures = list(rmse))  %>%
  magrittr::inset("id", "lasso hr_nri_vi")

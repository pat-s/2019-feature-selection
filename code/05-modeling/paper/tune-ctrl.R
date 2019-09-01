tune.ctrl_xgboost = makeTuneControlRandom(maxit = 100L)
tune.ctrl_svm = makeTuneControlRandom(maxit = 100L)
tune.ctrl_rf = makeTuneControlRandom(maxit = 100L)
tune.ctrl_ridge = makeTuneControlRandom(maxit = 100L)
tune.ctrl_lasso = makeTuneControlRandom(maxit = 100L)

# mbo tuning, filter -----------------------------------------------------------

tune.ctrl_xgboost_mbo_filter = tune_ctrl_mbo_30n_70it(ps_xgboost_filter)
tune.ctrl_svm_mbo_filter  = tune_ctrl_mbo_30n_70it(ps_svm_filter)
tune.ctrl_rf_mbo_filter  = tune_ctrl_mbo_30n_70it(ps_rf_filter)

# mbo tuning, pca --------------------------------------------------------------

tune.ctrl_xgboost_mbo_pca = tune_ctrl_mbo_30n_70it(ps_xgboost_pca)
tune.ctrl_svm_mbo_pca  = tune_ctrl_mbo_30n_70it(ps_svm_pca)
tune.ctrl_rf_mbo_pca  = tune_ctrl_mbo_30n_70it(ps_rf_pca)

# mbo tuning, no filter --------------------------------------------------------

tune.ctrl_xgboost_mbo = tune_ctrl_mbo_30n_70it(ps_xgboost)
tune.ctrl_svm_mbo  = tune_ctrl_mbo_30n_70it(ps_svm)
tune.ctrl_rf_mbo  = tune_ctrl_mbo_30n_70it(ps_rf)
tune.ctrl_ridge_mbo  = tune_ctrl_mbo_30n_70it(ps_ridge)
tune.ctrl_lasso_mbo  = tune_ctrl_mbo_30n_70it(ps_lasso)

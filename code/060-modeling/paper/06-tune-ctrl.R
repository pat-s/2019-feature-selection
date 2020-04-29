# Custom aggregation -----------------------------------------------------------

# Plan -------------------------------------------------------------------------

tune_ctrl_plan <- drake_plan(

  ps_filter = list(
    ps_rf_filter,
    ps_xgboost_filter,
    ps_svm_filter
  ),

  ps_pca = list(
    ps_rf_pca,
    ps_xgboost_pca,
    ps_svm_pca
  ),

  ps_no_filter = list(
    ps_rf,
    ps_xgboost,
    ps_svm,
    ps_ridge,
    ps_lasso
  ),

  # tune_ctrl_random = target(
  #   makeTuneControlRandom(maxit = 100L)
  # ),

  # mbo tuning, filter ---------------------------------------------------------

  tune_ctrl_mbo_30n_70it_filter = target(
    tune_ctrl_mbo_30n_70it(ps_filter[[1]]),
    dynamic = map(ps_filter)
  ),

  # mbo tuning, pca ------------------------------------------------------------

  tune_ctrl_mbo_30n_70it_pca = target(
    tune_ctrl_mbo_30n_70it(ps_pca[[1]]),
    dynamic = map(ps_pca)
  ),

  # mbo tuning, no filter ------------------------------------------------------

  tune_ctrl_mbo_30n_70it_no_filter = target(
    tune_ctrl_mbo_30n_70it(ps_no_filter[[1]]),
    dynamic = map(ps_no_filter)
  )
)

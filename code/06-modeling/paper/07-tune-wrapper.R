# Custom aggregations ----------------------------------------------------------

# The following three objects are for creating a pretty learner ID for the
# tune wrapper
learner_names <- c(
  "RF MBO ",
  "XGBOOST MBO ",
  "SVM MBO "
)

filter_names_pretty <- c(
  "Car",
  "Info Gain",
  "Relief",
  "Pearson",
  "MRMR",
  "CMIM"
)

learner_ids_pretty <- purrr::map(learner_names, ~
paste0(.x, filter_names_pretty)) %>%
  purrr::flatten_chr() %>%
  c(., sprintf("%sBorda", learner_names)) %>%
  c(., sprintf("%sPCA", learner_names)) %>%
  c(., sprintf("%sNo Filter", learner_names)) %>%
  append(c("Lasso-MBO", "Ridge-MBO"))

# Plan -------------------------------------------------------------------------

tune_wrapper_plan <- drake_plan(

  # we need to create the repeated objects outside of `ps_mbo` to be
  # picked up correctly
  ps_rf_filter_rep = rep(list(ps_rf_filter), length(filter_names)),
  ps_rf_filter_xgboost = rep(list(ps_xgboost_filter), length(filter_names)),
  ps_rf_filter_svm = rep(list(ps_svm_filter), length(filter_names)),

  # order is important here! Follows the order of 'filter_wrappers_all'
  ps_mbo = c(
    # simple filters
    ps_rf_filter_rep,
    ps_rf_filter_xgboost,
    ps_rf_filter_svm,

    # Borda
    list(ps_rf_filter),
    list(ps_xgboost_filter),
    list(ps_svm_filter),

    # PCA
    list(ps_rf_pca),
    list(ps_xgboost_pca),
    list(ps_svm_pca),

    # RF, SVM, XGB without filter wrappers
    list(ps_rf),
    list(ps_xgboost),
    list(ps_svm),

    list(ps_lasso),
    list(ps_ridge)
  ),

  # we need to create the repeated objects outside of `tune_ctrl_mbo` to be
  # picked up correctly
  tune_ctrl_mbo_rf = rep(
    list(tune_ctrl_mbo_30n_70it_filter[[1]]),
    length(filter_names)
  ), # rf
  tune_ctrl_mbo_xgboost = rep(
    list(tune_ctrl_mbo_30n_70it_filter[[2]]),
    length(filter_names)
  ), # xgboost
  tune_ctrl_mbo_svm = rep(
    list(tune_ctrl_mbo_30n_70it_filter[[3]]),
    length(filter_names)
  ), # svm

  # order is important here! Follows the order of 'filter_wrappers_all'
  tune_ctrl_mbo = c(

    # simple filters
    tune_ctrl_mbo_rf,
    tune_ctrl_mbo_xgboost,
    tune_ctrl_mbo_svm,

    # Borda
    list(tune_ctrl_mbo_30n_70it_filter[[1]]), # rf
    list(tune_ctrl_mbo_30n_70it_filter[[2]]), # xgboost
    list(tune_ctrl_mbo_30n_70it_filter[[3]]), # svm

    # PCA
    list(tune_ctrl_mbo_30n_70it_pca[[1]]), # rf
    list(tune_ctrl_mbo_30n_70it_pca[[2]]), # xgboost
    list(tune_ctrl_mbo_30n_70it_pca[[3]]), # svm

    # RF, SVM, XGB without filter wrappers
    list(tune_ctrl_mbo_30n_70it_no_filter[[1]]), # rf
    list(tune_ctrl_mbo_30n_70it_no_filter[[2]]), # xgboost
    list(tune_ctrl_mbo_30n_70it_no_filter[[3]]), # svm

    list(tune_ctrl_mbo_30n_70it_no_filter[[4]]), # lasso
    list(tune_ctrl_mbo_30n_70it_no_filter[[5]]) # ridge
  ),

  # MBO ------------------------------------------------------------------------

  tune_wrappers_mbo = target(
    makeTuneWrapper(filter_wrappers_all[[1]],
      resampling = rsmp_cv_fixed,
      par.set = ps_mbo[[1]],
      control = tune_ctrl_mbo[[1]],
      show.info = TRUE,
      measures = list(
        setAggregation(rmse, test.mean)
      )
    ) %>%
      magrittr::inset("id", learner_ids_pretty),
    dynamic = map(
      filter_wrappers_all, ps_mbo,
      tune_ctrl_mbo, learner_ids_pretty
    )
  )
)

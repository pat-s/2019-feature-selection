# Random Forest -----------------------------------------------------------

filter_wrapper_rf_borda <- makeFilterWrapper(lrn_rf,
  fw.method = "E-Borda", cache = TRUE,
  fw.base.methods = c(
    "FSelectorRcpp_information.gain",
    "linear.correlation",
    "praznik_MRMR", "praznik_CMIM",
    "carscore",
    "FSelector_relief"
  ),
  more.args = list("FSelectorRcpp_information.gain" = list(equal = TRUE, nbins = 10)) # FSelectorRcpp
)

filter_wrapper_rf_gain.ratio <- makeFilterWrapper(lrn_rf, fw.method = "FSelectorRcpp_gain.ratio", cache = TRUE, equal = TRUE, nbins = 10)
filter_wrapper_rf_info.gain <- makeFilterWrapper(lrn_rf, fw.method = "FSelectorRcpp_information.gain", cache = TRUE, equal = TRUE, nbins = 10)
filter_wrapper_rf_relief <- makeFilterWrapper(lrn_rf, fw.method = "FSelector_relief", cache = TRUE)
filter_wrapper_rf_variance <- makeFilterWrapper(lrn_rf, fw.method = "variance", cache = TRUE)
filter_wrapper_rf_rank.cor <- makeFilterWrapper(lrn_rf, fw.method = "rank.correlation", cache = TRUE)
filter_wrapper_rf_linear.cor <- makeFilterWrapper(lrn_rf, fw.method = "linear.correlation", cache = TRUE)
filter_wrapper_rf_mrmr <- makeFilterWrapper(lrn_rf, fw.method = "praznik_MRMR", cache = TRUE)
filter_wrapper_rf_cmim <- makeFilterWrapper(lrn_rf, fw.method = "praznik_CMIM", cache = TRUE)
filter_wrapper_rf_carscore <- makeFilterWrapper(lrn_rf, fw.method = "carscore", cache = TRUE)

# XGBOOST -----------------------------------------------------------------

filter_wrapper_xgboost_borda <- makeFilterWrapper(lrn_xgboost,
  fw.method = "E-Borda", cache = TRUE,
  fw.base.methods = c(
    "FSelectorRcpp_information.gain",
    "linear.correlation",
    "praznik_MRMR", "praznik_CMIM",
    "carscore",
    "FSelector_relief"
  ),
  more.args = list("FSelectorRcpp_information.gain" = list(equal = TRUE, nbins = 10)) # FSelectorRcpp
)

filter_wrapper_xgboost_gain.ratio <- makeFilterWrapper(lrn_xgboost, fw.method = "FSelectorRcpp_gain.ratio", cache = TRUE, equal = TRUE, nbins = 10)
filter_wrapper_xgboost_info.gain <- makeFilterWrapper(lrn_xgboost, fw.method = "FSelectorRcpp_information.gain", cache = TRUE, equal = TRUE, nbins = 10)
filter_wrapper_xgboost_relief <- makeFilterWrapper(lrn_xgboost, fw.method = "FSelector_relief", cache = TRUE)
filter_wrapper_xgboost_variance <- makeFilterWrapper(lrn_xgboost, fw.method = "variance", cache = TRUE)
filter_wrapper_xgboost_rank.cor <- makeFilterWrapper(lrn_xgboost, fw.method = "rank.correlation", cache = TRUE)
filter_wrapper_xgboost_linear.cor <- makeFilterWrapper(lrn_xgboost, fw.method = "linear.correlation", cache = TRUE)
filter_wrapper_xgboost_mrmr <- makeFilterWrapper(lrn_xgboost, fw.method = "praznik_MRMR", cache = TRUE)
filter_wrapper_xgboost_cmim <- makeFilterWrapper(lrn_xgboost, fw.method = "praznik_CMIM", cache = TRUE)
filter_wrapper_xgboost_carscore <- makeFilterWrapper(lrn_xgboost, fw.method = "carscore", cache = TRUE)

# SVM ---------------------------------------------------------------------

filter_wrapper_svm_borda <- makeFilterWrapper(lrn_svm,
  fw.method = "E-Borda", cache = TRUE,
  fw.base.methods = c(
    "FSelectorRcpp_information.gain",
    "linear.correlation",
    "praznik_MRMR", "praznik_CMIM",
    "carscore",
    "FSelector_relief"
  ),
  more.args = list("FSelectorRcpp_information.gain" = list(equal = TRUE, nbins = 10)) # FSelectorRcpp
)

filter_wrapper_svm_gain.ratio <- makeFilterWrapper(lrn_svm, fw.method = "FSelectorRcpp_gain.ratio", cache = TRUE, equal = TRUE, nbins = 10)
filter_wrapper_svm_info.gain <- makeFilterWrapper(lrn_svm, fw.method = "FSelectorRcpp_information.gain", cache = TRUE, equal = TRUE, nbins = 10)
filter_wrapper_svm_relief <- makeFilterWrapper(lrn_svm, fw.method = "FSelector_relief", cache = TRUE)
filter_wrapper_svm_variance <- makeFilterWrapper(lrn_svm, fw.method = "variance", cache = TRUE)
filter_wrapper_svm_rank.cor <- makeFilterWrapper(lrn_svm, fw.method = "rank.correlation", cache = TRUE)
filter_wrapper_svm_linear.cor <- makeFilterWrapper(lrn_svm, fw.method = "linear.correlation", cache = TRUE)
filter_wrapper_svm_mrmr <- makeFilterWrapper(lrn_svm, fw.method = "praznik_MRMR", cache = TRUE)
filter_wrapper_svm_cmim <- makeFilterWrapper(lrn_svm, fw.method = "praznik_CMIM", cache = TRUE)
filter_wrapper_svm_carscore <- makeFilterWrapper(lrn_svm, fw.method = "carscore", cache = TRUE)

# LASSO ---------------------------------------------------------------------

filter_wrapper_lasso_borda <- makeFilterWrapper(lrn_lasso,
  fw.method = "E-Borda", cache = TRUE,
  fw.base.methods = c(
    "FSelectorRcpp_information.gain",
    "linear.correlation",
    "praznik_MRMR", "praznik_CMIM",
    "carscore",
    "FSelector_relief"
  ),
  more.args = list("FSelectorRcpp_information.gain" = list(equal = TRUE, nbins = 10)) # FSelectorRcpp
)

filter_wrapper_lasso_gain.ratio <- makeFilterWrapper(lrn_lasso, fw.method = "FSelectorRcpp_gain.ratio", cache = TRUE, equal = TRUE, nbins = 10)
filter_wrapper_lasso_info.gain <- makeFilterWrapper(lrn_lasso, fw.method = "FSelectorRcpp_information.gain", cache = TRUE, equal = TRUE, nbins = 10)
filter_wrapper_lasso_variance <- makeFilterWrapper(lrn_lasso, fw.method = "variance", cache = TRUE)
filter_wrapper_lasso_relief <- makeFilterWrapper(lrn_lasso, fw.method = "FSelector_relief", cache = TRUE)
filter_wrapper_lasso_rank.cor <- makeFilterWrapper(lrn_lasso, fw.method = "rank.correlation", cache = TRUE)
filter_wrapper_lasso_linear.cor <- makeFilterWrapper(lrn_lasso, fw.method = "linear.correlation", cache = TRUE)
filter_wrapper_lasso_mrmr <- makeFilterWrapper(lrn_lasso, fw.method = "praznik_MRMR", cache = TRUE)
filter_wrapper_lasso_cmim <- makeFilterWrapper(lrn_lasso, fw.method = "praznik_CMIM", cache = TRUE)
filter_wrapper_lasso_carscore <- makeFilterWrapper(lrn_lasso, fw.method = "carscore", cache = TRUE)

# RIDGE ---------------------------------------------------------------------

filter_wrapper_ridge_borda <- makeFilterWrapper(lrn_ridge,
  fw.method = "E-Borda", cache = TRUE,
  fw.base.methods = c(
    "FSelectorRcpp_information.gain",
    "linear.correlation",
    "praznik_MRMR", "praznik_CMIM",
    "carscore",
    "FSelector_relief"
  ),
  more.args = list("FSelectorRcpp_information.gain" = list(equal = TRUE, nbins = 10)) # FSelectorRcpp
)

filter_wrapper_ridge_gain.ratio <- makeFilterWrapper(lrn_ridge, fw.method = "FSelectorRcpp_gain.ratio", cache = TRUE, equal = TRUE, nbins = 10)
filter_wrapper_ridge_info.gain <- makeFilterWrapper(lrn_ridge, fw.method = "FSelectorRcpp_information.gain", cache = TRUE, equal = TRUE, nbins = 10)
filter_wrapper_ridge_variance <- makeFilterWrapper(lrn_ridge, fw.method = "variance", cache = TRUE)
filter_wrapper_ridge_relief <- makeFilterWrapper(lrn_ridge, fw.method = "FSelector_relief", cache = TRUE)
filter_wrapper_ridge_rank.cor <- makeFilterWrapper(lrn_ridge, fw.method = "rank.correlation", cache = TRUE)
filter_wrapper_ridge_linear.cor <- makeFilterWrapper(lrn_ridge, fw.method = "linear.correlation", cache = TRUE)
filter_wrapper_ridge_mrmr <- makeFilterWrapper(lrn_ridge, fw.method = "praznik_MRMR", cache = TRUE)
filter_wrapper_ridge_cmim <- makeFilterWrapper(lrn_ridge, fw.method = "praznik_CMIM", cache = TRUE)
filter_wrapper_ridge_carscore <- makeFilterWrapper(lrn_ridge, fw.method = "carscore", cache = TRUE)

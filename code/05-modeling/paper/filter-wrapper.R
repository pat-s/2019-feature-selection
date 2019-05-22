# Random Forest -----------------------------------------------------------

filter_wrapper_rf = makeFilterWrapper(lrn_rf, fw.method = "E-Borda", cache = TRUE)

# XGBOOST -----------------------------------------------------------------

filter_wrapper_xgboost = makeFilterWrapper(lrn_xgboost, fw.method = "E-Borda", cache = TRUE)

# SVM ---------------------------------------------------------------------

filter_wrapper_svm = makeFilterWrapper(lrn_svm, fw.method = "E-Borda", cache = TRUE)

# LASSO ---------------------------------------------------------------------

filter_wrapper_lasso = makeFilterWrapper(lrn_lasso, fw.method = "E-Borda", cache = TRUE)

# RIDGE ---------------------------------------------------------------------

filter_wrapper_ridge = makeFilterWrapper(lrn_ridge, fw.method = "E-Borda", cache = TRUE)

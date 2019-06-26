pca_wrapper_svm = makePreprocWrapperCaret(lrn_svm, ppc.pca = TRUE)

pca_wrapper_xgboost = makePreprocWrapperCaret(lrn_xgboost, ppc.pca = TRUE)

pca_wrapper_rf = makePreprocWrapperCaret(lrn_rf, ppc.pca = TRUE)

pca_wrapper_ridge = makePreprocWrapperCaret(lrn_ridge, ppc.pca = TRUE)

pca_wrapper_lasso = makePreprocWrapperCaret(lrn_lasso, ppc.pca = TRUE)

pca_wrapper_lm = makePreprocWrapperCaret(lrn_lm, ppc.pca = TRUE)

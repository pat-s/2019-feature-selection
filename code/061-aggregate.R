bm_aggregated = mergeBenchmarkResults(bm_vi_task_svm_no_filter,
                                      bm_nri_task_svm_no_filter,
                                      bm_hr_task_svm_no_filter,

                                      bm_vi_task_svm_pca,
                                      bm_nri_task_svm_pca,
                                      bm_hr_task_svm_pca,

                                      bm_vi_task_svm_borda,
                                      bm_nri_task_svm_borda,
                                      bm_hr_task_svm_borda,

                                      bm_vi_task_svm_relief,
                                      bm_nri_task_svm_relief,
                                      bm_hr_task_svm_relief,

                                      bm_vi_task_svm_linear.cor,
                                      bm_nri_task_svm_linear.cor,
                                      bm_hr_task_svm_linear.cor,

                                      bm_vi_task_svm_info.gain,
                                      bm_nri_task_svm_info.gain,
                                      bm_hr_task_svm_info.gain,

                                      bm_vi_task_svm_mrmr,
                                      bm_nri_task_svm_mrmr,
                                      bm_hr_task_svm_mrmr,

                                      bm_vi_task_svm_carscore,
                                      bm_nri_task_svm_carscore,
                                      bm_hr_task_svm_carscore,

                                      bm_vi_task_svm_cmim,
                                      bm_nri_task_svm_cmim,
                                      bm_hr_task_svm_cmim,

                                      # rf
                                      bm_vi_task_rf_no_filter,
                                      bm_nri_task_rf_no_filter,
                                      bm_hr_task_rf_no_filter,

                                      bm_vi_task_rf_pca,
                                      bm_nri_task_rf_pca,
                                      bm_hr_task_rf_pca,

                                      bm_vi_task_rf_borda,
                                      bm_nri_task_rf_borda,
                                      bm_hr_task_rf_borda,

                                      bm_vi_task_rf_relief,
                                      bm_nri_task_rf_relief,
                                      bm_hr_task_rf_relief,

                                      bm_vi_task_rf_linear.cor,
                                      bm_nri_task_rf_linear.cor,
                                      bm_hr_task_rf_linear.cor,

                                      bm_vi_task_rf_info.gain,
                                      bm_nri_task_rf_info.gain,
                                      bm_hr_task_rf_info.gain,

                                      bm_vi_task_rf_mrmr,
                                      bm_nri_task_rf_mrmr,
                                      bm_hr_task_rf_mrmr,

                                      bm_vi_task_rf_carscore,
                                      bm_nri_task_rf_carscore,
                                      bm_hr_task_rf_carscore,

                                      bm_vi_task_rf_cmim,
                                      bm_nri_task_rf_cmim,
                                      bm_hr_task_rf_cmim,

                                      # xgboost
                                      bm_vi_task_xgboost_no_filter,
                                      bm_nri_task_xgboost_no_filter,
                                      bm_hr_task_xgboost_no_filter,

                                      bm_vi_task_xgboost_pca,
                                      bm_nri_task_xgboost_pca,
                                      bm_hr_task_xgboost_pca,

                                      bm_vi_task_xgboost_borda,
                                      bm_nri_task_xgboost_borda,
                                      bm_hr_task_xgboost_borda,

                                      bm_vi_task_xgboost_relief,
                                      bm_nri_task_xgboost_relief,
                                      bm_hr_task_xgboost_relief,

                                      bm_vi_task_xgboost_linear.cor,
                                      bm_nri_task_xgboost_linear.cor,
                                      bm_hr_task_xgboost_linear.cor,

                                      bm_vi_task_xgboost_info.gain,
                                      bm_nri_task_xgboost_info.gain,
                                      bm_hr_task_xgboost_info.gain,

                                      bm_vi_task_xgboost_mrmr,
                                      bm_nri_task_xgboost_mrmr,
                                      bm_hr_task_xgboost_mrmr,

                                      bm_vi_task_xgboost_carscore,
                                      bm_nri_task_xgboost_carscore,
                                      bm_hr_task_xgboost_carscore,

                                      bm_vi_task_xgboost_cmim,
                                      bm_nri_task_xgboost_cmim,
                                      bm_hr_task_xgboost_cmim,


                                      # lasso
                                      bm_vi_task_lasso_no_filter,
                                      bm_nri_task_lasso_no_filter,
                                      bm_hr_task_lasso_no_filter,


                                      # ridge
                                      bm_vi_task_ridge_no_filter,
                                      bm_nri_task_ridge_no_filter,
                                      bm_hr_task_ridge_no_filter,

                                      # lm
                                      bm_vi_task_lm_no_filter,
                                      bm_nri_task_lm_no_filter,
                                      bm_hr_task_lm_no_filter,

                                      bm_vi_task_lm_pca,
                                      bm_nri_task_lm_pca,
                                      bm_hr_task_lm_pca,

                                      bm_vi_task_lm_borda,
                                      bm_nri_task_lm_borda,
                                      bm_hr_task_lm_borda,

                                      bm_vi_task_lm_relief,
                                      bm_nri_task_lm_relief,
                                      bm_hr_task_lm_relief,

                                      bm_vi_task_lm_linear.cor,
                                      bm_nri_task_lm_linear.cor,
                                      bm_hr_task_lm_linear.cor,

                                      bm_vi_task_lm_info.gain,
                                      bm_nri_task_lm_info.gain,
                                      bm_hr_task_lm_info.gain,

                                      bm_vi_task_lm_mrmr,
                                      bm_nri_task_lm_mrmr,
                                      bm_hr_task_lm_mrmr,

                                      bm_vi_task_lm_carscore,
                                      bm_nri_task_lm_carscore,
                                      bm_hr_task_lm_carscore,

                                      bm_vi_task_lm_cmim,
                                      bm_nri_task_lm_cmim,
                                      bm_hr_task_lm_cmim

                                      )

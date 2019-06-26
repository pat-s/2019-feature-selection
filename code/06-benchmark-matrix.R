# see https://ropenscilabs.github.io/drake-manual/plans.html#large-plans

bm_plan = drake_plan(bm = target(
  benchmark_custom_no_models(learner, task),
  transform = cross(
    task = c("vi" = vi_task, "nri" = nri_task, "hr" = hr_task),
    learner = c(svm_borda,
                svm_info.gain,
                svm_gain.ratio,
                svm_variance,
                svm_rank.cor,
                svm_linear.cor,
                svm_mrmr,
                svm_cmim,
                svm_carscore,
                svm_no_filter,
                svm_pca,

                rf_borda,
                rf_info.gain,
                rf_gain.ratio,
                rf_variance,
                rf_rank.cor,
                rf_linear.cor,
                rf_mrmr,
                rf_cmim,
                rf_carscore,
                rf_no_filter,
                rf_pca,

                xgboost_borda,
                xgboost_info.gain,
                xgboost_gain.ratio,
                xgboost_variance,
                xgboost_rank.cor,
                xgboost_linear.cor,
                xgboost_mrmr,
                xgboost_cmim,
                xgboost_carscore,
                xgboost_no_filter,
                xgboost_pca,

                ridge_no_filter,

                lasso_no_filter#,

                # lm_borda,
                # lm_info.gain,
                # lm_gain.ratio,
                # lm_variance,
                # lm_rank.cor,
                # lm_linear.cor,
                # lm_mrmr,
                # lm_cmim,
                # lm_carscore,
                # lrn_lm,
                # lm_pca

                ),
  )
))

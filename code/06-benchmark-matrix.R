# see https://ropenscilabs.github.io/drake-manual/plans.html#large-plans

bm_plan = drake_plan(bm = target(
  benchmark_custom_no_models(task, learner),
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

                ridge_borda,
                ridge_info.gain,
                ridge_gain.ratio,
                ridge_variance,
                ridge_rank.cor,
                ridge_linear.cor,
                ridge_mrmr,
                ridge_cmim,
                ridge_carscore,
                ridge_no_filter,

                lasso_borda,
                lasso_info.gain,
                lasso_gain.ratio,
                lasso_variance,
                lasso_rank.cor,
                lasso_linear.cor,
                lasso_mrmr,
                lasso_cmim,
                lasso_carscore,
                lasso_no_filter

                ),
    # task_name = c("vi", "nri", "hr"), # set pretty names for benchmark matrix
    # .id = c(task_name, learner) # apply pretty names for benchmark matrix
  )
))

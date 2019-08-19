# see https://ropenscilabs.github.io/drake-manual/plans.html#large-plans

bm_plan = drake_plan(
  bm = drake::target(
    benchmark_custom_no_models(learner = learner, task = task),
    transform = cross(
      task = c("vi" = vi_task, "nri" = nri_task, "hr" = hr_task,
               "hr_nri_vi" = hr_nri_vi_task, "hr_nri" = hr_nri_task,
               "hr_vi" = hr_vi_task),
      learner = c(
                  svm_info.gain,
                  svm_relief,
                  svm_linear.cor,
                  svm_mrmr,
                  svm_cmim,
                  svm_carscore,
                  svm_no_filter,
                  svm_pca,

                  rf_info.gain,
                  rf_relief,
                  rf_linear.cor,
                  rf_mrmr,
                  rf_cmim,
                  rf_carscore,
                  rf_no_filter,
                  rf_pca,

                  xgboost_info.gain,
                  xgboost_relief,
                  xgboost_linear.cor,
                  xgboost_mrmr,
                  xgboost_cmim,
                  xgboost_carscore,
                  xgboost_no_filter,
                  xgboost_pca,

                  lasso_info.gain,
                  lasso_relief,
                  lasso_linear.cor,
                  lasso_mrmr,
                  lasso_cmim,
                  lasso_carscore,
                  lasso_no_filter,
                  lasso_pca,

                  ridge_info.gain,
                  ridge_relief,
                  ridge_linear.cor,
                  ridge_mrmr,
                  ridge_cmim,
                  ridge_carscore,
                  ridge_no_filter,
                  ridge_pca
      )
    )
  ),

  #  we face some errors when parallelizing the borda filters, maybe due to
  # parallel access to the mlr cache?
  bm_borda = drake::target(
    benchmark_custom_no_models_sequential(learner, task),
    transform = cross(
      task = c("vi" = vi_task, "nri" = nri_task, "hr" = hr_task,
               "hr_nri_vi" = hr_nri_vi_task, "hr_nri" = hr_nri_task,
               "hr_vi" = hr_vi_task),
      learner = c(svm_borda,
                  rf_borda,
                  xgboost_borda,
                  ridge_borda,
                  lasso_borda
      )
    )
  )
)

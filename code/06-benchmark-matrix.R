# see https://ropenscilabs.github.io/drake-manual/plans.html#large-plans

bm_plan = drake_plan(
  bm = drake::target(
    benchmark_custom_no_models(learner = learner, task = task),
    transform = cross(
      task = c("vi" = vi_task, "nri" = nri_task, "hr" = hr_task,
               "hr_nri_vi" = hr_nri_vi_task, "hr_nri" = hr_nri_task,
               "hr_vi" = hr_vi_task),

               ## only running with the non-transformed variable

               # "vi_boxcox" = vi_task_boxcox, "nri_boxcox" = nri_task_boxcox,
               # "hr_boxcox" = hr_task_boxcox, "hr_nri_boxcox" = hr_nri_task_boxcox,
               # "hr_vi_boxcox" = hr_vi_task_boxcox, "hr_nri_vi_boxcox" = hr_nri_vi_task_boxcox,
               #
               # "vi_log" = vi_task_log, "nri_log" = nri_task_log,
               # "hr_log" = hr_task_log, "hr_nri_log" = hr_nri_task_log,
               # "hr_vi_log" = hr_vi_task_log, "hr_nri_vi_log" = hr_nri_vi_task_log),

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

                  # xgboost_info.gain,
                  # xgboost_relief,
                  # xgboost_linear.cor,
                  # xgboost_mrmr,
                  # xgboost_cmim,
                  # xgboost_carscore,
                  # xgboost_no_filter,
                  # xgboost_pca,

                  lasso_no_filter,
                  lrn_lassocv,

                  ridge_no_filter,
                  lrn_ridgecv
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
  )# ,
  # These models are only included to inspect the resulting models in detail
  # bm_models = drake::target(
  #   benchmark_custom(learner = learner, task = task),
  #   transform = cross(
  #     task = c("vi" = vi_task, "nri" = nri_task, "hr" = hr_task,
  #              "hr_nri_vi" = hr_nri_vi_task, "hr_nri" = hr_nri_task,
  #              "hr_vi" = hr_vi_task),
  #     learner = c(
  #       # lasso_info.gain,
  #       # lasso_relief,
  #       # lasso_linear.cor,
  #       # lasso_mrmr,
  #       # lasso_cmim,
  #       # lasso_carscore,
  #       # lasso_no_filter,
  #       # lrn_lassocv,
  #       #lasso_pca,
  #
  #       # ridge_info.gain,
  #       # ridge_relief,
  #       # ridge_linear.cor,
  #       # ridge_mrmr,
  #       # ridge_cmim,
  #       # ridge_carscore,
  #       # ridge_no_filter,
  #       # lrn_ridgecv#,
  #       #ridge_pca
  #     )
  #   )
  # ),
)

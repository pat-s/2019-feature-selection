# see https://ropenscilabs.github.io/drake-manual/plans.html#large-plans

bm_plan <- drake_plan(
  bm = drake::target(
    benchmark_custom_no_models(learner = learner, task = task),
    transform = cross(
      task = c(
        "vi" = vi_task, "nri" = nri_task, "hr" = hr_task,
        "hr_nri_vi" = hr_nri_vi_task, "hr_nri" = hr_nri_task,
        "hr_vi" = hr_vi_task
      ),

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

        svm_info.gain_mbo,
        svm_relief_mbo,
        svm_linear.cor_mbo,
        svm_mrmr_mbo,
        svm_cmim_mbo,
        svm_carscore_mbo,
        svm_no_filter_mbo,
        svm_pca_mbo,

        rf_info.gain,
        rf_relief,
        rf_linear.cor,
        rf_mrmr,
        rf_cmim,
        rf_carscore,
        rf_no_filter,
        rf_pca,

        rf_info.gain_mbo,
        rf_relief_mbo,
        rf_linear.cor_mbo,
        rf_mrmr_mbo,
        rf_cmim_mbo,
        rf_carscore_mbo,
        rf_no_filter_mbo,
        rf_pca_mbo,

        xgboost_info.gain,
        xgboost_relief,
        xgboost_linear.cor,
        xgboost_mrmr,
        xgboost_cmim,
        xgboost_carscore,
        xgboost_no_filter,
        xgboost_pca,

        # xgboost_info.gain_mbo,
        # xgboost_relief_mbo,
        # xgboost_linear.cor_mbo,
        # xgboost_mrmr_mbo,
        # xgboost_cmim_mbo,
        # xgboost_carscore_mbo,
        # xgboost_no_filter_mbo,
        # xgboost_pca_mbo,

        lasso_no_filter,
        lrn_lassocv,

        lasso_no_filter_mbo,

        ridge_no_filter,
        lrn_ridgecv,

        ridge_no_filter_mbo
      )
    )
  ),

  ### testing only
  # bm_seq = drake::target(
  #   benchmark_custom_no_models_sequential(learner, task),
  #   transform = cross(
  #     task = c("vi" = vi_task, "nri" = nri_task, "hr" = hr_task,
  #              "hr_nri_vi" = hr_nri_vi_task, "hr_nri" = hr_nri_task,
  #              "hr_vi" = hr_vi_task),
  #     learner = c(#svm_no_filter_mbo,
  #                 #svm_pca_mbo
  #                 #svm_mrmr_mbo
  #
  #                 # svm_borda_mbo,
  #                 # rf_borda_mbo,
  #                 # xgboost_borda_mbo,
  #     )
  #   )
  # ),

  #  we face some errors when parallelizing the borda filters, maybe due to
  # parallel access to the mlr cache?
  bm_borda = drake::target(
    benchmark_custom_no_models_sequential(learner, task),
    transform = cross(
      task = c(
        "vi" = vi_task, "nri" = nri_task, "hr" = hr_task,
        "hr_nri_vi" = hr_nri_vi_task, "hr_nri" = hr_nri_task,
        "hr_vi" = hr_vi_task
      ),
      learner = c(
        svm_borda,
        rf_borda,
        xgboost_borda,

        svm_borda_mbo,
        rf_borda_mbo # ,
        # xgboost_borda_mbo
      )
    )
  ) # ,
  # These models are only included to inspect the resulting models in detail
  # bm_models = drake::target(
  #   benchmark_custom(learner = learner, task = task),
  #   transform = cross(
  #     task = c("vi" = vi_task, "nri" = nri_task, "hr" = hr_task,
  #              "hr_nri_vi" = hr_nri_vi_task, "hr_nri" = hr_nri_task,
  #              "hr_vi" = hr_vi_task),
  #     learner = c(
  #       # lasso_no_filter,
  #       # lrn_lassocv,
  #       #lasso_pca,
  #
  #       # ridge_no_filter,
  #       # lrn_ridgecv#,
  #       #ridge_pca
  #     )
  #   )
  # ),
)

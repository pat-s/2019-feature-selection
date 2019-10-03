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

      learner = c(

        svm_info.gain_mbo,
        svm_relief_mbo,
        svm_linear.cor_mbo,
        svm_mrmr_mbo,
        svm_cmim_mbo,
        svm_carscore_mbo,
        svm_no_filter_mbo,
        svm_pca_mbo,

        rf_info.gain_mbo,
        rf_relief_mbo,
        rf_linear.cor_mbo,
        rf_mrmr_mbo,
        rf_cmim_mbo,
        rf_carscore_mbo,
        rf_no_filter_mbo,
        rf_pca_mbo,

        xgboost_info.gain_mbo,
        xgboost_relief_mbo,
        xgboost_linear.cor_mbo,
        xgboost_mrmr_mbo,
        xgboost_cmim_mbo,
        xgboost_carscore_mbo,
        xgboost_no_filter_mbo,
        xgboost_pca_mbo,

        lrn_lassocv,

        lasso_no_filter_mbo,

        lrn_ridgecv,

        ridge_no_filter_mbo,

        svm_borda_mbo,
        rf_borda_mbo ,
        xgboost_borda_mbo
      )
    )
  ),

  # These models are only included to inspect the resulting models in detail
  bm_models = drake::target(
    benchmark_custom(learner = learner, task = task),
    transform = cross(
      task = c("vi" = vi_task, "nri" = nri_task, "hr" = hr_task,
               "hr_nri_vi" = hr_nri_vi_task, "hr_nri" = hr_nri_task,
               "hr_vi" = hr_vi_task),
      learner = c(
        lasso_no_filter_mbo,

        ridge_no_filter_mbo,
        rf_no_filter_mbo
      )
    )
  ),
)

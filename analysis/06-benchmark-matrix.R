# see https://ropenscilabs.github.io/drake-manual/plans.html#large-plans

drake_plan(bm = target(
  benchmark_custom_no_extract_no_pred_no_models(task, learner),
  transform = cross(
    task = c("vi" = vi_task, "nri" = nri_task, "hr" = hr_task),
    learner = c(svm,
                xgboost,
                rf,
                ridge,
                lasso),
    # task_name = c("vi", "nri", "hr"), # set pretty names for benchmark matrix
    # .id = c(task_name, learner) # apply pretty names for benchmark matrix
  )
))

resampling_plan <- drake_plan(
  rsmp_cv_fixed = target(makeResampleDesc("CV", fixed = TRUE))
)

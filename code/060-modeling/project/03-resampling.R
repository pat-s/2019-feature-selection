resampling_plan_project <- drake_plan(
  resampl_inner = target(makeResampleDesc("CV", fixed = TRUE)),
  resamp_outer = target(makeResampleDesc("CV", fixed = TRUE)),
)

reports_plan_paper <- drake_plan(
  eda_wfr = target({
    wflow_publish(knitr_in("analysis/eda.Rmd"), view = FALSE, verbose = TRUE)
    copy_figures()
  }),
  spectral_signatures_wfr = target({
    wflow_publish(knitr_in("analysis/spectral-signatures.Rmd"), view = FALSE)
    copy_figures()
  }),
  filter_correlations_wfr = target({
    wflow_publish(knitr_in("analysis/filter-correlation.Rmd"),
      view = FALSE,
      verbose = TRUE
    )
    copy_figures()
  }),
  eval_performance_wfr = target({
    wflow_publish(knitr_in("analysis/eval-performance.Rmd"),
      view = FALSE,
      verbose = TRUE
    )
    copy_figures()
  }),
  response_normality_wfr = target({
    wflow_publish(knitr_in("analysis/response-normality.Rmd"),
      view = FALSE,
      verbose = TRUE
    )
    copy_figures()
  })
)

reports_plan_project <- drake_plan(
  defoliation_maps_wfr = target(
    wflow_publish(knitr_in("analysis/report-defoliation.Rmd"), view = FALSE)
  )
)

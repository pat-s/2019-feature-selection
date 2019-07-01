reports_plan_paper = drake_plan(

  eda_wfr = wflow_publish(knitr_in("analysis/eda.Rmd"), view = FALSE, verbose = TRUE),

  spectral_signatures_wfr = wflow_publish(knitr_in("analysis/spectral-signatures.Rmd"), view = FALSE),

  filter_correlations_wfr = wflow_publish(knitr_in("analysis/filter-correlation.Rmd"), view = FALSE, verbose = TRUE),

  eval_performance = wflow_publish(knitr_in("analysis/eval-performance.Rmd"), view = FALSE, verbose = TRUE)
)

reports_plan_project = drake_plan(

  defoliation_maps_wfr = wflow_publish(knitr_in("analysis/report-defoliation.Rmd"), view = FALSE)
)


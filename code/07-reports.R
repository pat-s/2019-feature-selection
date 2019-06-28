reports_plan_paper = drake_plan(

  eda_wfr = wflow_publish(knitr_in("analysis/eda.Rmd"), view = FALSE),

  spectral_signatures_wfr = wflow_publish(knitr_in("analysis/spectral-signatures.Rmd"), view = FALSE),

  filter_correlations_wfr = wflow_publish(knitr_in("analysis/filter-correlation.Rmd"), view = FALSE),

  eval_performance = wflow_publish(knitr_in("analysis/eval_performance.Rmd"), view = FALSE)
)

reports_plan_project = drake_plan(

  defoliation_maps_wfr = wflow_publish(knitr_in("analysis/report-defoliation.Rmd"), view = FALSE)
)


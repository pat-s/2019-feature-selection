reports_plan = drake_plan(
  
  eda_wfr = wflow_publish(knitr_in("analysis/eda.Rmd"), view = FALSE),

  defoliation_maps_wfr = wflow_publish(knitr_in("analysis/report-defoliation.Rmd"), view = FALSE),
  
  spectral_signatures_wfr = wflow_publish(knitr_in("analysis/spectral-signatures.Rmd"), view = FALSE),
)


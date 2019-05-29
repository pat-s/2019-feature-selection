reports_plan = drake_plan(

  defoliation_maps_wfr = wflow_publish(knitr_in("analysis/report-defoliation.Rmd"), view = FALSE)
)


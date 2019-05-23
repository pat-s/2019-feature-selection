reports_plan = drake_plan(

  # defoliation_maps = knit(
  #   knitr_in("analysis/rmd/defoliation-maps.Rmd"),
  #   output = file_out("analysis/rmd/defoliation-maps.md"),
  #   quiet = TRUE),

  defoliation_maps_wfr = wflow_build(knitr_in("analysis/defoliation-maps.Rmd"), view = FALSE)#,

  # cloud_cover = knit(
  #   knitr_in("analysis/rmd/cloud-cover.Rmd"),
  #   output = file_out("analysis/rmd/cloud-cover.md"),
  #   quiet = TRUE)

)


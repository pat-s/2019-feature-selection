reports_plan = drake_plan(

  defoliation_maps = knit(
    knitr_in("analysis/rmd/defoliation-maps.Rmd"),
    output = file_out("analysis/rmd/defoliation-maps.md"), # Important: must be the output file
    quiet = TRUE),

  cloud_cover = knit(
    knitr_in("analysis/rmd/cloud-cover.Rmd"),
    output = file_out("analysis/rmd/cloud-cover.md"), # Important: must be the output file
    quiet = TRUE)

)


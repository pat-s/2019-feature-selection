reports_plan = drake_plan(
  defoliation_maps = knitr::knit(
    #opts_knit$set(base.dir = "analysis/rmd/"),
    knitr_in("analysis/rmd/defoliation-maps.Rmd"),
    output = file_out("analysis/rmd/defoliation-maps.md"), # Important: must be the output file
    quiet = TRUE),

  strings_in_dots = "literals"
)

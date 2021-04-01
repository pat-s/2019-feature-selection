tasks_plan <- drake_plan(

  coordinates_list = list(
    coords_bands_clean,
    coords_vi_nri_clean,
    coords_vi_nri_clean,
    coords_vi_nri_clean,
    coords_vi_nri_clean,
    coords_vi_nri_clean
  ),

  data =
    list(
      bands_data,
      vi_data,
      nri_data,
      hr_nri_data,
      nri_vi_data,
      hr_nri_vi_data
    ),

  data_reduced_cor =
    list(
      bands_data_trim_cor,
      vi_data_trim_cor,
      nri_data_trim_cor,
      hr_nri_data_trim_cor,
      nri_vi_data_trim_cor,
      hr_nri_vi_data_trim_cor
    ),

  # Non-log transformed tasks ----------------------------------------------------

  task_names = c(
    "hr",
    "vi",
    "nri",
    "hr_nri",
    "nri_vi",
    "hr_nri_vi"
  ),

  task = target(
    makeRegrTask(
      id = task_names,
      data = data[[1]],
      target = "defoliation",
      coordinates = coordinates_list[[1]],
      blocking = factor(rep(1:4, c(559, 451, 301, 497))),
    ),
    dynamic = map(
      data,
      task_names,
      coordinates_list
    )
  ),

  task_reduced_cor = target(
    makeRegrTask(
      id = task_names,
      data = data_reduced_cor[[1]],
      target = "defoliation",
      coordinates = coordinates_list[[1]],
      blocking = factor(rep(1:4, c(559, 451, 301, 497))),
    ),
    dynamic = map(
      data_reduced_cor,
      task_names,
      coordinates_list
    )
  )
)

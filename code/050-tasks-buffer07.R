tasks_plan <- drake_plan(

  coordinates_list_corrected = list(
    coords_bands_clean_corrected,
    coords_vi_nri_clean_corrected,
    coords_vi_nri_clean_corrected,
    coords_vi_nri_clean_corrected,
    coords_vi_nri_clean_corrected,
    coords_vi_nri_clean_corrected
  ),

  data_corrected =
    list(
      bands_data_corrected,
      vi_data_corrected,
      nri_data_corrected,
      hr_nri_data_corrected,
      nri_vi_data_corrected,
      hr_nri_vi_data_corrected
    ),

  data_corrected_reduced_cor =
    list(
      bands_data_corrected_trim_cor,
      vi_data_corrected_trim_cor,
      nri_data_corrected_trim_cor,
      hr_nri_data_corrected_trim_cor,
      nri_vi_data_corrected_trim_cor,
      hr_nri_vi_data_corrected_trim_cor
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

  task_new = target(
    makeRegrTask(
      id = task_names,
      data = data_corrected[[1]],
      target = "defoliation",
      coordinates = coordinates_list_corrected[[1]],
      blocking = factor(rep(1:4, c(559, 451, 301, 497))),
    ),
    dynamic = map(
      data_corrected,
      task_names,
      coordinates_list_corrected
    )
  ),

  task_new_reduced_cor = target(
    makeRegrTask(
      id = task_names,
      data = data_corrected_reduced_cor[[1]],
      target = "defoliation",
      coordinates = coordinates_list_corrected[[1]],
      blocking = factor(rep(1:4, c(559, 451, 301, 497))),
    ),
    dynamic = map(
      data_corrected_reduced_cor,
      task_names,
      coordinates_list_corrected
    )
  )
)

tasks_plan_buffer2 <- drake_plan(
  data_old = list(
    bands_data,
    vi_data,
    nri_data,
    hr_nri_data,
    nri_vi_data,
    hr_nri_vi_data
  ),

  coordinates_list_corrected = list(
    coords_bands_clean_corrected,
    coords_vi_nri_clean_corrected,
    coords_vi_nri_clean_corrected,
    coords_vi_nri_clean_corrected,
    coords_vi_nri_clean_corrected,
    coords_vi_nri_clean_corrected
  ),

  coordinates_list = list(
    coords_bands_clean,
    coords_vi_nri_clean,
    coords_vi_nri_clean,
    coords_vi_nri_clean,
    coords_vi_nri_clean,
    coords_vi_nri_clean
  ),

  data_corrected_buffer2 =
    list(
      bands_data_corrected_buffer2,
      vi_data_corrected_buffer2,
      nri_data_corrected_buffer2,
      hr_nri_data_corrected_buffer2,
      nri_vi_data_corrected_buffer2,
      hr_nri_vi_data_corrected_buffer2
    ),

  # Non-log transformed tasks ----------------------------------------------------
  task_old_buffer2 = target(
    makeRegrTask(
      id = task_names_buffer2,
      data = data_old[[1]],
      target = "defoliation",
      coordinates = coordinates_list[[1]],
      blocking = factor(rep(1:4, c(559, 451, 301, 497))),
    ),
    dynamic = map(
      data_old,
      task_names_buffer2,
      coordinates_list
    )
  ),

  task_names_buffer2 = c(
    "hr_buffer2",
    "vi_buffer2",
    "nri_buffer2",
    "hr_nri_buffer2",
    "nri_vi_buffer2",
    "hr_nri_vi_buffer2"
  ),

  task_new_buffer2 = target(
    makeRegrTask(
      id = task_names_buffer2,
      data = data_corrected_buffer2[[1]],
      target = "defoliation",
      coordinates = coordinates_list_corrected[[1]],
      blocking = factor(rep(1:4, c(559, 451, 301, 497))),
    ),
    dynamic = map(
      data_corrected_buffer2,
      task_names_buffer2,
      coordinates_list_corrected
    )
  )
)

tasks_plan_no_buffer <- drake_plan(
  data_corrected_no_buffer =
    list(
      bands_data_corrected_no_buffer,
      vi_data_corrected_no_buffer
    ),

  # Without a buffer we get many NAs for some obs, especially for NRI tasks.
  # This would result in dropping many features as observations are more important.
  # Number of features with no NAs without using a buffer: 101 69 4951 5051 5019 5119
  # Number of features with no NAs with a buffer of 2m:    124 90 7382 7505 7471 7594
  task_names_no_buffer = c(
    "hr_no_buffer",
    "vi_no_buffer" # ,
    # "nri_no_buffer",
    # "hr_nri_no_buffer",
    # "nri_vi_no_buffer",
    # "hr_nri_vi_no_buffer"
  ),

  coordinates_list_corrected_no_buffer = list(
    coordinates_list_corrected[[1]],
    coordinates_list_corrected[[2]]
  ),

  # Non-log transformed tasks ----------------------------------------------------
  task_new_no_buffer = target(
    makeRegrTask(
      id = task_names_no_buffer,
      data = data_corrected_no_buffer[[1]],
      target = "defoliation",
      coordinates = coordinates_list_corrected_no_buffer[[1]],
      blocking = factor(rep(1:4, c(559, 451, 301, 497))),
    ),
    dynamic = map(
      data_corrected_no_buffer,
      task_names_no_buffer,
      coordinates_list_corrected_no_buffer
    )
  )
)

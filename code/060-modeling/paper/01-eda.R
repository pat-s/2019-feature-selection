filter_eda_plan <- drake_plan(
  filter_names = c(
    "carscore",
    "FSelectorRcpp_information.gain",
    "FSelectorRcpp_relief",
    "linear.correlation",
    "praznik_MRMR",
    "praznik_CMIM"
  ),

  # need to oursource them because they need arg equal = TRUE
  filters_FSelectorRcpp = c(
    "FSelectorRcpp_information.gain",
    "FSelectorRcpp_gain.ratio",
    "FSelectorRcpp_symmetrical.uncertainty"
  ),

  names_filter_values = c(
    "carscore",
    "FSelectorRcpp_relief",
    "linear.correlation",
    "rank.correlation",
    "praznik_MRMR",
    "praznik_CMIM",
    "variance"
  ),

  task_list_filter = list(
    task_new_buffer2[[1]],
    task_new_buffer2[[2]],
    task_new_buffer2[[3]]
  ),

  filter_values = target(
    generateFilterValuesData(
      task = task_list_filter[[1]],
      method = names_filter_values
    ),
    dynamic = cross(task_list_filter, names_filter_values)
  ),

  filter_values_fselectorrcpp = target(
    generateFilterValuesData(
      task = task_list_filter[[1]],
      method = filters_FSelectorRcpp,
      equal = TRUE
    ),
    dynamic = cross(task_list_filter, filters_FSelectorRcpp)
  ),

  nbins = seq(5, 30, 5),

  filter_info_gain_nbins = target(
    generateFilterValuesData(
      task = task_list_filter[[1]],
      method = "FSelectorRcpp_information.gain",
      equal = TRUE,
      nbins = nbins
    ),
    dynamic = cross(task_list_filter, nbins = nbins)
  )
)

tasks_plan <- drake_plan(

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

  data_corrected =
    list(
      bands_data_corrected,
      vi_data_corrected,
      nri_data_corrected,
      hr_nri_data_corrected,
      nri_vi_data_corrected,
      hr_nri_vi_data_corrected
    ),

  # Non-log transformed tasks ----------------------------------------------------
  task_old = target(
    makeRegrTask(task_names,
                 data_old[[1]],
      target = "defoliation",
      coordinates = coordinates_list[[1]],
      blocking = factor(rep(1:4, c(479, 451, 300, 529))),
    ),
    transform = map(data_old,
      task_names = c(
        "hr",
        "vi",
        "nri",
        "hr_nri",
        "nri_vi",
        "hr_nri_vi"
      ),
      coordinates_list
    )
  ),

  task_new = target(
    makeRegrTask(
      id = task_names,
      data = data_corrected[[1]],
      target = "defoliation",
      coordinates = coordinates_list_corrected[[1]],
      blocking = factor(rep(1:4, c(559, 451, 301, 497))),
    ),
    transform = map(data_corrected,
      task_names = c(
        "hr",
        "vi",
        "nri",
        "hr_nri",
        "nri_vi",
        "hr_nri_vi"
      ),
      coordinates_list_corrected
    )
  )
)

# nri_task <- makeRegrTask(
#   id = "defoliation-all-plots-NRI", data = nri_data,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# vi_task <- makeRegrTask(
#   id = "defoliation-all-plots-VI", data = vi_data,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# hr_task <- makeRegrTask(
#   id = "defoliation-all-plots-HR", data = bands_data,
#   target = "defoliation", coordinates = coords_bands_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# nri_vi_task <- makeRegrTask(
#   id = "defoliation-all-plots-NRI-VI", data = nri_vi_data,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# hr_nri_vi_task <- makeRegrTask(
#   id = "defoliation-all-plots-HR-NRI-VI", data = hr_nri_vi_data,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# hr_vi_task <- makeRegrTask(
#   id = "defoliation-all-plots-HR-VI", data = hr_vi_data,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# hr_nri_task <- makeRegrTask(
#   id = "defoliation-all-plots-HR-NRI", data = hr_nri_data,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
#
# nri_task_corrected <- makeRegrTask(
#   id = "defoliation-all-plots-NRI", data = nri_data_corrected,
#   target = "defoliation", coordinates = coords_vi_nri_clean_corrected,
#   blocking = factor(rep(1:4, c(559, 451, 301, 497)))
# )
#
# vi_task_corrected <- makeRegrTask(
#   id = "defoliation-all-plots-VI", data = vi_data_corrected,
#   target = "defoliation", coordinates = coords_vi_nri_clean_corrected,
#   blocking = factor(rep(1:4, c(559, 451, 301, 497)))
# )
#
# hr_task_corrected <- makeRegrTask(
#   id = "defoliation-all-plots-HR", data = bands_data_corrected,
#   target = "defoliation", coordinates = coords_bands_clean_corrected,
#   blocking = factor(rep(1:4, c(559, 451, 301, 497)))
# )
#
# nri_vi_task_corrected <- makeRegrTask(
#   id = "defoliation-all-plots-NRI-VI", data = nri_vi_data_corrected,
#   target = "defoliation", coordinates = coords_vi_nri_clean_corrected,
#   blocking = factor(rep(1:4, c(559, 451, 301, 497)))
# )
#
# hr_nri_vi_task_corrected <- makeRegrTask(
#   id = "defoliation-all-plots-HR-NRI-VI", data = hr_nri_vi_data_corrected,
#   target = "defoliation", coordinates = coords_vi_nri_clean_corrected,
#   blocking = factor(rep(1:4, c(559, 451, 301, 497)))
# )
#
# hr_vi_task_corrected <- makeRegrTask(
#   id = "defoliation-all-plots-HR-VI", data = hr_vi_data_corrected,
#   target = "defoliation", coordinates = coords_vi_nri_clean_corrected,
#   blocking = factor(rep(1:4, c(559, 451, 301, 497)))
# )
#
# hr_nri_task_corrected <- makeRegrTask(
#   id = "defoliation-all-plots-HR-NRI", data = hr_nri_data_corrected,
#   target = "defoliation", coordinates = coords_vi_nri_clean_corrected,
#   blocking = factor(rep(1:4, c(559, 451, 301, 497)))
# )

# Boxcox transformed tasks -----------------------------------------------------

# nri_task_boxcox <- makeRegrTask(
#   id = "defoliation-all-plots-NRI", data = nri_data_boxcox_transformed,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# vi_task_boxcox <- makeRegrTask(
#   id = "defoliation-all-plots-VI", data = vi_data_boxcox_transformed,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# hr_task_boxcox <- makeRegrTask(
#   id = "defoliation-all-plots-HR", data = bands_data_boxcox_transformed,
#   target = "defoliation", coordinates = coords_bands_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# nri_vi_task_boxcox <- makeRegrTask(
#   id = "defoliation-all-plots-NRI-VI", data = nri_vi_data_boxcox_transformed,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# hr_nri_vi_task_boxcox <- makeRegrTask(
#   id = "defoliation-all-plots-HR-NRI-VI", data = hr_nri_vi_data_boxcox_transformed,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# hr_vi_task_boxcox <- makeRegrTask(
#   id = "defoliation-all-plots-HR-VI", data = hr_vi_data_boxcox_transformed,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# hr_nri_task_boxcox <- makeRegrTask(
#   id = "defoliation-all-plots-HR-NRI", data = hr_nri_data_boxcox_transformed,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )

# Log transformed tasks

# nri_task_log <- makeRegrTask(
#   id = "defoliation-all-plots-NRI", data = nri_data_log_transformed,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# vi_task_log <- makeRegrTask(
#   id = "defoliation-all-plots-VI", data = vi_data_log_transformed,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# hr_task_log <- makeRegrTask(
#   id = "defoliation-all-plots-HR", data = bands_data_log_transformed,
#   target = "defoliation", coordinates = coords_bands_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# nri_vi_task_log <- makeRegrTask(
#   id = "defoliation-all-plots-NRI-VI", data = nri_vi_data_log_transformed,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# hr_nri_vi_task_log <- makeRegrTask(
#   id = "defoliation-all-plots-HR-NRI-VI", data = hr_nri_vi_data_log_transformed,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# hr_vi_task_log <- makeRegrTask(
#   id = "defoliation-all-plots-HR-VI", data = hr_vi_data_log_transformed,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )
#
# hr_nri_task_log <- makeRegrTask(
#   id = "defoliation-all-plots-HR-NRI", data = hr_nri_data_log_transformed,
#   target = "defoliation", coordinates = coords_vi_nri_clean,
#   blocking = factor(rep(1:4, c(479, 451, 300, 529)))
# )

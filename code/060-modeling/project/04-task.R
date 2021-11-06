task_project_plan <- drake_plan(

  # filter 7 most important variables according to xgboost variable imp Mon Mar 11 22:57:56 2019 ------------------------------
  data_7_most_imp = target({
    foo <- nri_vi_data_trim_cor %>%
      subset(select = c(defoliation, bf2_EVI, bf2_GDVI_4, bf2_GDVI_3, bf2_GDVI_2, bf2_D1, bf2_mNDVI, bf2_mSR))
    # dplyr::select(defoliation, bf2_EVI, bf2_GDVI_4, bf2_GDVI_3, bf2_GDVI_2, bf2_D1, bf2_mNDVI, bf2_mSR) %>%
    # as_tibble()

    # trim outliers of variables Mon Mar 11 22:59:05 2019 ------------------------------

    foo %>%
      mutate(bf2_EVI = case_when(bf2_EVI < 0 ~ 0, bf2_EVI > 1.5 ~ 1.5, TRUE ~ as.numeric(bf2_EVI))) %>%
      mutate(bf2_mSR = case_when(bf2_mSR < -3 ~ -3, bf2_mSR > 4 ~ 4, TRUE ~ as.numeric(bf2_mSR))) %>%
      mutate(bf2_D1 = case_when(bf2_D1 > 2.5 ~ 2.5, TRUE ~ as.numeric(bf2_D1))) %>%
      mutate(bf2_GDVI_4 = case_when(bf2_GDVI_4 < -4 ~ -4, TRUE ~ as.numeric(bf2_GDVI_4))) %>%
      mutate(bf2_GDVI_3 = case_when(bf2_GDVI_3 < -4 ~ -4, TRUE ~ as.numeric(bf2_GDVI_3))) %>%
      mutate(bf2_GDVI_2 = case_when(bf2_GDVI_2 < -4 ~ -4, TRUE ~ as.numeric(bf2_GDVI_2))) %>%
      mutate(bf2_mNDVI = case_when(bf2_mNDVI < -3 ~ -3, TRUE ~ as.numeric(bf2_mNDVI)))
  }),

  task_7_most_imp = target(
    makeRegrTask(
      id = "all_plots", data = data_7_most_imp,
      target = "defoliation", coordinates = coordinates_list[[1]],
      blocking = factor(rep(1:4, c(559, 451, 301, 497)))
    )
  )
)

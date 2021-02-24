feature_imp_plan <- drake_plan(
  # Slurm resources suggestion: at least 20 cores and 2 GB / core = 40 GB pro job
  fi_permut_hr_buffer2 = target(feature_imp_parallel(task_new_buffer2[[1]],
    learner = "regr.ksvm", nmc = 100,
    measure = list(
      setAggregation(rmse, test.mean)
    )
  )),

  # Slurm resources suggestion: at least 20 cores and 2 GB / core = 40 GB pro job
  fi_permut_vi_buffer2 = target(feature_imp_parallel(task_new_buffer2[[2]],
    learner = "regr.ksvm", nmc = 100,
    measure = list(
      setAggregation(rmse, test.mean)
    )
  )),

  df_wavelengths_from_indices = target({

    # The table is a cleaned version from https://raw.githubusercontent.com/cran/hsdar/master/man/vegindex.Rd

    df <- data.table::fread("inst/hsdar-veg-indices.tex",
      sep = "&",
      data.table = FALSE, header = FALSE
    ) %>%
      setNames(nm = c("index", "wavelengths", "reference")) %>%
      dplyr::mutate(wavel_ext = stringr::str_extract_all(wavelengths,
        pattern = "[[:digit:]]+"
      ))

    vec_wavelengths <- df %>%
      dplyr::pull(wavel_ext)

    vec_wavelengths_num <- purrr::map(vec_wavelengths, ~ as.numeric(.x))

    vec_wavelengths_num_clean <- purrr::map(
      vec_wavelengths_num,
      function(.x) .x[.x > 200]
    ) %>%
      purrr::set_names(df$index)

    vec_wavelengths_num_final <- purrr::discard(
      vec_wavelengths_num_clean,
      function(.x) any(.x > 1000)
    )

    # convert list of vector to data.frame
    df_wide <- plyr::ldply(vec_wavelengths_num_final, rbind)

    df_wide_formatted <- df_wide %>%
      tidyr::pivot_longer(
        values_to = "wavelength",
        cols = -tidyselect::one_of(".id")
      ) %>%
      dplyr::select(-name) %>%
      dplyr::rename(class = .id) %>%
      na.omit() %>%
      dplyr::distinct()

    return(df_wide_formatted)
  }),

  fi_ale_hr_buffer2 = target({
    mod_hr <- mlr::train(
      tune_wrappers_mbo[[13]], # SVM MBO Car
      task_new_buffer2_reduced_cor[[1]]
    )
    pred <- iml::Predictor$new(
      mod_hr, # SVM MBO Car fitted
      task_new_buffer2_reduced_cor[[1]]$env$data,
    )
    fe <- FeatureEffects$new(pred,
      method = "ale",
      grid.size = 100
    )
    return(fe)
  }),

    fi_ale_hr_buffer2_gs20 = target({
    mod_hr <- mlr::train(
      tune_wrappers_mbo[[13]], # SVM MBO Car
      task_new_buffer2_reduced_cor[[1]]
    )
    pred <- iml::Predictor$new(
      mod_hr, # SVM MBO Car fitted
      task_new_buffer2_reduced_cor[[1]]$env$data,
    )
    fe <- FeatureEffects$new(pred,
      method = "ale",
      grid.size = 20
    )
    return(fe)
  }),

  fi_ale_vi_buffer2 = target({
    mod_hr <- mlr::train(
      tune_wrappers_mbo[[13]], # SVM MBO Car
      task_new_buffer2_reduced_cor[[2]]
    )
    pred <- iml::Predictor$new(
      mod_hr, # SVM MBO Car fitted
      task_new_buffer2_reduced_cor[[2]]$env$data,
    )
    fe <- FeatureEffects$new(pred,
      method = "ale",
      grid.size = 100
    )
    return(fe)
  }),

    fi_ale_vi_buffer2_gs20 = target({
    mod_hr <- mlr::train(
      tune_wrappers_mbo[[13]], # SVM MBO Car
      task_new_buffer2_reduced_cor[[2]]
    )
    pred <- iml::Predictor$new(
      mod_hr, # SVM MBO Car fitted
      task_new_buffer2_reduced_cor[[2]]$env$data,
    )
    fe <- FeatureEffects$new(pred,
      method = "ale",
      grid.size = 20
    )
    return(fe)
  })
)

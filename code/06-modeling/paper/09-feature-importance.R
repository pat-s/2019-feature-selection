feature_imp_plan <- drake_plan(
  fi_permut_hr_buffer2 = target(feature_imp_parallel(task_new_buffer2[[1]],
    learner = "regr.ksvm", nmc = 100,
    measure = list(
      setAggregation(rmse, test.mean)
    )
  )),

  fi_permut_vi_buffer2 = target(feature_imp_parallel(task_new_buffer2[[2]],
    learner = "regr.ksvm", nmc = 100,
    measure = list(
      setAggregation(rmse, test.mean)
    )
  )),
)

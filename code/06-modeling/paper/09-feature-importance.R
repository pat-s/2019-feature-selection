feature_imp_plan <- drake_plan(
  fi_permut_hr = target(feature_imp_parallel(task_new_hr,
    learner = "regr.ksvm", nmc = 100,
    measure = list(
      setAggregation(rmse, test.mean)
    )
  ))
)

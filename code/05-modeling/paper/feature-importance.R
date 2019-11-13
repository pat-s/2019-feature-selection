fi_permut_vi <- feature_imp_parallel(vi_task,
  learner = "regr.ksvm", nmc = 25, cpus = 25,
  measure = setAggregation(rmse, test.mean)
)
fi_permut_nri <- feature_imp_parallel(nri_task,
  learner = "regr.xgboost", nmc = 25, cpus = 25,
  measure = setAggregation(rmse, test.mean)
)
fi_permut_hr <- feature_imp_parallel(hr_task,
  learner = "regr.ksvm", nmc = 25, cpus = 25,
  measure = setAggregation(rmse, test.mean)
)
fi_permut_hr_vi <- feature_imp_parallel(hr_vi_task,
  learner = "regr.ksvm", nmc = 25, cpus = 25,
  measure = setAggregation(rmse, test.mean)
)
fi_permut_hr_nri <- feature_imp_parallel(hr_nri_task,
  learner = "regr.xgboost", nmc = 25, cpus = 25,
  measure = setAggregation(rmse, test.mean)
)
fi_permut_hr_nri_vi <- feature_imp_parallel(hr_nri_vi_task,
  learner = "regr.xgboost", nmc = 25, cpus = 25,
  measure = setAggregation(rmse, test.mean)
)

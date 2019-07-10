fi_permut_vi = generateFilterValuesData(vi_task, method = "permutation.importance",
                                        imp.learner = "regr.ksvm", nmc = 100,
                                        measure = rmse)
fi_permut_nri = generateFilterValuesData(nri_task, method = "permutation.importance",
                                         imp.learner = "regr.ksvm", nmc = 10,
                                         measure = rmse)
fi_permut_hr = generateFilterValuesData(hr_task, method = "permutation.importance",
                                        imp.learner = "regr.ksvm", nmc = 100,
                                        measure = rmse)

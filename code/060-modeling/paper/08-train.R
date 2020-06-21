train_plan <- drake_plan(
  train_hr_xgboost = target(
    train(xgboost_borda, task_new_buffer2[[1]])
  ),

  iml_new_hr = target(Predictor$new(
    train_hr_xgboost,
    task_new_buffer2[[1]]$env$data
  )),

  iml_ale_hr = target({
    cl <- makePSOCKcluster(4)
    registerDoParallel(cl)
    fe <- FeatureEffects$new(iml_new_hr, parallel = TRUE)
    stopCluster(cl)

    return(fe)
  })
)

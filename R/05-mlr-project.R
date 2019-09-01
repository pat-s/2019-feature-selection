tune_ctrl_wrapper <- function(propose.points, iters, n, param_set) {
  ctrl <- makeMBOControl(propose.points = propose.points)
  ctrl <- setMBOControlTermination(ctrl, iters = iters)
  ctrl <- setMBOControlInfill(ctrl, crit = crit.ei)
  tune.ctrl <- makeTuneControlMBO(
    mbo.control = ctrl,
    mbo.design = generateDesign(
      n = n,
      par.set = param_set
    )
  )
}


tune_wrapper <- function(learner, level, cpus, tune.control, show.info, par.set, resampling,
                         measure, task) {
  configureMlr(on.learner.error = "warn", on.error.dump = TRUE)
  parallelStart(
    mode = "multicore", level = level, cpus = ignore(cpus),
    mc.set.seed = TRUE
  )
  set.seed(12345, kind = "L'Ecuyer-CMRG")
  xgboost_tuned <- tuneParams(learner,
    task = task, resampling = resampling,
    par.set = par.set, control = tune.control,
    show.info = ignore(show.info), measure = measure
  )
  parallelStop()
  return(xgboost_tuned)
}

train_wrapper <- function(learner, tune_object, task) {
  lrn_xgboost <- setHyperPars(makeLearner(learner),
    par.vals = tune_object$x
  )
  m <- train(lrn_xgboost, task)

  return(m)
}

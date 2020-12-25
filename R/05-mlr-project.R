#' @title Create a mlr tune control object
#' @description Creates a mlr MBO tune control object
#' @param propose.points See [mlrMBO::makeMBOControl()]
#' @param iters See [mlrMBO::setMBOControlTermination()]
#' @param n See [mlrMBO::makeMBOControl()]
#' @template param_set
tune_ctrl_wrapper <- function(propose.points,
                              iters,
                              n,
                              param_set) {
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
  return(tune.ctrl)
}

#' @title Create a mlr tune wrapper
#' @description Creates a mlr MBO tune wrapper
#' @template learner
#' @param tune.control See [mlr::tuneParams()]
#' @param show.info See [mlr::tuneParams()]
#' @param par.set See [mlr::tuneParams()]
#' @template resampling
#' @template measure
#' @template task
tune_wrapper <- function(learner,
                         tune.control,
                         show.info,
                         par.set,
                         resampling,
                         measure,
                         task) {
  configureMlr(on.learner.error = "warn", on.error.dump = TRUE)
  xgboost_tuned <- tuneParams(learner,
    task = task, resampling = resampling,
    par.set = par.set, control = tune.control,
    show.info = ignore(show.info), measure = measure
  )
  parallelStop()
  return(xgboost_tuned)
}

#' @title Create a mlr train wrapper
#' @description Creates a mlr train wrapper
#' @template learner
#' @param tune_object Optimized hyperparameters
#' @template task
train_wrapper <- function(learner, tune_object, task) {
  lrn_xgboost <- setHyperPars(makeLearner(learner),
    par.vals = tune_object$x
  )
  m <- mlr::train(lrn_xgboost, task)

  return(m)
}

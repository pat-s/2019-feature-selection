#' Reverse Boxcox transformation
#' @param truth Truth value
#' @param response Response value
inv_boxcox_rmse <- function(truth, response) {
  lambda <- 0.7878788
  truth <- (lambda * y_new1 + 1)^(1 / lambda)
  response <- (lambda * y_new1 + 1)^(1 / lambda)

  sqrt(measureMSE(truth, response))
}

#' @title mlrMBO 30n 70 iterations tuning setting
#' @template param_set
#' @export
tune_ctrl_mbo_30n_70it <- function(param_set) {
  makeTuneControlMBO(
    mbo.control = makeMBOControl(
      propose.points = 1L,
      on.surrogate.error = "warn" # ,
    ) %>%
      setMBOControlTermination(iters = 70L) %>%
      setMBOControlInfill(crit = crit.ei),
    mbo.design = generateDesign(n = 30, par.set = param_set) # ,
    # continue = TRUE
  )
}

#' @title Parallel feature importance wrapper
#' @description Calculates feature importance via permutation
#' @template task
#' @template learner
#' @param nmc Number of Monte Carlo iterations
#' @template measure
#' @export
feature_imp_parallel <- function(task, learner, nmc, measure) {
  fi <- generateFeatureImportanceData(
    task = task, method = "permutation.importance",
    learner = learner, nmc = nmc, local = FALSE,
    measure = measure, show.info = TRUE
  )
  parallelStop()
  return(fi)
}

#' @title mlr::benchmark() wrapper
#'
#' @template task
#' @template learner
#' @template resampling
#' @export

benchmark_custom_no_models <- function(learner, task) {

  parallelStart(
    mode = "multicore",
    level = "mlr.resample",
    cpus = 4
  )
  set.seed(12345, kind = "L'Ecuyer-CMRG")

  bmr <- benchmark(learners = learner,
                   tasks = task,
                   models = FALSE,
                   keep.pred = TRUE,
                   resamplings = makeResampleDesc("CV", fixed = TRUE),
                   show.info = TRUE,
                   measures = list(rmse, timetrain)
  )

  parallelStop()
  return(bmr)
}

benchmark_custom_no_models_sequential <- function(learner, task) {

  set.seed(12345, kind = "L'Ecuyer-CMRG")

  bmr <- benchmark(learners = learner,
                   tasks = task,
                   models = FALSE,
                   keep.pred = TRUE,
                   resamplings = makeResampleDesc("CV", fixed = TRUE),
                   show.info = TRUE,
                   measures = list(rmse, timetrain)
  )

  return(bmr)
}

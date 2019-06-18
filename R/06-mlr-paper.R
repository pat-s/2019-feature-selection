#' @title mlr::benchmark() wrapper
#'
#' @template task
#' @template learner
#' @template resampling
#' @export

benchmark_custom_no_models <- function(task, learner, cores) {

  parallelStart(
    mode = "multicore", level = "mlr.resample"
  )
  set.seed(12345, kind = "L'Ecuyer-CMRG")

  bmr <- benchmark(learner, task,
                   models = FALSE,
                   keep.pred = TRUE,
                   resampling = makeResampleDesc("CV", fixed = TRUE),
                   show.info = TRUE,
                   measures = list(rmse, timetrain)
  )

  parallelStop()
  return(bmr)
}

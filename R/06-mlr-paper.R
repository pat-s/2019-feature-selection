#' @title mlr::benchmark() wrapper
#'
#' @template task
#' @template learner
#' @template resampling
#' @export

benchmark_custom_no_extract_no_pred_no_models <- function(task, learner) {

  parallelStart(
    mode = "multicore", cpus = cores, level = "mlr.tuneParams"
  )
  set.seed(12345, kind = "L'Ecuyer-CMRG")

  bmr <- benchmark(learner, task,
                   models = FALSE,
                   keep.pred = TRUE,
                   keep.extract = FALSE,
                   resampling = makeResampleDesc("CV", fixed = TRUE),
                   show.info = TRUE,
                   measures = list(rmse, timetrain)
  )

  parallelStop()
  return(bmr)
}

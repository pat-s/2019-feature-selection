# Info -------------------------------------------------------------------------

# filter_names defined in 01-eda.R

# Plan -------------------------------------------------------------------------

filter_wrapper_plan <- drake_plan(
  learners = list(
    lrn_rf,
    lrn_xgboost,
    lrn_svm
  ),

  filter_wrappers_single = target(
    makeFilterWrapper(learners[[1]], fw.method = filter_names, cache = TRUE),
    dynamic = cross(learners, filter_names)
  ),

  filter_wrappers_borda = target(
    makeFilterWrapper(learners[[1]],
      fw.method = "E-Borda", cache = TRUE,
      fw.base.methods = c(
        "FSelectorRcpp_information.gain",
        "linear.correlation",
        "praznik_MRMR", "praznik_CMIM",
        "carscore",
        "FSelector_relief"
      ),
      more.args = list("FSelectorRcpp_information.gain" = list(
        equal = TRUE,
        nbins = 10 # only avail in my FSelectorRcpp fork
      ))
    ),
    dynamic = map(learners)
  ),

  pca_wrappers = target(
    makePreprocWrapperCaret(learners[[1]], ppc.pca = TRUE),
    dynamic = map(learners)
  ),

  filter_wrappers_all = target(c(
    filter_wrappers_single,
    filter_wrappers_borda,
    pca_wrappers,

    # RF, SVM, XGB without filter wrappers
    learners
  ))
)

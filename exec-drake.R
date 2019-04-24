# make project

r_make()

# visualize

r_vis_drake_graph(
  group = "stage", clusters = c(
    "task", "learner",
    "mlr_settings",
    "benchmark_plan",
    "prediction"
  ),
  targets_only = TRUE, show_output_files = FALSE
)

r_vis_drake_graph()

# see outdated

r_outdated()

# Misc
r_predict_runtime()

r_predict_workers()

make(plan,
  verbose = 2, targets = "data_list_nri_vi_bands", lazy_load = "promise",
  console_log_file = "log/drake.log", cache_log_file = "log/cache3.log",
  caching = "worker",
  template = list(log_file = "log/worker%a.log", n_cpus = 16, memory = 120000),
  prework = quote(future::plan(future::multisession, workers = 3)),
  garbage_collection = TRUE, jobs = 1, parallelism = "clustermq"
)

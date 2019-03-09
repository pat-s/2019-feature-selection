# make project

r_make()

# visualize

r_vis_drake_graph(group = "stage", clusters = c("task", "learner",
                                                "mlr_settings",
                                                "benchmark_plan",
                                                "prediction"),
                  targets_only = TRUE, show_output_files = FALSE)

r_vis_drake_graph()

# see outdated

r_outdated()

# Misc
r_predict_runtime()

r_predict_workers()

source("analysis/drake.R")

# Visualization -----------------------------------------------------------

### no data_plan grouping
vis_drake_graph(config, group = "stage", clusters = c("task", "learner",
                                                      "mlr_settings",
                                                      "benchmark_plan",
                                                      "prediction"),
                targets_only = TRUE, show_output_files = FALSE)

sankey_drake_graph(config, group = "stage", clusters = c("task", "learner",
                                                                 "mlr_settings",
                                                                 "benchmark_plan",
                                                                 "prediction"),
                   targets_only = TRUE, show_output_files = FALSE)

drake_ggraph(config, group = "stage", clusters = c("task", "learner",
                                                           "mlr_settings",
                                                           "benchmark_plan",
                                                           "prediction"),
             targets_only = TRUE, show_output_files = FALSE) +
  ggpubr::theme_pubr()

### no learner and mlr_settings grouping
vis_drake_graph(config, group = "stage", clusters = c("task", "benchmark_plan",
                                                              "prediction"),
                targets_only = TRUE, show_output_files = FALSE,
                selfcontained = TRUE)
### no benchmark_plan grouping
vis_drake_graph(config, group = "stage", clusters = c("task", "data_plan",
                                                              "learner", "mlr_settings"),
                targets_only = TRUE, show_output_files = FALSE,
                selfcontained = TRUE)

#
#
# ### no benchmark_plan grouping
#
# vis_drake_graph(config, group = "stage", clusters = c("data_plan", "task", "learner",
#                                                       "mlr_settings"),
#                 targets_only = TRUE, show_output_files = FALSE,
#                 navigationButtons = FALSE, file = "drake.png")
vis_drake_graph(config, group = "stage", clusters = c("data", "task", "learner",
                                                      "mlr_settings",
                                                      "prediction"),
                targets_only = TRUE, show_output_files = FALSE)
sankey_drake_graph(config, group = "stage", clusters = c("data_plan", "task", "learner",
                                                                 "mlr_settings"),
                   targets_only = TRUE, show_output_files = FALSE)

drake_ggraph(config, group = "stage", clusters = c("data_plan", "task", "learner",
                                                           "mlr_settings"),
             targets_only = TRUE, show_output_files = FALSE) + ggpubr::theme_pubr()

# make(plan, keep_going = TRUE, console_log_file=stdout())

# make(plan, targets = "bm_glm", keep_going = TRUE, console_log_file=stdout())

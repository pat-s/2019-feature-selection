bm_aggregated_plan_buffer2 <- drake_plan(
  bm_aggregated_new_buffer2 = target(
    mergeBenchmarkResults(
      benchmark_no_models_new_buffer2
    )
  )
)

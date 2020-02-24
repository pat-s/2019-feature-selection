bm_aggregated_plan_buffer2 <- drake_plan(
  bm_aggregated_temp1_buffer2 = target(
    mergeBenchmarkResults(
      benchmark_no_models_new_buffer2
    )
  ),
  bm_aggregated_temp2_buffer2 = target(
    mergeBenchmarkResults(
      benchmark_no_models_new_penalized_buffer2
    )
  ),
  bm_aggregated_new_buffer2 = target(
    mergeBenchmarkResults(list(
      bm_aggregated_temp1_buffer2, bm_aggregated_temp2_buffer2
    ))
  )
)

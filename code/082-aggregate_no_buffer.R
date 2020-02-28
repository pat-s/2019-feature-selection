bm_aggregated_plan_no_buffer <- drake_plan(
  bm_aggregated_temp1_no_buffer = target(
    mergeBenchmarkResults(
      benchmark_no_models_new_no_buffer
    )
  ),
  bm_aggregated_temp2_no_buffer = target(
    mergeBenchmarkResults(
      benchmark_no_models_new_penalized_no_buffer
    )
  ),
  bm_aggregated_new_no_buffer = target(
    mergeBenchmarkResults(list(
      bm_aggregated_temp1_no_buffer, bm_aggregated_temp2_no_buffer
    ))
  )
)

bm_aggregated_plan <- drake_plan(
  bm_aggregated = target(
    mergeBenchmarkResults(
      benchmark_no_models
    )
  )
)

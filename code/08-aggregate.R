bm_aggregated_plan = drake_plan(

  bm_aggregated_new = target(
    mergeBenchmarkResults(benchmark_no_models_new,
                          benchmark_no_models_new_penalized)
  )
)


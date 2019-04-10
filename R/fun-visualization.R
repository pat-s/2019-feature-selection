#' @title Create spatial maps from the predicted data
#' @param prediction_raster Predicted raster layer from [write_defoliation_map], given in a list
#' @param model_name Algorithm name
#' @param benchmark_object mlr benchmark object containing performance
#' @param resampling String with the resampling description that should appear on the map
create_prediction_map = function(prediction_raster, model_name, benchmark_object = NULL,
                                 resampling = NULL) {

  if (!is.null(resampling)) {
    if (resampling == "spatial/spatial") {
      resampling_file = "sp_sp"
    } else if (resampling == "spatial/no tuning") {
      resampling_file = "sp_non"
    } else if (resampling == "spatial/non-spatial") {
      resampling_file = "sp_nsp"
    } else if (resampling == "non-spatial/non-spatial") {
      resampling_file = "nsp_nsp"
    } else if (resampling == "non-spatial/no tuning") {
      resampling_file = "nsp_non"
    }
  }

  out_maps = imap(prediction_raster, ~ {

    # score = getBMRAggrPerformances(benchmark_object, as.df = TRUE) %>%
    #   dplyr::filter(task.id == .y) %>%
    #   dplyr::select(brier.test.mean) %>%
    #   pull()

    ggplot() +
      annotation_map_tile(zoomin = -1, type = "cartolight") +
      layer_spatial(.x, aes(fill = stat(band1))) +
      #scale_alpha_continuous(na.value = 0) +
      scale_fill_viridis_c(na.value = NA, name = "Defoliation of trees (in %)", limits = c(35, 65)) +
      # spatial-aware automagic scale bar
      annotation_scale(location = "tl") +
      # spatial-aware automagic north arrow
      annotation_north_arrow(location = "br", which_north = "true") +
      theme_pubr(legend = "right")  +
      theme(legend.key.size = unit(2,"line"),
            plot.margin = margin(1.5, 0, 1, 0)) +
      labs(caption = glue("Algorithm: {toupper(model_name)},",
                          " Spatial resolution: 20 m"
                          ))

    # dir_create(c("data/prediction/maps/png", "data/prediction/maps/pdf"))
    #
    # ggsave(glue("data/prediction/maps/png/maps-prediction-{.y}-{model_name}-{resampling_file}.png"),
    #        height = 5.5, width = 8.5)
  })


  return(out_maps)
}

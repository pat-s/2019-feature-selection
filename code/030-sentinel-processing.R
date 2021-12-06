sentinel_processing_plan <- drake_plan(

  # load area of interest ------------------------------------------------------
  aoi = target(
    download_aoi("https://zenodo.org/record/3476044/files/aoi.gpkg")
  ),

  # get records from copernicus open access hub --------------------------------

  records_2017 = target(
    map(list(
      c("2017-04-19", "2017-04-20"),
      c("2017-06-18", "2017-06-19"),
      c("2017-08-17", "2017-08-18")
    ), ~
    get_records(aoi, date = .x, processing_level = "Level-2Ap")) %>%
      rbind_list()
  ),
  records_2018 = target(
    map(list(
      c("2018-04-19", "2018-04-20"),
      c("2018-06-23", "2018-06-24"),
      c("2018-07-23", "2018-07-24"),
      c("2018-08-12", "2018-08-13"),
      c("2018-08-27", "2018-08-28"),
      c("2018-09-01", "2018-09-02"),
      c("2018-09-11", "2018-09-12"),
      c("2018-09-26", "2018-09-27")
    ), ~
    get_records(aoi, date = .x, processing_level = "Level-2A")) %>%
      bind_rows()
  ),

  # download images from copernicus open access hub ----------------------------
  images_zip = target(
    map(list(records_2017, records_2018), ~ download_images(.x))
  ),

  # unzip images ---------------------------------------------------------------

  # unzip_images(): parallelized
  images_unzip = target(
    map(images_zip, c("2017", "2018"), ~ unzip_images(.x, pattern = .y))
  ),

  # stack bands for each image -------------------------------------------------

  # One date takes around 25 GB RAM -> max 4 at a time
  # stack_bands(): max 4 cores, 100 GB RAM per job
  images_stack = target(
    map2(list(records_2017, records_2018), images_unzip, ~ stack_bands(.x, .y))
  ),

  # copy cloud covers from unziped files ------------------------------
  # 2 cores, ??? mem
  cloud_stack = target(
    future_map2(list(records_2017, records_2018), images_unzip, ~ copy_cloud(.x, .y))
  ),

  # mosaic cloud covers of same date ------------------------------
  cloud_mosaic = target(
    map(list(records_2017, records_2018), ~ mosaic_clouds(.x))
  ),

  # mosaic images of the same date ------------------------------
  # 5 GB mem
  mosaic = target(
    map(list(records_2017, records_2018), ~ mosaic_images(.x))
  ),

  # mask mosaics ------------------------------
  mosaic_masked = target(
    map2(mosaic, cloud_mosaic, ~ mask_mosaic(.x, .y, aoi, forest_mask))
  ),

  # calculate vegetation indices ------------------------------
  mosaic_vi = target(
    map(mosaic_masked, ~ calculate_vi(.x))
  ),

  # create raster objects of vegetation indices ------------------------------
  ras_veg_inds = target(
    lapply(mosaic_vi, mask_vi)
  ),

  # create sf objects of vegetation indices ------------------------------
  sf_veg_inds = target(
    lapply(ras_veg_inds, ras_to_sf)
  ),

  # get coordinates from sf object for vegetation indices ------------------------------
  coordinates = target(
    lapply(sf_veg_inds, get_coordinates)
  ),

  # create prediction data ------------------------------
  prediction_df = target(
    lapply(sf_veg_inds, create_prediction_df, model = train_xgboost_project)
  ),

  # predict defoliation ------------------------------
  defoliation_df = target(
    future_map2(prediction_df, coordinates, ~
    predict_defoliation(.x, model = train_xgboost_project, .y))
  ),

  # write defoliation raster ------------------------------
  defoliation_raster = target(
    future_map2(defoliation_df, c("2017", "2018"), ~
    prediction_raster(.x, .y))
  ),

  # scale predicted defoliation -------------------------------------------------------
  defoliation_df_relative = target(
    lapply(defoliation_df, scale_defoliation)
  ),

  # write defoliation raster ------------------------------
  defoliation_raster_relative = target(
    future_map2(defoliation_df_relative, c("2017", "2018"), ~
    prediction_raster(.x, .y, relative = TRUE))
  )
)

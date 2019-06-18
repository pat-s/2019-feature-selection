# load area of interest ------------------------------
aoi <- st_read("/home/marc/basque/01_data/aoi.shp", quiet = TRUE)

# get records from copernicus open access hub ------------------------------

records_2017 <- map(list(
  c("2017-04-19", "2017-04-20"),
  c("2017-06-18", "2017-06-19"),
  c("2017-08-17", "2017-08-18")
), ~
  get_records(aoi, date = .x, processing_level = "Level-2Ap")) %>%
  rbind_list()


records_2018 <- map(list(
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
  rbind_list()

# download images from copernicus open access hub ------------------------------
images_zip <- map(list(records_2017, records_2018), ~ download_images(.x))

# unzip images ------------------------------
images_unzip <- map(images_zip, c("2017", "2018"), ~ unzip_images(.x, pattern = .y))

# stack bands for each image ------------------------------
# One date takes around 25 GB RAM -> max 4 at a time
images_stack <- map2(list(records_2017, records_2018), images_unzip, ~
                       stack_bands(.x, .y))

# copy cloud covers from unziped files ------------------------------
cloud_stack <- future_map2(list(records_2017, records_2018), images_unzip, ~
                             copy_cloud(.x, .y))

# mosaic cloud covers of same date ------------------------------
cloud_mosaic <- future_map2(list(records_2017, records_2018), cloud_stack, ~
                              mosaic_clouds(.x, .y))

# mosaic images of the same date ------------------------------
mosaic <- future_map2(list(records_2017, records_2018), images_stack, ~
                        mosaic_images(.x, .y))

# mask mosaics ------------------------------
mosaic_masked <- future_map2(mosaic, cloud_mosaic, ~
                               mask_mosaic(.x, .y, aoi, forest_mask))

# calculate vegetation indices ------------------------------
mosaic_vi <- future_map(mosaic_masked, ~
                          calculate_vi(.x))

# create raster objects of vegetation indices ------------------------------
ras_veg_inds <- future_map(mosaic_vi, ~
                             mask_vi(.x))

# create sf objects of vegetation indices ------------------------------
sf_veg_inds <- map(ras_veg_inds, ~
                     ras_to_sf(.x))

# get ooordinates from sf object for vegetation indices ------------------------------
coordinates <- future_map(sf_veg_inds, ~
                            get_coordinates(.x))

# create prediction data ------------------------------
prediction_df <- future_map(sf_veg_inds, ~
                              create_prediction_df(.x, model = train_xgboost))

# predict defoliation ------------------------------
defoliation_df <- future_map2(prediction_df, coordinates, ~
                                predict_defoliation(.x, model = train_xgboost, .y))

# write defoliation raster ------------------------------
defoliation_raster <- future_map2(defoliation_df, c("2017", "2018"), ~
                                   prediction_raster(.x, .y))

# scale predicted defoliation -------------------------------------------------------
defoliation_df_relative = future_map(defoliation_df, ~
                                     scale_defoliation(.x))

# write defoliation raster ------------------------------
defoliation_raster_relative <- future_map2(defoliation_df_relative, c("2017", "2018"), ~
                                            prediction_raster(.x, .y, relative = TRUE))

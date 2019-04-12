# load area of interest ------------------------------
aoi = st_read("/home/marc/basque/01_data/aoi.shp", quiet = TRUE)

# get records from copernicus open access hub ------------------------------

records_2017 = map(list(c("2017-04-19", "2017-04-20"), 
                        c("2017-06-18", "2017-06-19"),
                        c("2017-08-17", "2017-08-18")), ~
                     get_records(aoi, date = .x, processing_level = "Level-2Ap")) %>% 
  rbind_list()
  
  
records_2018 = map(list(c("2018-04-19", "2018-04-20"), 
                        c("2018-06-23", "2018-06-24"),
                        c("2018-07-23", "2018-07-24"), 
                        c("2018-08-12", "2018-08-13"), 
                        c("2018-08-27", "2018-08-28"), 
                        c("2018-09-01", "2018-09-02"), 
                        c("2018-09-11", "2018-09-12"),
                        c("2018-09-26", "2018-09-27")), ~
                     get_records(aoi, date = .x, processing_level = "Level-2A"))  %>% 
  rbind_list()

# download images from copernicus open access hub ------------------------------
images_zip = map(list(records_2017, records_2018), ~ download_images(.x))

# unzip images ------------------------------
images_unzip = map(images_zip, ~ unzip_images(.x))

# stack bands for each image ------------------------------
# One date takes around 25 GB RAM -> max 4 at a time
images_stack = future_map2(list(records_2017, records_2018), images_unzip, ~
                            stack_bands(.x, .y))

# copy cloud covers from unziped files ------------------------------
cloud_stack = future_map2(list(records_2017, records_2018), images_unzip, ~
                            copy_cloud(.x, .y))

# mosaic images of the same date ------------------------------
mosaic = future_map2(list(records_2017, records_2018), images_stack, ~
                       mosaic_images(.x, .y))

# mask mosaics ------------------------------------------------------------
mosaic_masked = mask_mosaic(mosaic, cloud_mosaic, aoi)

# calculate vegetation indices --------------------------------------------
mosaic_vi = calculate_vi(mosaic_masked)
ras_veg_inds = mask_vi(image_vi)
sf_veg_inds = ras_to_sf(ras_veg_inds)
coordinates = get_coordinates(sf_veg_inds)
prediction_df = get_prediction_df(sf_veg_inds, model)
defolation_df = predict_defolation(prediction_df, model, coordinates)
defoloation_map = write_defoliation_map(defolation_df)

# mosaic cloud covers of same date
# ------------------------------
cloud_mosaic = mosaic_clouds(records, cloud_stack)

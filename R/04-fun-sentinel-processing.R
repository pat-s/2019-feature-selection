#' @title get_records
#' @description Splits data into feature sets.
#'
#' @param aoi (`sf`)\cr Area of interest to download images for
#' @param date (`character`)\cr Date range for which to get the records for
#' @param processing_level (`character`)\cr  Which Sentinel processing level to use
#' @return `list` of available records
#' @export
get_records <- function(aoi, date, processing_level) {

  # Set AOI to extent of basque country
  aoi %>%
    st_bbox() %>%
    st_as_sfc() %>%
    set_aoi()

  # Connect to Copernicus Open Access Hub
  login_CopHub("be-marc", password = "ISQiwQDl")

  # Get records from Sentinel-2 in time range
  records <- getSentinel_query(date,
    platform = "Sentinel-2"
  )

  records %<>%
    filter(processinglevel == processing_level) %>%
    arrange(beginposition)

  return(records)
}

#' @title download_images
#' @description Downloads the listed Sentinel images from Copernicus Hub.
#'
#' @param records (`character`)\cr Names of images to download.
#' @return `list` of available records
#' @export
download_images <- function(records) {
  # Set working directory for getSpatial package
  set_archive("data/sentinel/image_zip")

  # Connect to Copernicus Open Access Hub
  login_CopHub("be-marc", password = "ISQiwQDl")

  # Download images
  sentinel_dataset <- getSentinel_data(records, force = FALSE)
}

#' @title download_images
#' @description Downloads the listed Sentinel images from Copernicus Hub.
#'
#' @param data (`list`)\cr File names of images to unzip.
#' @param pattern (`charachter`)\cr Regex pattern (year)
#' @return `list` of unzipped files
#' @export
unzip_images <- function(data, pattern) {
  data %>%
    future_walk(~ unzip(.x,
      exdir = "data/sentinel/image_unzip/",
      overwrite = FALSE
    ))

  return(list.files("data/sentinel/image_unzip/",
    full.names = TRUE,
    pattern = pattern
  ))
}

#' @title stack_bands
#' @description Stacks the bands of a specific date
#'
#' @param records (`list`)\cr `data.frame` of Sentinel-2 records from [get_records].
#' @param image_unzip File names of unzipped images.
#' @return `list` of stacked raster files (Bricks)
#' @export
stack_bands <- function(records, image_unzip) {

  # Each thread ~ 25 GB ram

  # Get record filenames
  records <- records$filename

  future_walk(records, ~ {
    scenes_10 <-
      list.files(paste0("data/sentinel/image_unzip/", .x),
        recursive = TRUE,
        pattern = ".*_B08_10m.jp2",
        full.names = TRUE
      ) %>%
      map(~ raster(.)) %>%
      map(~ raster::aggregate(., fact = 2, fun = mean)) %>%
      stack()

    scenes_20 <-
      list.files(paste0("data/sentinel/image_unzip/", .x),
        recursive = TRUE,
        pattern = ".*_B(02|03|04|05|06|07|8A|11|12)_20m.jp2",
        full.names = TRUE
      ) %>%
      map(~ raster(.)) %>%
      stack()

    scenes_60 <-
      scenes_10 <-
      list.files(paste0("data/sentinel/image_unzip/", .x),
        recursive = TRUE,
        pattern = ".*_B08_10m.jp2",
        full.names = TRUE
      ) %>%
      map(~ raster(.)) %>%
      map(~ raster::aggregate(., fact = 2, fun = mean)) %>%
      stack()

    scenes_20 <-
      list.files(paste0("data/sentinel/image_unzip/", .x),
        recursive = TRUE,
        pattern = ".*_B(02|03|04|05|06|07|8A|11|12)_20m.jp2",
        full.names = TRUE
      ) %>%
      map(~ raster(.)) %>%
      stack()

    scenes_60 <-
      list.files(paste0("data/sentinel/image_unzip/", .x),
        recursive = TRUE,
        pattern = ".*_B(01|09)_60m.jp2",
        full.names = TRUE
      ) %>%
      map(~ raster(.)) %>%
      map(~ raster::disaggregate(., fact = 3)) %>%
      stack()

    ras_stack <-
      stack(
        scenes_60[[1]],
        scenes_20[[1]],
        scenes_20[[2]],
        scenes_20[[3]],
        scenes_20[[4]],
        scenes_20[[5]],
        scenes_20[[6]],
        scenes_10[[1]],
        scenes_20[[7]],
        scenes_60[[2]],
        scenes_20[[8]],
        scenes_20[[9]]
      )

    writeRaster(ras_stack, file_out(paste0(
      "data/sentinel/image_stack/",
      str_remove(.x, ".SAFE"), ".tif"
    )),
    overwrite = TRUE
    )
  })

  # Return file names for drake
  list.files("data/sentinel/image_stack/",
    pattern = "\\.tif",
    full.names = TRUE
  )
}

#' @title copy_cloud
#' @description Copies the cloud mask of each image
#'
#' @param records (`list`)\cr `data.frame` of Sentinel-2 records from [get_records].
#' @param image_unzip File names of unzipped images.
#' @return `list` of stacked raster files (Bricks)
#' @export
copy_cloud <- function(records, image_unzip) {

  # Get cloud mask filenames
  file_cloud_mask <-
    records$filename %>%
    map(~ list.files(paste0("data/sentinel/image_unzip/", ., "/GRANULE"),
      recursive = TRUE,
      pattern = "MSK_CLOUDS_B00.gml",
      full.names = TRUE
    ))

  # Copy and rename
  list(file_cloud_mask, records$filename) %>%
    future_pmap(~ file.copy(.x, paste0(
      "data/sentinel/image_stack/",
      str_remove(.y, ".SAFE"),
      "_cloud_mask.gml"
    )))

  # Return for drake
  list.files("data/sentinel/image_stack/", pattern = "\\.gml", full.names = TRUE)
}

#' @title mosaic_images
#' @description Mosaics the images of a specific date
#'
#' @param records (`list`)\cr `data.frame` of Sentinel-2 records from [get_records].
#' @param image_stack Stacked images from [stack_bands].
#' @return `list` of mosaiced raster files (Bricks)
#' @export
mosaic_images <- function(records, image_stack) {

  # Get stack filenames
  file_stack <-
    unique(records$beginposition) %>%
    map(~ filter(records, beginposition == .)) %>%
    map(~ pull(., filename)) %>%
    map(~ str_remove(., ".SAFE")) %>%
    map_depth(2, ~ str_glue("data/sentinel/image_stack/", ., ".tif"))

  # Set mosaic filename
  file_mosaic <-
    records$filename %>%
    str_sub(1, 41) %>%
    unique() %>%
    map(~ str_glue("data/sentinel/image_mosaic/", ., ".tif"))

  # Build mosaic
  list(file_stack, file_mosaic) %>%
    future_pmap(~ mosaic_rasters(as.character(.x), as.character(.y),
      verbose = TRUE
    ))

  return(file_mosaic)
}

#' @title mosaic_clouds
#' @description Mosaics the cloud cover of a specific date
#'
#' @param records (`list`)\cr `data.frame` of Sentinel-2 records from [get_records].
#' @param cloud_stack cloud stack created by [copy_cloud].
#' @return `list` of stacked raster files (Bricks)
#' @export
mosaic_clouds <- function(records, cloud_stack) {

  # Create dummy cloud mask for mosaics without clouds
  vec_dummy_cloud_mask <-
    st_polygon(list(cbind(c(0, 1, 1, 0, 0), c(0, 0, 1, 1, 0)))) %>%
    st_sfc() %>%
    st_sf(tibble(name = "Dummy")) %>%
    st_set_crs("+proj=utm +zone=30 +datum=WGS84 +units=m +no_defs")

  # Build cloud mask mosaic
  vec_mosaic_cloud_mask <-
    unique(records$beginposition) %>%
    map(~ filter(records, beginposition == .)) %>%
    map(~ pull(., filename)) %>%
    map(~ str_remove(., ".SAFE")) %>%
    map_depth(2, ~ str_glue("data/sentinel/image_stack/", ., "_cloud_mask.gpkg")) %>%
    map_depth(2, possibly(~ st_read(., quiet = TRUE), NA)) %>%
    map(~ purrr::discard(., function(x) all(is.na(x)))) %>%
    map(~ do.call(rbind, .)) %>%
    map_if(~ is.null(.), ~vec_dummy_cloud_mask) %>%
    map(possibly(~ st_set_crs(., "+proj=utm +zone=30 +datum=WGS84 +units=m +no_defs"), NA))

  # Set cloud mask filename
  file_mosaic_cloud_mask <-
    records$filename %>%
    str_sub(1, 41) %>%
    unique() %>%
    map(~ str_glue("data/sentinel/image_mosaic/", ., "_cloud_mask.gpkg"))

  # Write cloud mask mosaic
  list(vec_mosaic_cloud_mask, file_mosaic_cloud_mask) %>%
    pwalk(~ st_write(.x, .y, layer_options = "OVERWRITE=true"))

  # Return for drake
  return(file_mosaic_cloud_mask)
}

#' @title mask_mosaic
#' @description Mask the mosaic
#'
#' @param image_mosaic (`list`)\cr File names of mosaiced images.
#' @param cloud_mosaic `list`)\cr File names of mosaiced cloud images.
#' @param aoi Area to be masked
#' @param forest_mask Forest/Non-forest mask
#' @return aoi of stacked raster files (Bricks)
#' @export
mask_mosaic <- function(image_mosaic, cloud_mosaic, aoi, forest_mask) {

  # Read mosaic
  ras_mosaic_stack <-
    image_mosaic %>%
    map(~ stack(.))

  # Read cloud mask
  vec_mosaic_cloud_mask <-
    cloud_mosaic %>%
    map(~ st_read(., quiet = TRUE)) %>%
    map(~ st_set_crs(., "+proj=utm +zone=30 +datum=WGS84 +units=m +noread_defs"))

  # Mask cloud with aoi
  vec_mosaic_cloud_mask %<>%
    future_map(~ st_crop(., aoi))

  vec_mosaic_cloud_mask %<>%
    map(function(.x) {
      st_set_agr(.x, "constant")
    })

  # Mask mosaic with aoi
  ras_mask <-
    ras_mosaic_stack %>%
    map(~ raster::crop(., aoi)) %>%
    map(~ raster::mask(., aoi))

  # Mask mosaic with clouds and forest
  ras_mask <-
    list(ras_mask, vec_mosaic_cloud_mask) %>%
    pmap(~ {
      if (nrow(.y) > 0) {
        raster::mask(.x, as(.y, "Spatial"), inverse = TRUE)
      } else {
        .x
      }
    }) %>%
    map(~ raster::mask(., as(st_zm(forest_mask), "Spatial")))

  # Write to disk
  list(ras_mask, image_mosaic) %>%
    pmap(~ writeRaster(.x, paste0("data/sentinel/image_mask/", basename(.y)),
      overwrite = TRUE
    ))

  # Return for drake
  list.files("data/sentinel/image_mask", full.names = TRUE)
}

#' @title calculate_vi
#' @description Calculates the following vegetation indices from the Sentinel data:
#'  - EVI
#'  - GDVI2
#'  - GDVI3
#'  - GDVI4
#'  - MNDVI
#'  - MSR
#'  - D1
#'
#' @param image (`brick`)\cr File name of raster brick/stack.
#' @return calculated VIs (file name)
#' @export
calculate_vi <- function(image) {
  # EVI
  image %>%
    map(~ stack(.)) %>%
    map(~ 2.5 * (.[[8]] / 10000 - .[[4]] / 10000) / ((.[[8]] / 10000 + 6 * .[[4]] / 10000 - 7.5 * .[[2]] / 10000) + 1)) %>%
    stack() %>%
    calc(fun = function(x) mean(x, na.rm = TRUE)) %>%
    writeRaster(paste0("data/sentinel/image_vi/EVI.tif"), overwrite = TRUE)

  # GDVI 2
  image %>%
    map(~ stack(.)) %>%
    map(~ ((.[[8]] / 10000)^2 - (.[[4]] / 10000)^2) / ((.[[8]] / 10000)^2 + (.[[4]] / 10000)^2)) %>%
    stack() %>%
    calc(fun = function(x) mean(x, na.rm = TRUE)) %>%
    writeRaster(paste0("data/sentinel/image_vi/GDVI_2.tif"), overwrite = TRUE)

  # GDVI 3
  image %>%
    map(~ stack(.)) %>%
    map(~ ((.[[8]] / 10000)^3 - (.[[4]] / 10000)^3) / ((.[[8]] / 10000)^3 + (.[[4]] / 10000)^3)) %>%
    stack() %>%
    calc(fun = function(x) mean(x, na.rm = TRUE)) %>%
    writeRaster(paste0("data/sentinel/image_vi/GDVI_3.tif"), overwrite = TRUE)

  # GDVI 4
  image %>%
    map(~ stack(.)) %>%
    map(~ ((.[[8]] / 10000)^4 - (.[[4]] / 10000)^4) / ((.[[8]] / 10000)^4 + (.[[4]] / 10000)^4)) %>%
    stack() %>%
    calc(fun = function(x) mean(x, na.rm = TRUE)) %>%
    writeRaster(paste0("data/sentinel/image_vi/GDVI_4.tif"), overwrite = TRUE)

  # MNDVI
  image %>%
    map(~ stack(.)) %>%
    map(~ (.[[8]] / 10000 - .[[4]] / 10000) / (.[[8]] / 10000 + .[[4]] / 10000 - 2 * .[[1]] / 10000)) %>%
    stack() %>%
    calc(fun = function(x) mean(x, na.rm = TRUE)) %>%
    writeRaster(paste0("data/sentinel/image_vi/mNDVI.tif"), overwrite = TRUE)

  # MSR
  image %>%
    map(~ stack(.)) %>%
    map(~ (.[[8]] / 10000 - .[[1]] / 10000) / (.[[4]] / 10000 - .[[1]] / 10000)) %>%
    stack() %>%
    calc(fun = function(x) mean(x, na.rm = TRUE)) %>%
    writeRaster(paste0("data/sentinel/image_vi/mSR.tif"), overwrite = TRUE)

  # D1
  image %>%
    map(~ stack(.)) %>%
    map(~ (.[[6]] / 10000) / (.[[5]] / 10000)) %>%
    stack() %>%
    calc(fun = function(x) mean(x, na.rm = TRUE)) %>%
    writeRaster(paste0("data/sentinel/image_vi/D1.tif"), overwrite = TRUE)

  list.files("data/sentinel/image_vi/", full.names = TRUE)
}

#' @title mask_vi
#' @description Masks the VIs
#'
#' @param image_vi (`character`)\cr File name of raster brick/stack.
#' @return masked VIs (`brick`)
#' @export
mask_vi <- function(image_vi) {

  # Get raster
  veg_inds <-
    image_vi %>%
    map(~ raster(.))

  # Mask with each other
  for (ind in veg_inds) {
    veg_inds %<>%
      map(~ mask(., ind))
  }

  # Get names
  ind_names <-
    image_vi %>%
    map_chr(~ tools::file_path_sans_ext(basename(.)))

  # Return for drake
  veg_inds %>%
    set_names(ind_names)
}

#' @title ras_to_sf
#' @description Converts masked vegetation indices to `sf` objects
#'
#' @param data (`brick`)\cr Masked vegetation indices.
#' @return masked VIs (`brick`)
#' @export
ras_to_sf <- function(data) {
  data %<>%
    map(~ as(., "SpatialPixelsDataFrame")) %>%
    map(~ st_as_sf(.))
}

#' @title get_coordinates
#' @description Extract coordinates from `sf` object
#'
#' @param data (`sf`)\cr Masked vegetation indices.
#' @return masked VIs (`brick`)
#' @export
get_coordinates <- function(data) {

  # coordinates are the same for both years, only taking first year
  coords <- data[[1]] %>%
    st_coordinates() %>%
    as.data.frame() %>%
    rename(x = X) %>%
    rename(y = Y)

  return(coords)
}

#' @title create_prediction_df
#' @description Create the prediction data. Strips variable names and orders them.
#'
#' @param data (`sf`)\cr Masked vegetation indices.
#' @param model Used for ordering the variables names (xgboost)
#' @return (`data.frame`)
#' @export
create_prediction_df <- function(data, model) {
  ind_names <-
    names(sf_veg_inds) %>%
    map_chr(~ paste0("bf2_", .))

  prediction_df <-
    sf_veg_inds %>%
    map_dfc(~ st_set_geometry(., NULL)) %>%
    set_names(ind_names)

  # correct column order of features: https://github.com/dmlc/xgboost/issues/1809
  prediction_df <- prediction_df[, model$learner.model$feature_names]

  return(prediction_df)
}

#' @title predict_defoliation
#' @description Predict defoliation for the Basque Country
#'
#' @param data (`data.frame`)\cr Prediction data
#' @param model Used for ordering the variables names (xgboost)
#' @param coordinates Coordinates of the predicted data
#' @return (`data.frame`)
#' @export
predict_defoliation <- function(data, model, coordinates) {
  pred <- predict(model$learner.model, newdata = as.matrix(prediction_df))
  return(tibble(defoliation = pred, x = coordinates$x, y = coordinates$y))
}

#' @title prediction_raster
#' @description Transforms the predictions and their cooridnates into a GeoTIFF
#'
#' @param data (`data.frame`)\cr Predicted data
#' @return (`brick`)
#' @export
prediction_raster <- function(data) {
  all_spdf <- SpatialPixelsDataFrame(points = data[, c("x", "y")],
                                     data = as.data.frame(data[, "defoliation"]),
                                     proj4string = CRS("+proj=utm +zone=30 +datum=WGS84 +units=m +no_defs"))

  raster(all_spdf) %>%
    writeRaster("data/sentinel/image_defoliation/defoliation.tif",
                overwrite = TRUE)

  # Return for drake
  return(raster(all_spdf))
}

#' @title write_defoliation_map
#' @description Predict defoliation for the Basque Country
#'
#' @param data (`data.frame`)\cr Predictions including coordinates
#' @param algorithm (`character`)\cr Name of the algoritm
#' @return (`character`)
#' @export
create_defoliation_map <- function(data, algorithm) {

  all_spdf <- SpatialPixelsDataFrame(
    points = defoliation__df[, c("x", "y")],
    data = as.data.frame(defoliation__df[, "defoliation"]),
    proj4string = CRS("+proj=utm +zone=30 +datum=WGS84 +units=m +no_defs")
  )

  raster(all_spdf) %>%
    writeRaster(glue("data/sentinel/image_defoliation/{filename}.tif"),
      overwrite = TRUE
    )

  plot = ggplot() +
    annotation_map_tile(zoomin = -1, type = "cartolight") +
    layer_spatial(all_spdf, aes(fill = stat(band1))) +
    scale_fill_viridis_c(na.value = NA, name = "Defoliation of trees [%]",
                         limits = c(35, 65)) +
    # spatial-aware automagic scale bar
    annotation_scale(location = "tl") +
    # spatial-aware automagic north arrow
    annotation_north_arrow(location = "br", which_north = "true") +
    theme_pubr(legend = "right")  +
    theme(legend.key.size = unit(2,"line"),
          plot.margin = margin(1.5, 0, 1, 0)) +
    labs(caption = glue("Algorithm: {algorithm}",
                        " Spatial resolution: 20 m"))

  # Return for drake
  return(plot)
}

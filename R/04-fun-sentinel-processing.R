#' @title get_records
#' @description Splits data into feature sets.
#' @importFrom getSpatialData set_aoi getSentinel_query login_CopHub set_archive
#' @importFrom dplyr filter arrange
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

    writeRaster(ras_stack, paste0(
      "data/sentinel/image_stack/",
      str_remove(.x, ".SAFE"), ".tif"
    ),
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
mosaic_images <- function(records) {

  # Get stack filenames
  file_stack <-
    unique(records$beginposition) %>%
    map(~ filter(records, beginposition == .)) %>%
    map(~ dplyr::pull(., filename)) %>%
    map(~ str_remove(., ".SAFE")) %>%
    map_depth(2, ~ str_glue("data/sentinel/image_stack/", ., ".tif")) %>%
    map(~ flatten_chr(.x))

  # Set mosaic filename
  file_mosaic <-
    records$filename %>%
    str_sub(1, 41) %>%
    unique() %>%
    map_chr(~ str_glue("data/sentinel/image_mosaic/", ., ".tif"))

  cat("Building mosaic.")

  # Build mosaic
  # 18 GB per mosaic 3 moscaics in total -> 20 GB mem in parallel
  future_map2(
    file_stack, file_mosaic,
    ~ gdalUtils::mosaic_rasters(.x, .y, verbose = TRUE)
  )

  return(file_mosaic)
}

#' @title mosaic_clouds
#' @description Mosaics the cloud cover of a specific date
#'
#' @param records (`list`)\cr `data.frame` of Sentinel-2 records from [get_records].
#' @param cloud_stack cloud stack created by [copy_cloud].
#' @return `list` of stacked raster files (Bricks)
#' @export
mosaic_clouds <- function(records) {

  # Create dummy cloud mask for mosaics without clouds
  vec_dummy_cloud_mask <-
    st_polygon(list(cbind(c(0, 1, 1, 0, 0), c(0, 0, 1, 1, 0)))) %>%
    st_sfc() %>%
    st_sf(tibble(name = "Dummy")) %>%
    st_set_crs("+proj=utm +zone=30 +datum=WGS84 +units=m +no_defs")

  # Build cloud mask mosaic
  vec_mosaic_cloud_mask <-
    unique(records$beginposition) %>%
    map(~ dplyr::filter(records, beginposition == .)) %>%
    map(~ dplyr::pull(., filename)) %>%
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
#' @return (`list`) File names of masked mosaics for each year
#' @export
mask_mosaic <- function(image_mosaic,
                        cloud_mosaic,
                        aoi,
                        forest_mask) {
  aoi <- sf::as_Spatial(aoi)

  # Read mosaic
  ras_mosaic_stack <-
    image_mosaic %>%
    lapply(FUN = raster::stack)

  # Read cloud mask
  vec_mosaic_cloud_mask <-
    cloud_mosaic %>%
    lapply(FUN = sf::st_read, quiet = TRUE) %>%
    lapply(
      FUN = sf::st_set_crs,
      value = "+proj=utm +zone=30 +datum=WGS84 +units=m +noread_defs"
    )

  # Mask cloud with aoi
  vec_mosaic_cloud_mask %<>%
    lapply(FUN = sf::st_crop, y = aoi)

  vec_mosaic_cloud_mask %<>%
    lapply(FUN = sf::st_set_agr, value = "constant")

  cli::cli_process_start("Mask and crop mosaic with AOI.")

  # Mask mosaic with aoi
  ras_mask <-
    ras_mosaic_stack %>%
    future.apply::future_lapply(FUN = raster::crop, y = aoi) %>%
    future.apply::future_lapply(FUN = raster::mask, mask = aoi)

  cli::cli_process_done()

  cli::cli_process_start("Mask mosaic with clouds and forest.")

  # Mask mosaic with clouds and forest
  ras_mask <-
    # list(ras_mask, vec_mosaic_cloud_mask) %>%
    future.apply::future_Map(ras_mask, vec_mosaic_cloud_mask,
      f = function(x, y) {
        if (nrow(y) > 0) {
          raster::mask(x, as(y, "Spatial"), inverse = TRUE)
        } else {
          x
        }
      }
    ) %>%
    future.apply::future_Map(
      f = raster::mask,
      MoreArgs = list(mask = sf::as_Spatial(sf::st_zm(forest_mask)))
    )

  cli::cli_process_done()

  cli::cli_process_start("Write to disk.")

  # Write to disk
  future.apply::future_Map(ras_mask, image_mosaic, f = function(x, y) {
    raster::writeRaster(x,
      filename =
        paste0("data/sentinel/image_mask/", basename(y)),
      overwrite = TRUE
    )
  })
  cli::cli_process_done()

  return(image_mosaic %>%
    lapply(FUN = function(.x) {
      stringr::str_glue(
        "data/sentinel/image_mask/",
        basename(.x)
      )
    }))
}

#' @title mask_vi
#' @description Masks the VIs
#'
#' @param image_vi (`character`)\cr File name of raster brick/stack.
#' @return masked VIs (`brick`)
#' @export
mask_vi <- function(image_vi) {

  # Get raster
  veg_inds <- image_vi %>%
    as.list() %>%
    flatten() %>%
    lapply(FUN = raster::raster)

  # Mask with each other
  for (ind in veg_inds) {
    veg_inds %<>%
      map(~ raster::mask(., ind))
  }

  return(veg_inds)

  # browser()
  # # Get names
  # ind_names <-
  #   image_vi %>%
  #   as.list() %>% flatten() %>%
  #   map_chr(~ tools::file_path_sans_ext(basename(.)))
  #
  # # Return for drake
  # veg_inds %>%
  #   set_names(ind_names)
}

#' @title calculate_vi
#' @description Calculates vegetation indices from the Sentinel data
#'
#' @details
#' Indices:
#'  - EVI
#'  - GDVI2
#'  - GDVI3
#'  - GDVI4
#'  - MNDVI
#'  - MSR
#'  - D1
#'
#'  The following steps are performed:
#'  1. Take the mosaic and read all raster files (different dates)
#'  2. Calculate the index for all files
#'  3. Stack the single rasters
#'  4. Take the mean from all raster files
#'  5. Write to disk
#'
#' @param image (`brick`)\cr File name of raster brick/stack.
#' @return calculated VIs (file name)
#' @export
calculate_vi <- function(image) {
  if (grepl("2017", image[1])) {
    year <- "2017"
  } else if (grepl("2018", image[1])) {
    year <- "2018"
  }

  cat(glue::glue("Starting EVI {year}"))

  # EVI
  image_stack <- lapply(image, raster::stack)
  image_stack <- future.apply::future_lapply(image_stack,
    FUN = raster::calc,
    fun = function(x) 2.5 * (x[[8]] / 10000 - x[[4]] / 10000) / ((x[[8]] / 10000 + 6 * x[[4]] / 10000 - 7.5 * x[[2]] / 10000) + 1)
  )
  image_stack <- raster::stack(image_stack)
  image_stack <- raster::calc(image_stack, fun = function(x) mean(x, na.rm = TRUE))
  raster::writeRaster(image_stack, glue::glue("data/sentinel/image_vi/EVI-{year}.tif"),
    overwrite = TRUE
  )
  # image %>%
  #   map(~ stack(.)) %>%
  #   future_map(~ 2.5 * (.[[8]] / 10000 - .[[4]] / 10000) / ((.[[8]] / 10000 + 6 * .[[4]] / 10000 - 7.5 * .[[2]] / 10000) + 1)) %>%
  #   stack() %>%
  #   calc(fun = function(x) mean(x, na.rm = TRUE)) %>%
  #   writeRaster(glue("data/sentinel/image_vi/EVI-{year}.tif"), overwrite = TRUE)

  cat(glue::glue("Starting GDVI 2 {year}"))

  # GDVI 2
  image %>%
    lapply(raster::stack) %>%
    future.apply::future_lapply(
      FUN = raster::calc,
      fun = function(x) ((x[[8]] / 10000)^2 - (x[[4]] / 10000)^2) / ((x[[8]] / 10000)^2 + (x[[4]] / 10000)^2)
    ) %>%
    raster::stack() %>%
    raster::calc(fun = function(x) mean(x, na.rm = TRUE)) %>%
    raster::writeRaster(glue::glue("data/sentinel/image_vi/GDVI_2-{year}.tif"),
      overwrite = TRUE
    )

  cat(glue::glue("Starting GDVI 3 {year}"))
  # GDVI 3
  image %>%
    lapply(raster::stack) %>%
    future.apply::future_lapply(
      FUN = raster::calc,
      fun = function(x) ((x[[8]] / 10000)^3 - (x[[4]] / 10000)^3) / ((x[[8]] / 10000)^3 + (x[[4]] / 10000)^3)
    ) %>%
    raster::stack() %>%
    raster::calc(fun = function(x) mean(x, na.rm = TRUE)) %>%
    raster::writeRaster(glue::glue("data/sentinel/image_vi/GDVI_3-{year}.tif"),
      overwrite = TRUE
    )

  cat(glue("Starting GDVI 4 {year}"))
  # GDVI 4
  image %>%
    lapply(raster::stack) %>%
    future.apply::future_lapply(
      FUN = raster::calc,
      fun = function(x) ((x[[8]] / 10000)^4 - (x[[4]] / 10000)^4) / ((x[[8]] / 10000)^4 + (x[[4]] / 10000)^4)
    ) %>%
    raster::stack() %>%
    raster::calc(fun = function(x) mean(x, na.rm = TRUE)) %>%
    raster::writeRaster(glue::glue("data/sentinel/image_vi/GDVI_4-{year}.tif"),
      overwrite = TRUE
    )

  cat("Starting mNDVI")
  # mNDVI
  image %>%
    lapply(raster::stack) %>%
    future.apply::future_lapply(
      FUN = raster::calc,
      fun = function(x) (x[[8]] / 10000 - x[[4]] / 10000) / (x[[8]] / 10000 + x[[4]] / 10000 - 2 * x[[1]] / 10000)
    ) %>%
    raster::stack() %>%
    raster::calc(fun = function(x) mean(x, na.rm = TRUE)) %>%
    raster::writeRaster(glue::glue("data/sentinel/image_vi/mNDVI-{year}.tif"),
      overwrite = TRUE
    )

  cat(glue("Starting mSR{year}"))
  # mSR
  image %>%
    lapply(raster::stack) %>%
    future.apply::future_lapply(
      FUN = raster::calc,
      fun = function(x) (x[[8]] / 10000 - x[[1]] / 10000) / (x[[4]] / 10000 - x[[1]] / 10000)
    ) %>%
    raster::stack() %>%
    raster::calc(fun = function(x) mean(x, na.rm = TRUE)) %>%
    raster::writeRaster(glue::glue("data/sentinel/image_vi/mSR-{year}.tif"),
      overwrite = TRUE
    )

  cat(glue("Starting D1 {year}"))
  # D1
  image %>%
    lapply(raster::stack) %>%
    future.apply::future_lapply(
      FUN = raster::calc,
      fun = function(x) (x[[7]] / 10000) / (x[[5]] / 10000)
    ) %>%
    raster::stack() %>%
    raster::calc(fun = function(x) mean(x, na.rm = TRUE)) %>%
    raster::writeRaster(glue::glue("data/sentinel/image_vi/D1-{year}.tif"),
      overwrite = TRUE
    )

  return(list(
    list.files("data/sentinel/image_vi",
      full.names = TRUE,
      pattern = year
    )
  ))
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
    map_chr(data, ~ names(.x)[1]) %>%
    map_chr(~ paste0("bf2_", .)) %>%
    # remove year suffix
    gsub("\\..*", "", x = .)

  prediction_df <-
    data %>%
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
  pred <- predict(model$learner.model, newdata = as.matrix(data))
  return(tibble(defoliation = pred, x = coordinates$x, y = coordinates$y))
}

#' @title prediction_raster
#' @description Transforms the predictions and their cooridnates into a GeoTIFF
#'
#' @param data (`data.frame`)\cr Predicted data
#' @param year (`character`)\cr Year of the predicted values
#' @param relative Whether the values are absolute or relative ones.
#' @return (`brick`)
#' @export
prediction_raster <- function(data, year, relative = NULL) {
  all_spdf <- SpatialPixelsDataFrame(
    points = data[, c("x", "y")],
    data = as.data.frame(data[, "defoliation"]),
    proj4string = CRS("+proj=utm +zone=30 +datum=WGS84 +units=m +no_defs")
  )

  if (!is.null(relative)) {
    year <- glue("{year}-relative")
  }
  raster(all_spdf) %>%
    writeRaster(glue("data/sentinel/image_defoliation/defoliation-{year}.tif"),
      overwrite = TRUE
    )

  # Return for drake
  return(raster(all_spdf))
}

#' @title write_defoliation_map
#' @description Predict defoliation for the Basque Country
#'
#' @param data (`data.frame`)\cr Predictions including coordinates
#' @param algorithm (`character`)\cr Name of the algoritm
#' @param limits (`integer`)\cr Y axis limits
#' @return (`character`)
#' @export
create_defoliation_map <- function(data, algorithm, limits, title) {
  # all_spdf <- SpatialPixelsDataFrame(
  #   points = data[, c("x", "y")],
  #   data = as.data.frame(data[, "defoliation"]),
  #   proj4string = CRS("+proj=utm +zone=30 +datum=WGS84 +units=m +no_defs")
  # )

  plot <- ggplot() +
    annotation_map_tile(zoomin = -1, type = "cartolight") +
    layer_spatial(data, aes(fill = stat(band1))) +
    scale_fill_viridis_c(
      na.value = NA, name = title,
      limits = limits
    ) +
    # spatial-aware automagic scale bar
    annotation_scale(location = "tl") +
    # spatial-aware automagic north arrow
    annotation_north_arrow(location = "br", which_north = "true") +
    theme_pubr(legend = "right") +
    theme(
      legend.key.size = unit(2, "line"),
      plot.margin = margin(1.5, 0, 1, 0)
    ) +
    labs(caption = glue(
      "Algorithm: {algorithm},",
      " Spatial resolution: 20 m"
    ))

  # Return for drake
  return(plot)
}

#' @title write_defoliation_map
#' @description Scale absolute predicted defoliation to 0 - 100
#'
#' @param data (`data.frame`)\cr Defoliation data.frame to scale
#' @return (`character`)
#' @export
scale_defoliation <- function(data) {
  data$defoliation <- scale(data$defoliation,
    center = FALSE,
    scale = max(data$defoliation, na.rm = TRUE) / 100
  )

  return(data)
}

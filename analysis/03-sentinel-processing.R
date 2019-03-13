# load area of interest
# ------------------------------
aoi = st_read("/home/marc/basque/01_data/aoi.shp", quiet = TRUE)

# get records from copernicus open access hub
# ------------------------------
records = get_records(aoi)

# download images from copernicus open access hub
# ------------------------------
image_zip = download_images(records)

# unzip images
# ------------------------------
image_unzip = unzip_images(image_zip)

# stack bands for each image
# ------------------------------
image_stack = stack_bands(records, image_unzip)

# copy cloud covers from unziped files
# ------------------------------
cloud_stack = copy_cloud(records, image_unzip)

# mosaic images of the same date
# ------------------------------
image_mosaic = mosaic_images(records, image_stack)

# mosaic cloud covers of same date
# ------------------------------
cloud_mosaic = mosaic_clouds(records, cloud_stack)

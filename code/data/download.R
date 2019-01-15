# Raw data -----------------------------------------------------------

data_hs_raw = map(list.files("/data/patrick/raw/hyperspectral/ATM",
                             full.names = TRUE, pattern = ".tif$"),
                  ~ stack(.x))

plot_locations = st_read("/data/patrick/mod/plots/location/all-plots.gpkg",
                         quiet = TRUE) %>%
  mutate(Name = as.character(ignore(Name)))

name_id = c("a busturi-axpe", "Laukiz I", "Laukiz II", "Laukiz III", "a altube",
            "a barazar", "Laricio defol. Urkiola.", "aguinaga pinaster radiata",
            "Oiartzun", "Pinast. Arza", "Pinas. Santa Koloma", "Rad. Menagaray 1",
            "Rad. Menagaray 2", "Ayala/Aiara", "Silvest. Nograro", "a caranca",
            "Picea Abornicano", "douglas 1", "douglas 2", "Rad. Altube",
            "a otxandio", "Laricio defol. Olaeta. pol", "Douglas Legutio",
            "Laricio defol.Gatzaga", "a azaceta", "a gipuzkoa",
            "Sequoia Legorreta", "Douglas Albiztur")
name_out = c("busturi", "laukiz1", "laukiz2", "laukiz3", "altube", "barazar",
             "laricio-defol-urkiola", "aguinaga-pinaster-radiata", "oiartzun",
             "pinast-arza", "pinas-santa-koloma", "rad-menagaray-1",
             "rad-menagaray-2", "luiando", "silvest-nograro", "caranca",
             "picea-abornicano", "douglas-1", "douglas-2", "rad-altube",
             "otxandio", "laricio-defol-olaeta", "douglas-legutio",
             "laricio-gatzaga", "azaceta", "gipuzkoa", "sequoia-legorreta",
             "douglas-albiztur")
index = c(1, 2, 2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 11, 12, 13, 14, 16, 16, 16,
          17, 17, 18, 20, 21, 22, 22, 23)

wavelength = c(404.08, 408.5, 412.92, 417.36, 421.81, 426.27, 430.73, 435.2,
               439.69, 444.18, 448.68, 453.18, 457.69, 462.22, 466.75, 471.29,
               475.83, 480.39, 484.95, 489.52, 494.09, 498.68, 503.26, 507.86,
               512.47, 517.08, 521.7, 526.32, 530.95, 535.58, 540.23, 544.88,
               549.54, 554.2, 558.86, 563.54, 568.22, 572.9, 577.6, 582.29,
               586.99, 591.7, 596.41, 601.13, 605.85, 610.58, 615.31, 620.05,
               624.79, 629.54, 634.29, 639.04, 643.8, 648.56, 653.33, 658.1,
               662.88, 667.66, 672.44, 677.23, 682.02, 686.81, 691.6, 696.4,
               701.21, 706.01, 710.82, 715.64, 720.45, 725.27, 730.09, 734.91,
               739.73, 744.56, 749.39, 754.22, 759.05, 763.89, 768.72, 773.56,
               778.4, 783.24, 788.08, 792.93, 797.77, 802.62, 807.47, 812.32,
               817.17, 822.02, 826.87, 831.72, 836.57, 841.42, 846.28, 851.13,
               855.98, 860.83, 865.69, 870.54, 875.39, 880.24, 885.09, 889.94,
               894.79, 899.64, 904.49, 909.34, 914.18, 919.03, 923.87, 928.71,
               933.55, 938.39, 943.23, 948.07, 952.9, 957.73, 962.56, 967.39,
               972.22, 977.04, 981.87, 986.68, 991.5, 996.31)

indices <- c("Boochs", "Boochs2","CARI", "Carter", "Carter2", "Carter3", "Carter4", "Carter5",
             "Carter6", "CI", "CI2", "ClAInt", "CRI1", "CRI2", "CRI3", "CRI4",
             "D1", "D2",
             "Datt", "Datt2", "Datt3", "Datt4", "Datt5", "Datt6", "DD", "DDn", "DPI", "DWSI4",
             "EGFR", "EVI", "GDVI_2", "GDVI_3", "GDVI_4", "GI", "Gitelson",
             "Gitelson2", "GMI1", "GMI2", "Green NDVI", "Maccioni", "MCARI",
             "MCARI2", "mND705", "mNDVI", "MPRI", "MSAVI", "mSR",
             "mSR2", "mSR705", "MTCI", "MTVI", "NDVI", "NDVI2", "NDVI3",
             "NPCI", "OSAVI", "PARS", "PRI", "PRI_norm", "PRI*CI2", "PSRI",
             "PSSR", "PSND","SPVI", "PWI", "RDVI", "REP_Li", "SAVI", "SIPI",
             "SPVI","SR", "SR1", "SR2", "SR3", "SR4", "SR5", "SR6", "SR7",
             "SR8", "Sum_Dr1", "Sum_Dr2", "SRPI", "TCARI", "TCARI2", "TGI", "TVI", "Vogelmann",
             "Vogelmann2", "Vogelmann3", "Vogelmann4")

# loadd(data_hs_raw, name_id, name_out, index,
#       plot_locations)

# load tree-per-tree data
tree_per_tree = st_read(glue("/data/patrick/mod/tree-per-tree/2016/{plot_name}/{plot_name}.gpkg"),
                        quiet = TRUE)

# heterobasidion_data = preprocessing_custom("https://data.mendeley.com/datasets/kmy95t22fy/2/files/41deb463-d378-46da-a25e-26044ce253fe/heterobasidion-armillaria.gpkg",
#                                            study_area = data_basque, drop_vars = "armillaria",
#                                            response = "heterobasi",
#                                            soil = soil, lithology = lithology, slope = slope,
#                                            temperature = temperature_mean, ph = ph,
#                                            hail = hail_raw, precipitation = precipitation_sum,
#                                            pisr = pisr, elevation = elevation, age = FALSE)
# diplodia_data = preprocessing_custom("https://data.mendeley.com/datasets/kmy95t22fy/2/files/d928133b-e199-4ed1-af8b-ac2f5c1ed309/diplodia-fusarium.gpkg",
#                                      study_area = data_basque, drop_vars = "fus01",
#                                      response = "diplo01",
#                                      soil = soil, lithology = lithology, slope = slope,
#                                      temperature = temperature_mean, ph = ph,
#                                      hail = hail_raw, precipitation = precipitation_sum,
#                                      pisr = pisr, elevation = elevation, age = TRUE)
# fusarium_data = preprocessing_custom("https://data.mendeley.com/datasets/kmy95t22fy/2/files/d928133b-e199-4ed1-af8b-ac2f5c1ed309/diplodia-fusarium.gpkg",
#                                      study_area = data_basque, drop_vars = "diplo01",
#                                      response = "fus01",
#                                      soil = soil, lithology = lithology, slope = slope,
#                                      temperature = temperature_mean, ph = ph,
#                                      hail = hail_raw, precipitation = precipitation_sum,
#                                      pisr = pisr, elevation = elevation, age = TRUE)
#
# # Raw Data preprocessing ------------------------------------------------------------
#
# data_basque = st_read("https://data.mendeley.com/datasets/kmy95t22fy/2/files/13fcf51e-c528-4af4-9f71-f9feaa6c4b0c/study-area.gpkg",
#                       quiet = TRUE)
#
# dem_raw = dem_download("https://data.mendeley.com/datasets/kmy95t22fy/2/files/6d827708-dd7b-4929-93c0-3c6f6ecd8397/dem.zip")
# slope = slope_processing(path = dem_raw)
# elevation = elevation_preprocessing(path = dem_raw)
#
# temperature_mean = temperature_preprocessing(atlas_climatico = atlas_climatico)
# precipitation_sum = precipitation_preprocessing(atlas_climatico = atlas_climatico)
# pisr = pisr_preprocessing(atlas_climatico = atlas_climatico)
#
# lithology_raw = lithology_download(path = "https://data.mendeley.com/datasets/kmy95t22fy/2/files/073658ff-936c-4f12-939b-7d3e3f7eaa19/lithology.zip")
# lithology = lithology_preprocessing(lithology_raw)
#
# ph_raw = ph_download("https://data.mendeley.com/datasets/kmy95t22fy/2/files/2f867057-bcc4-452e-95ff-279dd5127043/ph.zip")
# ph = ph_preprocessing(path = ph_raw,
#                       study_area = data_basque)
#
# soil_raw = soil_download("https://data.mendeley.com/datasets/kmy95t22fy/2/files/44f00c51-5da5-4d54-b5a7-f2334da62ce2/soil.tif")
# soil = soil_preprocessing(path = soil_raw,
#                           study_area = data_basque)
#
# atlas_climatico_raw = atlas_climatico_download("https://data.mendeley.com/datasets/kmy95t22fy/2/files/c8a78642-091b-4d37-a20a-12bca03d8338/atlas-climatico.zip")
# atlas_climatico = atlas_climatico_preprocessing(path = atlas_climatico_raw,
#                                                 study_area = data_basque)
#
# hail_raw = hail_download(path = "https://data.mendeley.com/datasets/kmy95t22fy/2/files/08fbf8e3-b74a-4a0a-8c02-108fbecd7623/hail-probability.tif")
#
# # Prediction data ---------------------------------------------------------
#
# pred_data = create_prediction_data(temperature = temperature_mean,
#                                    precipitation = precipitation_sum,
#                                    pisr = pisr,
#                                    elevation = elevation,
#                                    soil = soil,
#                                    slope = slope,
#                                    lithology = lithology,
#                                    hail = hail_raw,
#                                    ph = ph, study_area = data_basque)

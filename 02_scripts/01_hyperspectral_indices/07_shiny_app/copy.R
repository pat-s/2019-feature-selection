fs::dir_delete("/home/patrick/ShinyApps/hyperspectral") # overwrite arg missing for dir_copy when writing this
fs::dir_copy(here::here("02_scripts/01_hyperspectral_indices/07_shiny_app"),
             "/home/patrick/ShinyApps/hyperspectral")

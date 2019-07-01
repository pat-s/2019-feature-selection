#### -- Packrat Autoloader (version 0.5.0) -- ####
source("packrat/init.R")
#### -- End Packrat Autoloader -- ####

options(drake_make_menu = FALSE)

library("drake")
library("usethis")

# load rJava from Spack
# installing it locally with a working Java linking is a pain
.libPaths(append(.libPaths(), "/opt/spack/opt/spack/linux-centos7-x86_64/gcc-7.3.0/r-rjava-0.9-11-e5vzheivjx7l2lykrzaure57ktdp5xgb/rlib/R/library"))

# tibble > data.frame
if (interactive() && "tibble" %in% rownames(utils::installed.packages())) {
  print.data.frame = function(x, ...) {
    tibble:::print.tbl(tibble::as_tibble(x), ...)
  }
}

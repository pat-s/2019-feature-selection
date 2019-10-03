#### -- Packrat Autoloader (version 0.5.0) -- ####
source("packrat/init.R")
#### -- End Packrat Autoloader -- ####

# rgdal
options(
  drake_make_menu = FALSE,
  Ncpus = 10,
  configure.args=list(
    rgdal = c(
      "--with-proj-lib=/opt/spack/opt/spack/linux-centos7-zen/gcc-9.2.0/proj-5.2.0-az6mkj55zpnh6fmg2ae5wyrmhfiynxfx/lib"),
    sf = c(
      "--with-proj-lib=/opt/spack/opt/spack/linux-centos7-zen/gcc-9.2.0/proj-5.2.0-az6mkj55zpnh6fmg2ae5wyrmhfiynxfx/lib")
  ),

  radian.editing_mode = "vi",
  radian.auto_match = TRUE,
  radian.auto_indentation = TRUE,
  radian.tab_size = 2,
  radian.complete_while_typing = TRUE
)

library(drake)
library(magrittr)

# tibble > data.frame
if (interactive() && "tibble" %in% rownames(utils::installed.packages())) {
  print.data.frame = function(x, ...) {
    tibble:::print.tbl(tibble::as_tibble(x), ...)
  }
}


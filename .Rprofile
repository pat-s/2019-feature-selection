#### -- Packrat Autoloader (version 0.5.0) -- ####
source("packrat/init.R")
#### -- End Packrat Autoloader -- ####

options(drake_make_menu = FALSE)
options(configure.args=list(rgdal=c("--with-proj-include=/opt/spack/opt/spack/linux-centos7-x86_64/gcc-7.3.0/proj-5.0.1-kbodwcnjxemfewjbke6lbzp44z52umpa/include",
"--with-proj-lib=/opt/spack/opt/spack/linux-centos7-x86_64/gcc-7.3.0/proj-5.0.1-kbodwcnjxemfewjbke6lbzp44z52umpa/lib")))

# tibble > data.frame
if (interactive() && "tibble" %in% rownames(utils::installed.packages())) {
  print.data.frame = function(x, ...) {
    tibble:::print.tbl(tibble::as_tibble(x), ...)
  }
}

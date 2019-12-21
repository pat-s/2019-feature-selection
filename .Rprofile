source("renv/activate.R")

options(
  drake_make_menu = FALSE,
  Ncpus = 10,
  # repos = BiocManager::repositories(),
  radian.editing_mode = "vi",
  radian.auto_match = TRUE,
  radian.auto_indentation = TRUE,
  radian.tab_size = 2,
  radian.complete_while_typing = TRUE,
  scipen = 999,

  clustermq.scheduler = "slurm",
  clustermq.template = "slurm_clustermq.tmpl",

  precommit.executable = "/opt/spack/opt/spack/linux-centos7-x86_64/gcc-9.2.0/py-pre-commit-1.20.0-ib4ogqnt3wwjan5pj6z6ud2ibz2ywh5e/bin/pre-commit"
)
library(drake)
library(magrittr)

# tibble > data.frame
if (interactive() && "tibble" %in% rownames(utils::installed.packages())) {
  print.data.frame <- function(x, ...) {
    tibble:::print.tbl(tibble::as_tibble(x), ...)
  }
}

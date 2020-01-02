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

  precommit.executable = "/home/patrick/.local/bin/pre-commit"
)
library(drake)
library(magrittr)

# tibble > data.frame
if (interactive() && "tibble" %in% rownames(utils::installed.packages())) {
  print.data.frame <- function(x, ...) {
    tibble:::print.tbl(tibble::as_tibble(x), ...)
  }
}

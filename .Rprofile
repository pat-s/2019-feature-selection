Sys.setenv(TERM_PROGRAM = "vscode")
source(file.path(Sys.getenv(if (.Platform$OS.type == "windows") "USERPROFILE" else "HOME"), ".vscode-R", "init.R"))

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
suppressMessages(require(drake))
suppressMessages(require(magrittr))
suppressMessages(require(usethis))

# tibble > data.frame
if (interactive() && "tibble" %in% rownames(utils::installed.packages())) {
  print.data.frame <- function(x, ...) {
    tibble:::print.tbl(tibble::as_tibble(x), ...)
  }
}

if (
  interactive() &&
    requireNamespace("rsthemes", quietly = TRUE) &&
    requireNamespace("later", quietly = TRUE)
) {
  # Use later to delay until RStudio is ready
  later::later(function() {
    rsthemes::set_theme_light("One Light {rsthemes}") # light theme
    rsthemes::set_theme_dark("Mojave Dark (Static)") # dark theme

    # To automatically choose theme based on time of day
    rsthemes::use_theme_auto(dark_start = "17:00", dark_end = "8:00")
  }, delay = 1)
}

runAllChunks <- function(rmd, envir=globalenv()){
  tempR <- tempfile(tmpdir = ".", fileext = ".R")
  on.exit(unlink(tempR))
  knitr::purl(rmd, output=tempR)
  sys.source(tempR, envir=envir)
}

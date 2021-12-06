Sys.setenv(TERM_PROGRAM = "vscode")
if (Sys.getenv("CI") == "") {
  source(file.path(Sys.getenv(if (.Platform$OS.type == "windows") "USERPROFILE" else "HOME"), ".vscode-R", "init.R"))
}

if ("httpgd" %in% .packages(all.available = TRUE)) {
  options(vsc.plot = FALSE)
  options(device = function(...) {
    httpgd::hgd(silent = TRUE)
    .vsc.browser(httpgd::hgd_url(), viewer = "Beside")
  })
}

source("renv/activate.R")

options(bitmapType = "cairo")

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
  clustermq.template = "slurm_clustermq.tmpl",
  precommit.executable = "/home/patrick/.local/bin/pre-commit",
  renv.settings.auto.snapshot = TRUE
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

# runAllChunks <- function(rmd, envir = globalenv()) {
#   tempR <- tempfile(tmpdir = ".", fileext = ".R")
#   on.exit(unlink(tempR))
#   knitr::purl(rmd, output = tempR)
#   sys.source(tempR, envir = envir)
# }

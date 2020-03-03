#' Copy a file to a new location conditionally
#'
#' @description
#'   By default the copying is only done if the new file is newer than an
#'   already existing file.
#'   The main goal of this function is to  have one wrapper script which calls
#'   to this function which copy only files that have recently changed.
#'   This avoids lots of uneeded diffs in version control.
#'
#' @param file_in The file to be moved
#' @param dir_out The directory to be moved to
#' @examples
#' library("fs")
#' file_touch("test.xy")
#' file_cp_ts("test.xy", "log/")
#'
#' # now both files are equal, no copying will be done
#' file_cp_ts("test.xy", "log/")
file_cp_ts <- function(file_in, dir_out) {
  if (!fs::file_exists(file_in)) {
    cli::cli_alert_info("File {.file {file_in}} does not exist. Skipping.")
    return()
  }

  basename <- fs::path_file(file_in)
  file_out <- glue::glue("{dir_out}{basename}")

  # create output dir if it does not exist
  fs::dir_create(dir_out)

  if (fs::file_exists(file_out)) {
    file_in_time <- lubridate::as_datetime(fs::file_info(file_in)$modification_time)
    file_out_time <- lubridate::as_datetime(fs::file_info(file_out)$modification_time)

    if (file_in_time > file_out_time) {
      fs::file_copy(file_in, file_out, overwrite = TRUE)
      cli::cli_alert_info("Timestamp of file {.file {basename}} newer than in
                          destination, copying file.", wrap = TRUE)
    } else {
      cli::cli_alert_success("{.file {basename}}: Everything up-to-date.")
    }
  } else {
    fs::file_copy(file_in, file_out)
  }
}

copy_figures <- function() {

  # eda.Rmd --------------------------------------------------------------------

  file_cp_ts(
    here::here("docs/figure/eda.Rmd/defoliation-distribution-plot-1.pdf"),
    here::here("docs/00-manuscripts/ieee/pdf/")
  )

  # spectral-signatures.Rmd ----------------------------------------------------

  file_cp_ts(
    here::here("docs/figure/spectral-signatures.Rmd/spectral-signatures-1.pdf"),
    here::here("docs/00-manuscripts/ieee/pdf/")
  )

  # eval-performance.Rmd -------------------------------------------------------

  file_cp_ts(
    here::here("docs/figure/eval-performance.Rmd/performance-results-1.pdf"),
    here::here("docs/00-manuscripts/ieee/pdf/")
  )
  # file_cp_ts(
  #   "docs/figure/eval-performance.Rmd/filter-effect-1.pdf",
  #   "docs/00-manuscripts/ieee/pdf/"
  # )
  # file_cp_ts(
  #   "docs/figure/eval-performance.Rmd/filter-perf-all-1.pdf",
  #   "docs/00-manuscripts/ieee/pdf/"
  # )

  # filter-correlation.Rmd -----------------------------------------------------

  file_cp_ts(
    "docs/figure/filter-correlation.Rmd/correlation-nbins-1.pdf",
    "docs/00-manuscripts/ieee/pdf/"
  )
  file_cp_ts(
    "docs/figure/filter-correlation.Rmd/correlation-filter-nri-1.pdf",
    "docs/00-manuscripts/ieee/pdf/"
  )

  # feature-importance.Rmd -----------------------------------------------------

  file_cp_ts(
    here::here("docs/figure/feature-importance.Rmd/fi-permut-vi-hr-1.pdf"),
    here::here("docs/00-manuscripts/ieee/pdf/")
  )
}

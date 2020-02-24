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
  basename <- fs::path_file(file_in)
  file_out <- glue::glue("{dir_out}{basename}")

  # if (!file_exists(glue::glue("{dir_out}{basename}"))) {
  #   stop(sprintf("'%s' does not exist."))
  # }

  # just in case create output dir if it does not exist
  fs::dir_create(dir_out)

  if (file_exists(file_out)) {
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

#' @title EDA functions from A. Brenning
#' @description Correlation plot of a dataset
#' @param x [data.frame]
#' @param col.hist (`character(1)`)\cr
#'  Color for histograms
#' @param cex.cor (`character(1)`)\cr
#' Numeric character expansion factor, see
#'   [graphics::text()]
#' @param digits (`integer(1)`)\cr
#'  Amount of digits to round correlation result to
#' @param pch See [graphics::points()]
#' @param cex See [graphics::points()]
#' @name my_pairs
#' @export
#'

panel.hist <- function(x,
                       col.hist = "cyan",
                       cex.cor = NULL,
                       digits = NULL,
                       col = NULL,
                       pch = NULL,
                       cex = NULL,
                       ...) {
  dummy <- is.character(cex.cor) | is.numeric(digits) | is.character(cex) |
    is.character(pch) | is.character(col)
  usr <- par("usr")
  on.exit(par(usr))
  par(usr = c(usr[1:2], 0, 1.5))
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks
  nB <- length(breaks)
  y <- h$counts
  y <- y / max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col = col.hist, ...)
}

panel.cor <- function(x,
                      y,
                      digits = 2,
                      prefix = "",
                      cex.cor = NULL,
                      col.hist = NULL,
                      col = NULL,
                      pch = NULL,
                      cex = NULL, ...) {
  dummy <- is.character(col.hist) | is.character(cex) | is.character(pch) |
    is.character(col)
  usr <- par("usr")
  on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y, use = "pairwise.complete.obs"))
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste(prefix, txt, sep = "")
  if (is.null(cex.cor)) cex.cor <- 0.8 / strwidth(txt)
  # text(0.5, 0.5, txt, cex = cex.cor * r)
  text(0.5, 0.5, txt, cex = cex.cor)
}

#' @export
#' @examples
#' my_pairs(iris)
my_pairs <- function(x, ...) {
  pairs(x, ...,
    upper.panel = panel.smooth, lower.panel = panel.cor, diag.panel = panel.hist
  )
}

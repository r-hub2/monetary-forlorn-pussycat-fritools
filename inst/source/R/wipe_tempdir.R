#' Wipe Clean the \code{tempdir()}
#'
#' I often need a clean temporary directory.
#' @param recreate Use the method described in the examples section of
#' \code{\link{tempdir}} (using \code{tempdir(check = TRUE)}, this results in a
#' new path.)
#' @family R memory functions
#' @family operating system functions
#' @return The path to the temporary directory.
#' @export
#' @examples
#' \dontrun{
#' dir.create(t <- file.path(tempdir(), "foo"))
#' touch(f1 <- file.path(t, "first.R"),
#'       f2 <- file.path(t, "second.R"))
#' dir(tempdir(), recursive = TRUE)
#' wipe_tempdir()
#' dir(tempdir(), recursive = TRUE)
#' }
wipe_tempdir <- function(recreate = FALSE) {
    if (isTRUE(recreate)) {
        unlink(tempdir(), recursive = TRUE, force = TRUE)
        res <- tempdir(check = TRUE)
    } else {
        unlink(dir(tempdir(), all.files = TRUE, full.names = TRUE),
               recursive = TRUE)
        res <- tempdir()
    }
    return(invisible(res))
}

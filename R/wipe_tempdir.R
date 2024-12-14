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

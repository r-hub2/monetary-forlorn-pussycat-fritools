#' Check Whether Files are Current
#'
#' I sometimes produce a couple of files by some kind of process and need to
#' check whether they are fairly current and probably product of the same run.
#' So I need to know whether a bunch of files was modified within the
#' last, say, 7 days \emph{and} that their modification dates do not differ by
#' more than, say, 24 hours.
#'
#' @param ... File paths.
#' @param newer_than The number of \bold{units} the files need to be newer than.
#' @param units The unit of \bold{newer_than}. See \code{\link{difftime}}.
#' @param within The number of \bold{units} the files need to be modified
#' within.
#' @param within_units The unit of \bold{within}. See \code{\link{difftime}}.
#' @export
#' @family file utilities
#' @template return_boolean
#' @examples
#' p1 <- tempfile()
#' p2 <- tempfile()
#' p3 <- tempfile()
#' touch(p1)
#' touch(p2)
#' Sys.sleep(3)
#' touch(p3)
#' is_files_current(p3, newer_than = 1, units = "days",
#'                  within = 4, within_units = "secs")
#' is_files_current(p1, p2, p3, newer_than = 1, units = "days",
#'                  within = 4, within_units = "secs")
#' is_files_current(p1, p2, p3, newer_than = 1, units = "days",
#'                  within = 1, within_units = "secs")
#' is_files_current(p1, p2, p3, newer_than = 1, units = "secs",
#'                  within = 4, within_units = "secs")
is_files_current <- function(..., newer_than = 1, units = "week",
                             within = 1, within_units = "days") {
    files <- list(...)
    times <-  sort(as.POSIXct(sapply(files, file.mtime), origin = "1970-01-01"))
    if (length(times) > 1) {
        res <- is_difftime_less(max(times), min(times),
                                less_than = within, units = within_units)
    } else {
        res <- TRUE
    }
    res <- res && is_difftime_less(min(times), Sys.time(),
                                   less_than = newer_than,
                                   units = units)
    if (difftime(max(times), Sys.time()) > 0)
        warning("At least one file is newer than Sys.time().")
    return(res)
}

#' Check Whether Two Times Differ Less Than A Given Value
#'
#' This is just a wrapper to \code{\link{difftime}}.
#'
#' @param time1 See \code{\link{difftime}}.
#' @param time2 See \code{\link{difftime}}.
#' @param less_than The number of \bold{units} that would be too much of a
#' difference.
#' @param units See \code{\link{difftime}}.
#' @param verbose Be verbose?
#' @param visible Set to \code{\link{FALSE}} to return
#' \code{\link{invisible}}.
#' @param stop_on_error Throw an error if the time lag is not less than
#' \bold{less_than}.
#' @export
#' @family bits and pieces
#' @return \code{\link{TRUE}} if the times do not differ `that much`, but see
#' \bold{stop_on_error}.
#' @examples
#' a <- as.POSIXct(0, origin = "1970-01-01", tz = "GMT")
#' b <- as.POSIXct(60*60*24, origin = "1970-01-01", tz = "GMT")
#' c <- as.POSIXct(60*60*24 - 1, origin = "1970-01-01", tz = "GMT")
#' is_difftime_less(a, b)
#' is_difftime_less(a, c)
#' print(is_difftime_less(a, b, verbose = TRUE))
#' print(is_difftime_less(a, c, verbose = TRUE))
#' try(is_difftime_less(a, b, stop_on_error = TRUE))
#' is_difftime_less(a, c, verbose = TRUE, stop_on_error = TRUE)
is_difftime_less <- function(time1, time2, less_than = 1, units = "days",
                             verbose = FALSE, visible = !verbose,
                             stop_on_error = FALSE) {
    res <- NULL
    if (abs(difftime(time1, time2, units = units)) >= less_than) {
        msg <- paste0("Time difference between ", time1, " and ", time2,
                "\nis at least ", less_than, " ", units, ".")
        if (isTRUE(stop_on_error)) {
            throw(msg)
        } else {
            if (isTRUE(verbose)) {
                warning(msg)
            }
            res <- FALSE
        }
    } else {
        if (isTRUE(verbose)) {
            msg <- paste0("Time difference between ", time1, " and ", time2,
                          "\nis less than ", less_than, " ", units, ".")
            message(msg)
        }
        res <- TRUE
    }
    if (isTRUE(visible)) {
        return(res)
    } else {
        return(invisible(res))
    }
}

#' Find Memory Hogs
#'
#' List objects in an \R environment by size.
#' @param unit  The unit to use.
#' @param envir  The environment where to look for objects.
#' @param return_numeric  Return a numeric vector? If set to
#' \code{\link{FALSE}}, a character vector including the unit will be returned,
#' which might be less usable but easier to read.
#' @param ... Arguments passed to \code{\link{order}}, defaults to
#' \code{decreasing = FALSE}.
#' @return A named vector of memory usages.
#' @family R memory functions
#' @export
#' @examples
#' va <- rep(mtcars, 1)
#' vb <- rep(mtcars, 1000)
#' vc <- rep(mtcars, 2000)
#' vd <- rep(mtcars, 100)
#' memory_hogs()
#' memory_hogs(unit = "Mb", decreasing = TRUE)
#' memory_hogs(unit = "Mb", decreasing = TRUE, return_numeric = FALSE)
memory_hogs <- function(unit =  c("b", "Kb", "Mb", "Gb", "Tb", "Pb"),
                        return_numeric = TRUE, ..., envir = parent.frame()) {
    u <- match.arg(unit)
    f <- function(x) {
        object_sizes <- utils::object.size(get(x, envir = envir))
        prints <- utils::capture.output(print(object_sizes, standard = "legacy",
                                              units = u))
        return(prints)
    }
    z <- sapply(ls(envir = envir), f)
    if (u == "b") u <- "bytes"
    x <- as.numeric(gsub(paste0(" ", u), "", z))
    names(x) <- names(z)
    if (isTRUE(return_numeric)) {
        res <- x
    } else {
        res <- z
    }
    if (! missing(...)) {
        res <- res[order(x, ...)]
    } else {
        res <- res[order(x, decreasing = FALSE)]
    }
    if (isTRUE(return_numeric)) {
        attr(res, "units") <- u
    }
    return(res)
}

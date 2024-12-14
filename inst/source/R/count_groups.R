#' Count Observations per Groups
#'
#' I tend to forget the syntax that works with
#' \code{\link[stats:aggregate]{stats::aggregate}}.
#' @param x A \code{\link{data.frame}}.
#' @param ... Columns in \code{x}.
#' @family statistics
#' @return A \code{\link{data.frame}} with the counts per groups.
#' @export
#' @examples
#' count_groups(mtcars, "am", "gear")
#' RUnit::checkEquals(dplyr::count(mtcars, am, gear),
#'                    count_groups(mtcars, "am", "gear"), checkNames = FALSE)
count_groups <- function(x, ...) {
    l <- list(...)
    by <- list()
    for (i in seq(along = l)) {
        name <- names(l)[i]
        if (is.null(name)) name <- l[[i]]
        by[name] <- x[l[[i]]]
    }
    res <- stats::aggregate(x = x[l[[1]]],
                     by,
                     length)
    names(res)[dim(res)[2]] <- "count"
    return(res)
}

#' Sum up the Numeric Columns of a Data Frame
#'
#' I often need to calculate the sums of the numeric columns of a
#' \code{\link{data.frame}}. While \code{\link{colSums}} requires the data frame
#' to be numeric, this is a convenience wrapper to select numeric columns only.
#' @param x A  \code{\link{data.frame}}.
#' @param ... Arguments passed to \code{\link{colSums}}.
#' @return A named vector of column sums (see \code{\link{colSums}}).
#' @family statistics
#' @export
#' @examples
#' try(colSums(iris))
#' column_sums(iris)
#' names(iris) # no column sum for `Species`
column_sums <- function(x, ...) {
    res <- colSums(x[TRUE, sapply(x, is.numeric)], ...)
    return(res)
}

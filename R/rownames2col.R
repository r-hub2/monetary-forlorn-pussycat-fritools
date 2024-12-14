#' Add a Column Containing the Row Names to a Data Frame
#'
#' @param x A \code{\link{data.frame}}.
#' @param column_name The name of the new column containing the
#' \code{\link{row.names}}.
#' @return A \code{\link{data.frame}}.
#' @family bits and pieces
#' @export
#' @examples
#' rownames2col(mtcars, column_name = "model")
rownames2col <- function(x, column_name) {
    res <- stats::setNames(cbind(row.names(x), x), c(column_name, names(x)))
    row.names(res) <- NULL
    return(res)
}

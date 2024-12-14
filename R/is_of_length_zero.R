#' Is an Object of Length Zero?
#'
#' Some expressions evaluate to \code{\link{integer}(0)} or the like.
#' @param x The object.
#' @param class An optional character vector of length 1 giving the class. See
#' \emph{examples}.
#' @template return_boolean
#' @family logical helpers
#' @export
#' @examples
#' x <- ""; length(x); is_of_length_zero(x)
#' x <- grep(" ", "")
#' print(x)
#' is_of_length_zero(x)
#' is_of_length_zero(x, "character")
#' is_of_length_zero(x, "numeric")
#' is_of_length_zero(x, "integer")
is_of_length_zero <- function(x, class = NULL) {
    if (is.null(class))
        result <- identical(length(x), 0L)
    else
        result <- identical(length(x), 0L) && methods::is(x, class)
    return(result)
}

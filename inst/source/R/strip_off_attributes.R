#' Strip Attributes off an Object
#'
#' @param x An object.
#' @return The object.
#' @family bits and pieces
#' @seealso \code{\link[base:unname]{base::unname}}
#' @export
#' @examples
#' y <- stats::setNames(1:3, letters[1:3])
#' attr(y, "myattr") <- "qwer"
#' comment(y) <- "qwer"
#' strip_off_attributes(y)
strip_off_attributes <- function(x) {
    attributes(x) <- NULL
    return(x)
}

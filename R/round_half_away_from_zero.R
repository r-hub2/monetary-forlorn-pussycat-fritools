#' Round Half Away From Zero
#'
#' Commercial rounding is done a lot, especially with invoices. There is even
#' standard 1333 by the German Institute for Standardization.
#' \code{\link{round}} rounds half to even, see \code{\link{round}}'s Details
#' section.
#' @param x A number to be rounded.
#' @param digits The number of digits, as in \code{\link{round}}.
#' @return The rounded number.
#' @export
#' @family statistics
#' @examples
#' x <- 22.5
#' round_half_away_from_zero(x)
#' round(x)
#' round_half_away_from_zero(-x)
#' round(-x)
round_half_away_from_zero <- function(x, digits = 0) {
    res <- sign(x) * trunc(abs(x) * 10^digits + 0.5) / 10^digits
    return(res)
}

#' @description
#' \code{round_commercially} is just a link to \code{round_half_away_from_zero}.
#' @export
#' @rdname round_half_away_from_zero
#' @aliases round_commercially
round_commercially <- round_half_away_from_zero

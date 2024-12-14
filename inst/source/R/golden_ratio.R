#' Calculate the Golden Ratio
#'
#' Divide a length using the golden ratio.
#' @param x The sum of the two quantities to be in the golden ratio.
#' @return A numeric vector of length 2, containing the two quantities \emph{a}
#' and \emph{b}, \emph{a}  being the larger.
#' @family bits and pieces
#' @export
#' @examples
#' golden_ratio(10)
golden_ratio <- function(x) {
  golden_ratio <- (1 + sqrt(5)) / 2
  a <- x / golden_ratio
  b <- x - a
  return(list(a = a, b = b))
}

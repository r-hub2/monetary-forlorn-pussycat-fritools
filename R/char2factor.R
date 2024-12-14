#' Convert a Character Vector Into a Factor
#'
#' I often need a factor with levels the unique values of a character vector
#' (for example: to prevent ggplot2 from sorting the character vector).
#' @param x A character vector.
#' @param levels The levels to use, see \code{\link{factor}}.
#' @return A factor.
#' @family bits and pieces
#' @export
#' @examples
#' x <- c("beech", "oak", "spruce", "fir")
#' char2factor(x)
char2factor <- function(x, levels = unique(x)) {
    res <- factor(x, levels = levels)
    return(res)
}

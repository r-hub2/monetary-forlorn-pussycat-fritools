#' Convert a Character Vector Into an Enumeration
#'
#' @param x A \code{\link{character}} vector.
#' @param separator A separator used for the enumeration.
#' @param last The separator used last for the enumeration.
#' @param add_whitespace Add whitespace after separators?
#' @return A \code{\link{data.frame}}.
#' @family bits and pieces
#' @export
#' @examples
#' string2words(c("beech", "oak", "ash"))
string2words <- function(x, separator = ",", last = "and",
                         add_whitespace = TRUE) {
    if (isTRUE(add_whitespace)) {
        l <- paste0(" ", last, " ")
        s <- paste0(separator, " ")
    } else {
        l <- last
        s <- separator
    }
    res <- paste(c(utils::head(x, -2), paste(utils::tail(x, 2), collapse = l)),
                 collapse = s)
    return(res) 
}

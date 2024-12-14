#' Search All Rows Across Columns of a Matrix-like Structure
#'
#' I sometimes need to see which rows of a matrix-like structure
#' contain a string matched by a search pattern.
#' This somewhat similar to writing a matrix-like structure to disk and then
#' using \code{\link{search_files}} on it.
#' @param x A \code{\link{matrix}} or \code{\link{data.frame}}.
#' @param pattern A pattern.
#' @param include_row_names Include row names into the search?
#' @return All rows where the pattern was found in at least one column.
#' @export
#' @family searching functions
#' @examples
#' p <- "\\<4.0[[:alpha:]]*\\>"
#' search_rows(x = mtcars, pattern = p)
#' search_rows(x = mtcars, pattern = p, include_row_names = FALSE)
#' try(search_rows(x = mtcars, pattern = "ABC"))
search_rows <- function(x, pattern = ".*",
                           include_row_names = TRUE) {
    as_char <- apply(x, 2, as.character)
    if (isTRUE(include_row_names)) as_char <- cbind(rownames(x), as_char)
    i <- apply(as_char, 1, function(x) any(grepl(pattern, x)))
    if (all(!i)) {
        throw(paste0("Could not find ", pattern, " in ", deparse(substitute(x)),
                     "."))
    } else {
        return(x[i, TRUE])
    }
}

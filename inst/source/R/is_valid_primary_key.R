#' Is a Key a Valid Potential Primary Key for a \code{data.frame}?
#'
#' I sometimes see tables with obscure structure so I try to guess their primary
#' keys.
#' @param data The \code{data.frame} for which you want to find valid potential
#' primary key.
#' @param key Character vector containing a subset of the columns names of
#' \code{data}.
#' @param verbose Be verbose?
#' @export
#' @family bits and pieces
#' @return \code{\link{TRUE}}, if \code{key} is a valid primary key,
#' \code{\link{FALSE}} otherwise.
#' @examples
#' is_valid_primary_key(mtcars, "qsec")
#' is_valid_primary_key(mtcars, "carb")
#' is_valid_primary_key(mtcars, c("qsec", "gear"))
#' is_valid_primary_key(mtcars, c("qsec", "carb"))
#' cars <- mtcars
#' cars$id <-  seq_len(nrow(cars))
#' is_valid_primary_key(cars, "id")
is_valid_primary_key <- function(data, key, verbose = TRUE) {
    is_valid <- identical(nrow(data), nrow(unique(data[key])))
    if (isTRUE(verbose)) {
        if (is_valid) {
            message("[", paste(key, collapse = ", "), "]",
                    " is a valid primary key for ",
                    deparse(substitute(data)), ".")
        } else {
            warning("[", paste(key, collapse = ", "), "]",
                    " is not a valid primary key for `",
                    deparse(substitute(data)), "`!")
        }
    }
    return(is_valid)
}

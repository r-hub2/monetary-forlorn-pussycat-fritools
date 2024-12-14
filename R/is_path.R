#' Check Whether an Object Contains a Valid File System Path
#'
#' @param x The object.
#' @template return_boolean
#' @family file utilities
#' @export
#' @examples
#' is_path(tempdir())
#' path <- tempfile()
#' is_path(path)
#' touch(path)
#' is_path(path)
is_path <- function(x) {
    result <- is.character(x) && file.exists(x)
    return(result)
}

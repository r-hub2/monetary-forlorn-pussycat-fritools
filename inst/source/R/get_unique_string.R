#' Create a Fairly Unique String
#'
#' I sometimes need a fairly unique string, mostly for file names, that should
#' start with the current date.
#' @export
#' @return A fairly unique string.
#' @family file utilities
#' @examples
#' replicate(20, get_unique_string())
get_unique_string <- function() {
    name <- paste(sep = "_", strftime(Sys.time(), format = "%Y_%m_%d_%H_%M_%S"),
                  Sys.getpid(), sub("^file", "", basename(tempfile())))
    return(name)
}

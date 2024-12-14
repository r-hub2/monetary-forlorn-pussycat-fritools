#' Get a Session String
#'
#' I sometimes wan't to document the \R session used in a string, so a need an
#' excerpt of \code{\link{sessionInfo}} an \code{\link{Sys.time}}.
#' @return An excerpt of \code{\link{sessionInfo}} as a string.
#' @export
#' @family version functions
#' @examples
#' get_session_string()
get_session_string <- function() {
    x <- utils::sessionInfo()

    mkLabel <- function(L, n) {
        vers <- sapply(L[[n]], function(x) x[["Version"]])
        pkg <- sapply(L[[n]], function(x) x[["Package"]])
        paste(pkg, vers, sep = ": ")
    }
    res <- paste(x$R.version$version.string,
                 paste0("Platform: ", x$platform),
                 paste0("Running under: ", x$running),
                 paste0("Attached: ", paste0(mkLabel(x, "otherPkgs"), collapse = " + ")),
                 paste0("Loaded: ", paste0(mkLabel(x, "loadedOnly"), collapse = " + ")),
                 get_unique_string(),
                 sep = " -- ")
    return(res)
}

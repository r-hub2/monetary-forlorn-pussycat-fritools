#' Is a Version Requirement Met?
#'
#' Just a wrapper to \code{\link{compareVersion}}, I regularly forget how to use
#' it.
#' @param installed The version available.
#' @param required The version required.
#' @return  \code{\link{TRUE}}, if so,  \code{\link{FALSE}} otherwise.
#' @family logical helpers
#' @family package functions
#' @family version functions
#' @export
#' @examples
#' is_version_sufficient(installed = "1.0.0", required = "2.0.0")
#' is_version_sufficient(installed = "1.0.0", required = "1.0.0")
#' is_version_sufficient(installed = get_package_version("base"),
#'                       required = "3.5.2")
is_version_sufficient <- function(installed, required) {
    is_sufficient <- utils::compareVersion(installed, required) >= 0
    return(is_sufficient)
}

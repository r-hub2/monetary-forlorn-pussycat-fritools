#' Is an \R Package Installed?
#'
#' Is an \R package installed?
#' @param x Name of the package as character string.
#' @param version Required minimum version of the package as character string.
#' @template return_boolean
#' @family logical helpers
#' @family operating system functions
#' @family package functions
#' @family version functions
#' @export
#' @examples
#' is_r_package_installed("base", "300.0.0")
#' is_r_package_installed("fritools", "1.0.0")
is_r_package_installed <- function(x, version = "0") {
    installed <- tryCatch(utils::packageVersion(x), error = function(e) NA)
    is_installed  <- !is.na(installed)
    is_sufficient <- is_version_sufficient(installed = as.character(installed),
                                           required = as.character(version))
    return(is_installed && is_sufficient)
}

#' Is an External Program Installed?
#'
#' Is an external program installed?
#'
#' @param program Name of the program.
#' @template return_boolean
#' @family logical helpers
#' @family operating system functions
#' @export
#' @examples
#' if (is_running_on_fvafrcu_machines() || is_running_on_gitlab_com()) {
#'     # NOTE: There are CRAN machines where neither "R" nor "R-devel" is in
#'     # the path, so we skipt this example on unkown machines.
#'     is_installed("R")
#' }
#' is_installed("probably_not_installed")
is_installed <- function(program) {
    is_installed <- nchar(Sys.which(program)) > 0
    is_installed <- unname(is_installed)
    is_installed <- isTRUE(is_installed)
    return(is_installed)
}

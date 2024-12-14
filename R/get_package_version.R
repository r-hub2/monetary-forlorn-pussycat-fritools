#' Query Installed Package Version
#'
#' \code{\link{packageVersion}} converts to class \code{\link{package_version}},
#' which then again would need to be converted for \code{\link{compareVersion}}.
#' So this is a modified copy of \code{\link{packageVersion}} skipping the
#' conversion to \code{\link{package_version}}.
#'
#' @param x A character giving the package name.
#' @param lib_loc See argument \code{lib.loc} in
#' \code{\link{packageDescription}}.
#' @return  A character giving the package version.
#' @family version functions
#' @family package functions
#' @export
#' @examples
#' get_package_version("base")
#' try(get_package_version("mgcv"))
#' utils::compareVersion("1000.0.0", get_package_version("base"))
#' utils::compareVersion("1.0", get_package_version("base"))
#' # from ?is_version_sufficient:
#' is_version_sufficient(installed = get_package_version("base"),
#'                       required = "1.0")
get_package_version <- function(x, lib_loc = NULL) {
    version <- suppressWarnings(utils::packageDescription(x, lib.loc = lib_loc,
                                                          fields = "Version"))
    if (is.na(version)) stop(packageNotFoundError(x, lib_loc, sys.call()))
    return(version)
}

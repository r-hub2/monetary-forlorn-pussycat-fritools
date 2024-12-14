#' Load a Package's Internals
#'
#' Load objects not exported from a package's namespace.
#'
#'
#' @param package The name of the package as a string.
#' @param ... Arguments passed to \code{\link{ls}}, all.names = TRUE could be a
#' good idea.
#' @seealso \code{\link[codetools:checkUsageEnv]{codetools::checkUsageEnv}}.
#' @template return_invisibly_true
#' @family package functions
#' @export
#' @examples
#' load_internal_functions("fritools")
load_internal_functions <- function(package, ...) {
    if (requireNamespace("checkmate", quietly = TRUE))
        checkmate::qassert(package, "S1")
    require(package, character.only = TRUE)
    exported_names <- ls(paste("package", package, sep = ":"), ...)
    is_exported_name_function <- vapply(exported_names,
                                        function(x) is.function(get(x)), TRUE)
    exported_functions <- exported_names[is_exported_name_function]
    package_namespace <- asNamespace(package)
    package_names <- ls(envir = package_namespace)
    is_package_name_function <-
        vapply(package_names,
               function(x) is.function(get(x, envir = package_namespace)),
               TRUE)
    package_functions <- package_names[is_package_name_function]
    internal_functions <- setdiff(package_functions, exported_functions)
    for (name in internal_functions) {
        assign(name, get(name, envir = package_namespace, inherits = FALSE),
               envir = parent.frame())
    }
    return(invisible(TRUE))
}

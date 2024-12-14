#' Call a Function Conditionally
#'
#' \pkg{whoami} 1.3.0 uses things like
#' \code{system("getent passwd $(whoami)", intern = TRUE)}
#' which I can not \code{\link{tryCatch}}, as it gives no error nor warning.
#' So this function returns a fallback if the condition given is not
#' \code{\link{TRUE}}.
#'
#' @param f The function passed to \code{\link{do.call}}.
#' @param ... arguments passed to \code{\link{do.call}}.
#' @param condition An expression.
#' @param fallback See \emph{Description}.
#' @param harden Set to \code{\link{TRUE}} to return \code{fallback} if
#' \code{\link{do.call}} fails.
#' @return The return value of \code{f} or \code{fallback}.
#' @family call functions
#' @export
#' @examples
#' call_conditionally(get_package_version,
#'                    condition = TRUE,
#'                    args = list(x = "fritools"),
#'                    fallback = "0.0")
#' call_conditionally(get_package_version,
#'                    condition = FALSE,
#'                    args = list(x = "fritools"),
#'                    fallback = "0.0")
#' call_conditionally(get_package_version,
#'                    condition = TRUE,
#'                    args = list(x = "not_there"),
#'                    harden = TRUE,
#'                    fallback = "0.0")
call_conditionally <- function(f, condition, fallback, ..., harden = FALSE) {
    res <- if (isTRUE(condition)) {
        if (isTRUE(harden)) {
            tryCatch(do.call(what = f, ...),
                     error = function(e) return(fallback),
                     warning = function(w) return(fallback))
        } else {
            do.call(what = f, ...)
        }
    } else {
        fallback
    }
    return(res)
}

#' Call a Function Given an External Dependency on Non-Windows Systems
#'
#' Just a specialized version of \code{\link{call_conditionally}}.
#'
#' @inheritParams call_conditionally
#' @param dependency The external dependency, see \emph{Examples}.
#' @return The return value of \code{f} or \code{fallback}.
#' @family call functions
#' @export
#' @examples
#' call_safe(whoami::email_address, dependency = "whoami",
#'           args = list(fallback = "foobar@nowhere.com"),
#'           fallback = "nobar@nowhere.com")
#' call_safe(whoami::email_address, dependency = "this_is_not_installed",
#'           args = list(fallback = "foobar@nowhere.com"),
#'           fallback = "nobar@nowhere.com")
call_safe <- function(f, dependency, fallback = "Fallback", ...) {
    call_conditionally(f = f,
                       condition = is_installed(dependency) || is_windows(),
                       fallback = fallback, ..., harden = TRUE)
}

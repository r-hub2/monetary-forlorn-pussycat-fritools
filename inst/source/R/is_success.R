#' Does the Return Value of a Command Signal Success?
#'
#' This is just a wrapper to ease the evaluation of return values from external
#' commands:
#' External commands return 0 on success, which is
#' \code{\link[base:FALSE]{FALSE}}, when converted to logical.
#'
#' @param x The external commands return value.
#' @template return_boolean
#' @family logical helpers
#' @family operating system functions
#' @export
#' @examples
#' is_success(0)
#' is_success(1)
#' is_success(-1)
is_success <- function(x) return(!as.logical(x))

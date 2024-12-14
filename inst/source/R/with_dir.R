#' Execute Code in a Temporary Working Directory
#'
#' This is a verbatim copy of \code{withr::with_dir} from of \pkg{withr}'s
#' version 2.4.1.
#' I often need \pkg{withr} only to import \code{withr::with_dir}, which is a
#' really simple function. So I just hijack \code{withr::with_dir}.
#' @param new The new working directory.
#' @param code Code to execute in the temporary working directory.
#' @return The results of the evaluation of the \code{code} argument.
#' @family operating system functions
#' @export
#' @examples
#' temp_dir <- file.path(tempfile())
#' dir.create(temp_dir)
#' with_dir(temp_dir, getwd())
with_dir <- function(new, code) {
    old <- setwd(dir = new)
    on.exit(setwd(old))
    force(code)
}

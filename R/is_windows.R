#' Is the System Running a Windows Machine?
#'
#' Is the system running a windows machine?
#' @return \code{\link{TRUE}} if so, \code{\link{FALSE}} otherwise.
#' @family logical helpers
#' @family operating system functions
#' @export
#' @examples
#' is_windows()
is_windows <- function() return(.Platform[["OS.type"]] == "windows")

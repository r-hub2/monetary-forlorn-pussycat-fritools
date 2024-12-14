#' Remove Trailing Whitespace From Files
#'
#' Trailing whitespace is a classical lint.
#' @param ... Arguments passed to \code{\link{find_files}}.
#' @family file utilities
#' @template return_invisibly_null
#' @export
#' @examples
#' dir <- tempfile()
#' dir.create(dir)
#' file.copy(system.file("tinytest", package = "fritools"), dir,
#'           recursive = TRUE)
#' delete_trailing_whitespace(path = dir, recursive = TRUE)
#' unlink(dir, recursive = TRUE)
delete_trailing_whitespace <- function(...) {
    files <- find_files(...)
    for (f in files) {
        lines <- readLines(f)
        lines <- sub("\\s+$", "", lines)
        writeLines(lines, f)
    }
    return(invisible(NULL))
}

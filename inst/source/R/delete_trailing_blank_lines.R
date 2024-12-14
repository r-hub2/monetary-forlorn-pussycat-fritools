#' Remove Trailing Blank Lines From Files
#'
#' Trailing blank lines are classical lints.
#' @param ... Arguments passed to \code{\link{find_files}}.
#' @family file utilities
#' @template return_invisibly_null
#' @export
#' @examples
#' dir <- tempfile()
#' dir.create(dir)
#' file.copy(system.file("runit_tests", package = "fritools"), dir,
#'           recursive = TRUE)
#' delete_trailing_blank_lines(path = dir, recursive = TRUE)
#' unlink(dir, recursive = TRUE)
delete_trailing_blank_lines <- function(...) {
    files <- find_files(...)
    for (f in files) {
        lines <- readLines(f)
        idx <- !grepl("^$", lines)
        idx[seq_len(max(which(idx == TRUE)))] <- TRUE
        lines <- lines[idx]
        writeLines(lines, f)
    }
    return(invisible(NULL))
}

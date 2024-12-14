#' Get the File Modified Last
#'
#' I often look for the  file modified last under some directory.
#' @param ... Arguments passed to \code{\link{find_files}}.
#' @return The path to the file last modified.
#' @family searching functions
#' @family file utilities
#' @export
#' @examples
#' for (suffix in c(".txt", ".ascii"))
#'     for (f in file.path(tempdir(), letters))
#'         touch(paste0(f, suffix))
#' list.files(tempdir())
#' file_modified_last(path = tempdir(), pattern = "\\.txt$")
#' dir.create(file.path(tempdir(), "new"))
#' touch(file.path(tempdir(), "new", "file.txt"))
#' file_modified_last(path = tempdir(), pattern = "\\.txt$")
#' file_modified_last(path = tempdir(), pattern = "\\.txt$", recursive = TRUE)
file_modified_last <- function(...) {
    lf <- find_files(...)
    mtime <- file.info(lf)["mtime"]
    i <- order(mtime[["mtime"]], decreasing = TRUE)[1]
    newest <- normalizePath(rownames(mtime)[i], mustWork = TRUE)
    return(newest)
}

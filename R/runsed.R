#' Replace a Pattern in Files with a Replacement String
#'
#' This function mimics the \command{runsed} script published in \cite{Unix
#' Power Tools}.
#' @param files A list of file names in which to replace.
#' @param pattern A regex pattern, see \code{\link{gsub}}.
#' @param replacement A string, see \code{\link{gsub}}.
#' @return \code{\link[base:invisible]{Invisibly}} the vector of names of files
#' changed.
#' @references
#' \cite{
#'   Shelley Powers, Jerry Peek, Tim O'Reilly and Mike Loukides, 2002,
#'   Unix Power Tools,
#'   3rd edition,
#'   O'Reilly Media, Inc.
#' }
#' @family file utilities
#' @family searching functions
#' @export
#' @examples
#' source_files <- list.files(system.file(package = "fritools", "source", "R"),
#'                            pattern = ".*\\.R$", full.names = TRUE)
#' file.copy(source_files, tempdir(), overwrite = TRUE)
#' files <- find_files(file_names = file.path(tempdir(),
#'                                            basename(source_files)))
#' print(f <- runsed(files, pattern = "_clean", replacement = "_cleanr"))
#' print(f <- runsed(files, pattern = "_cleanr\\>", replacement = "_cleaner"))
runsed <- function(files, pattern, replacement) {
    res <- find_files(file_names = files, find_all = TRUE)
    for (f in files) {
        before <- readLines(con = f)
        after <- gsub(pattern = pattern, replacement = replacement, x = before)
        if (identical(before, after)) {
            res <- res[!grepl(pattern = normalizePath(f, winslash = "/"),
                              x = normalizePath(res, winslash = "/"))]
        } else {
            writeLines(text = after, con = f)
        }
    }
    return(invisible(res))
}

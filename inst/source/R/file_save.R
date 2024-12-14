#' Create a Copies of  Files
#'
#' I often want a timestamped copies as backup of files or directories.
#' @param ... Paths to files.
#' @param file_extension_pattern A Pattern to mark a file extension. If matched,
#' the time stamp will get inserted before that pattern.
#' @param force Force even if \code{file_extension_pattern} is not matched. Set
#' to \code{\link{FALSE}} to skip stamping such files.
#' @param overwrite Passed to \code{\link{file.copy}}.
#' @param recursive Passed to \code{\link{file.copy}}. Defaults to `if the
#' current path is a directory, then TRUE, else FALSE`.
#' @template stop_on_error
#' @template return_boolean_vector
#' @family operating system functions
#' @family file utilities
#' @export
#' @examples
#' f1 <- tempfile()
#' f2 <- tempfile()
#' try(file_save(f1))
#' touch(f1)
#' file_save(f1, recursive = FALSE)
#' f2 <- paste0(file.path(tempfile()), ".txt")
#' touch(f2)
#' file_save(f1, f2)
#' file_save(f1, f2)
#' file_save(f1, f2, overwrite = TRUE)
#' dir(tempdir())
file_save <- function(..., file_extension_pattern = "\\.[A-z]{1,5}$",
                       force = TRUE, recursive = NA,
                       stop_on_error = TRUE, overwrite = FALSE) {
    l <- list(...)
    fep <- file_extension_pattern # sooth lintr
    res <- sapply(l, function(x) {
                      res <- .file_save(x = x,
                                        file_extension_pattern = fep,
                                        force = force,
                                        recursive = dir.exists(x),
                                        stop_on_error = stop_on_error,
                                        overwrite = overwrite)
                      return(res)
                       },
                      USE.NAMES = FALSE)
    return(res)
}

.file_save <- function(x, file_extension_pattern = "\\.[A-z]{1,5}$",
                       force = TRUE, recursive = dir.exists(x),
                       stop_on_error = TRUE, overwrite = FALSE) {
    res <- FALSE
    if (!file.exists(x)) {
        msg <- paste0("`", x, "` is not a path to a file.")
        if (isTRUE(stop_on_error)) {
            throw(msg)
        } else {
            warning(msg)
        }
    } else {
        if (grepl(file_extension_pattern, x)) {
            to <- sub(paste0("(", file_extension_pattern, ")"),
                      paste0(format(file.mtime(x), "_%Y_%m_%d_%H_%M_%S"),
                             "\\1"),
                      x)
            res <- file.copy(from = x, to = to, recursive = recursive,
                             overwrite = overwrite)
        } else {
            if (isTRUE(force)) {
                to <-  paste0(x, format(file.mtime(x), "_%Y_%m_%d_%H_%M_%S"))
                res <- file.copy(from = x, to = to, recursive = recursive,
                                 overwrite = overwrite)
            } else {
                warning("Set `force` to `TRUE` to force.")
            }
        }
    }
    return(res)
}

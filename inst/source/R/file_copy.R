#' Force Copying a File While backing it up
#'
#' \code{\link{file.copy}} has an argument \code{overwrite} that allows for
#' overwriting existing files. But I often want to overwrite an existing file
#' while creating a backup copy of that file.
#' @param from See \code{\link{file.copy}}.
#' @param to See \code{\link{file.copy}}.
#' @template stop_on_error
#' @param ... Arguments passed to \code{\link{file.copy}}.
#' @template return_boolean_vector
#' @family file utilities
#' @family operating system functions
#' @export
#' @examples
#' touch(f1 <- file.path(tempdir(), "first.R"),
#'       f2 <- file.path(tempdir(), "second.R"))
#' dir.create(t <- file.path(tempdir(), "foo"))
#' file_copy(from = c(f2, f1), to = t)
#' dir(t)
#' touch(f1)
#' touch(f2)
#' file_copy(from = c(f2, f1), to = t)
#' dir(t)
#' list.files(tempdir(), pattern = "first.*\\.R")
#' dir <- file.path(tempdir(), "subdir")
#' dir.create(dir)
#' file_copy(f1, dir)
#' touch(f1)
#' file_copy(f1, dir)
#' list.files(dir, pattern = "first.*\\.R")
file_copy <- function(from, to, stop_on_error = FALSE, ...) {
    if (length(to) == 1 && dir.exists(to)) {
        target <- file.path(to, basename(from))
    } else {
        target <- to
    }
    is_target_newer <- sapply(file.mtime(from) <= file.mtime(target), isTRUE)
    if (any(is_target_newer)) {
        msg <- paste0("`", target[is_target_newer], "` is newer than ", "`",
                      from[is_target_newer], "`, skipping.")
        if (isTRUE(stop_on_error)) {
            throw(msg)
        } else {
            warning(msg)
        }
    }
    is_target_exists <- file.exists(target)
    if (any(is_target_exists)) {
        do.call("file_save",
                # capture NA by sapply(..., isTRUE)
                as.list(target[sapply(is_target_exists & !is_target_newer,
                                      isTRUE)]))
    }

    res <- rep(FALSE, length(from))
    for (idx in seq(along = from)) {
        res[idx] <- file.copy(from = from[idx], to = target[idx],
                         overwrite = (is_target_exists & !is_target_newer)[idx],
                         recursive = (dir.exists(from)[idx]),
                         ...)
    }
    return(invisible(res))
}

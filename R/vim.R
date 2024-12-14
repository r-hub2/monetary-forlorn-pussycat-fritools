call_vim <- function(file, title = file) {
    # a function to be passed to options(editor)
    if (is_installed("gvim")) {
        vim <- "gvim"
    } else {
        if (is_installed("vim")) {
            vim <- "vim"
        } else {
            throw("Can't find gvim nor vim. Please install first.")
        }
    }
    system2(vim, args = c("-p", file))
}

#' Edit a File With '\command{VIM}' if Possible
#'
#' Just a wrapper to \code{\link{file.edit}}, trying to use [g]vim as editor, if
#' installed.
#' @param ... See \code{\link{file.edit}}.
#' @return See \code{\link{file.edit}}.
#' @export
#' @family operating system functions
#' @examples
#' if (interactive()) {
#'     path <- file.path(tempdir(), "foo.txt")
#'     writeLines(c("abc", "xyz"), con = path)
#'     vim(path)
#' }
vim <- function(...) {
    if (! interactive()) {
        warning("Editing files non-interactively.")
    }
    if (is_installed("vim")) old <- options(editor = call_vim)
    res <- utils::file.edit(...)
    if (exists("old", inherits =  FALSE)) options(old)
    return(res)
}

#' Copy a Path from Clipboard to '\R'
#'
#' I often have to work under Windows, where file paths cannot just be pasted
#' into the code, so I adapted code from
#' \url{https://www.r-bloggers.com/2015/12/stop-fiddling-
#' around-with-copied-paths-in-windows-r/}.
#' Under Windows, the de-windowsified path is copied to the clipboard.
#' @note It makes only sense to call \code{clipboard_path} in an interactive \R
#' session.
#' @return The de-windowsified path.
#' @export
#' @family operating system functions
#' @family file utilities
clipboard_path <- function() {
    if (interactive()) {
        scanned <- scan(file = "clipboard", what = "")
        if (is_windows()) {
            items <- unlist(strsplit(scanned, split = "\\\\"))
            value <- paste0("file.path(\"",
                            paste(items, collapse = "\", \""),
                            "\")")
            utils::writeClipboard(value)
            message("Copied `", value, "` to clipboard.")
        } else {
            items <- unlist(strsplit(scanned, split = "/"))
            value <- paste0("file.path('",
                            paste(items, collapse = "', '"),
                            "')")
            message(gsub("'", "\"", value))
        }
        res <-  do.call("file.path", as.list(items))
        if (!file.exists(res))
            warning("Are you sure you copied a path to the clipboard?",
                    "\nGot ", scanned)
        return(res)
    } else {
        throw("clipboard_path() needs an interactive R session.")
    }
}

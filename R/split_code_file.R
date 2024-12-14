#' Split a Code File Into Multiple Files
#'
#' I tend to find files with dozens of functions. They don't read well.
#' So I split a code file into multiple files each containing a single function.
#' @param file The code file to be split.
#' @param output_directory Where to create the new files.
#' @param encoding The encoding passed to \code{\link{source}}.
#' @param write_to_disk Set the output_directory to
#' \code{dirname(file)}? Just a shortcut.
#' @export
#' @return \code{\link[base:invisible]{Invisibly}} a vector of paths to the new
#' files.
#' @family file utilities
split_code_file <- function(file, output_directory = tempdir(),
                            encoding = getOption("encoding"),
                            write_to_disk = getOption("write_to_disk")) {
    status <- FALSE
    if (isTRUE(write_to_disk)) {
        output_directory <- dirname(file)
    } else {
        dir.create(output_directory, recursive = TRUE, showWarnings = FALSE)
    }
    e <- new.env()
    source(file, local = e, echo = FALSE, keep.source = TRUE,
           encoding = encoding)
    content <- readLines(file, encoding = encoding)
    funs <- NULL
    names <- ls(e, all.names = TRUE)
    for (name in names) {
        if (is.function(e[[name]])) {
            funs <- rbind(funs,
                          position_in_content(content = content, name = name,
                                              envir = e))
        }
    }
    if (! 1 %in% funs[["start_index"]]) {
        msg <- paste0("There is a header at the top of file ", file, "!")
        warning(msg)
    }
    function_files <- NULL
    for (i in seq_len(nrow(funs))) {
        function_file <- file.path(output_directory,
                                   paste0(funs[i, "name"], ".R"))
        writeLines(content[funs[i, "start_index"]:funs[i, "stop_index"]],
                   function_file)
        function_files <- c(function_files, function_file)
    }
    if (isTRUE(write_to_disk)) {
        unlink(file)
    }
    status <- function_files
    return(invisible(status))
}

position_in_content <- function(name, content, envir = environment()) {
    index <- grep(name, content)
    comment_index <- grep(" *#", content)
    if (length(index) > 1) {
        index <- grep(paste0("^", name), content)
        if (length(index) > 1) {
            index <- grep(paste0("^", name, " *<-"), content)
        }
        if (length(index) > 1) {
            stop(paste("Found lines", content[index]))
        }
    }
    if (length(comment_index) > 0) {
        ci <- comment_index - index
        ci <- rev(-ci[ci < 0])
        ref <- seq(along = ci)
        intercept <- sum(ci == ref)
        start_index <- index - intercept
    } else {
        start_index <- index
    }
    body <- utils::capture.output(envir[[name]])
    body <- body[!grepl("^<environment:", body)]
    is_inline_func_def <- grepl("function\\(", content[index])
    stop_index <- index + length(body) - as.numeric(is_inline_func_def)
    result <- data.frame(name, start_index, index, stop_index)
    return(result)
}

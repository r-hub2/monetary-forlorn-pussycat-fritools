#' Search Files for a Pattern
#'
#' This is an approximation of \kbd{unix} \command{find} and \command{grep}.
#' @param what A regex pattern for which to search.
#' @param verbose Be verbose?
#' @param exclude A regular expression for excluding files.
#' @param ... Arguments passed to \code{\link{list.files}}.
#' @export
#' @return \link[base:invisible]{Invisibly} a vector of names of files
#' containing the pattern given by \code{what}.
#' @family searching functions
#' @family file utilities
#' @examples
#' write.csv(mtcars, file.path(tempdir(), "mtcars.csv"))
#'  for (i in 0:9) {
#'      write.csv(iris, file.path(tempdir(), paste0("iris", i, ".csv")))
#'  }
#' search_files(what = "Mazda", path = tempdir(), pattern = "^.*\\.csv$")
#' search_files(what = "[Ss]etosa", path = tempdir(), pattern = "^.*\\.csv$")
#' x <- search_files(path = tempdir(),
#'                   pattern = "^.*\\.csv$",
#'                   exclude = "[2-9]\\.csv$",
#'                   what = "[Ss]etosa")
#' summary(x)
#' summary(x, type = "what")
#' summary(x, type = "matches")
#' try(search_files(what = "ABC", path = tempdir(), pattern = "^.*\\.csv$"))
search_files <- function(what, verbose = TRUE, exclude = NULL, ...) {
    files <- list.files(..., full.names = TRUE)
    if (! is.null(exclude))
        files <- grep(pattern = exclude, x = files, value = TRUE, invert = TRUE)
    res <- NULL
    for (file in files) {
        lines <- suppressWarnings(readLines(file))
        hits <- suppressWarnings(grepl(lines, pattern = what))
        matches <- suppressWarnings(grep(lines, pattern = what, value = TRUE))
        if (any(hits)) {
            if (isTRUE(verbose)) message("Found `", what, "` in file ", file)
            tmp <- cbind(file, what, matches)
            res <- rbind(res, tmp)
        }
    }
    if (is.null(res)) {
        throw(paste("Pattern", what, "not found."))
    } else {
        res <- as.data.frame(res)
        class(res) <- c("filesearch", class(res))
        return(invisible(res))
    }

}

#' Summarize File Searches
#'
#' A custom summary function for objects returned by \code{\link{search_files}}.
#' @param object An object returned by \code{\link{search_files}}.
#' @param type Type of summary.
#' @param ... Needed for compatibility.
#' @export
#' @return A summarized object.
#' @family searching functions
#' @inherit search_files examples
summary.filesearch <- function(object, ...,
                               type = c("file", "what", "matches")) {
    if (!inherits(object, "filesearch"))
        throw("object is not of class `filesearch`.")
    type <- match.arg(type)
    r <- switch(type,
           "file" = {
               unique(object[type])
           },
           "what" = {
               unique(object[TRUE, c("file", "what")])
           },
           "matches" = {
               object[TRUE, c("file", "matches")]
           })
    return(r)
}

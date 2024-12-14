#' Grep a Pattern from Files
#'
#' This is an approximation of the \kbd{unix} command \command{grep}.
#' @param paths A vector of file paths.
#' @param pattern The pattern to grep.
#' @param b Number of lines of leading context before matching lines.
#' Like \command{grep}'s -B option.
#' @param a Number of lines of trailing context before matching lines.
#' Like \command{grep}'s -A option.
#' @param ... Arguments passed to \code{\link{list.files}}.
#' @export
#' @return A named list with one item per file path.
#' Each item consists of a list of row numbers matching the pattern. Each item
#' is a vector of the matching lines and \bold{b} lines before and \bold{a}
#' lines after the matching lines.
#' @family searching functions
#' @family file utilities
#' @examples
#' file_paths <- list.files(path = system.file("tinytest",
#'                                             package = "fritools"),
#'                          pattern = ".*\\.R", full.names = TRUE)
#' res <- grep_file(path = file_paths, pattern = "forSureNotThere",
#'                  a = 3, b = 2, ignore.case = TRUE)
#' tinytest::expect_true(all(res == FALSE))
grep_file <- function(paths, pattern, a = 1, b = 1, ...) {
    stopifnot(a > -1)
    stopifnot(b > -1)
    res <- lapply(paths, function(path) {
                      lines <- readLines(path)
                      hits <- suppressWarnings(grep(pattern, lines, ...))
                      ranges <- sapply(hits,
                                       function(x) {
                                           c(max(x - b, 1),
                                             min(x + a, length(lines)))
                                       }
                                       )
                      ranges <- as.list(as.data.frame(ranges))
                      res <- lapply(ranges,
                                    function(x) lines[seq.int(x[1], x[2])])
                      names(res) <- hits
                      if (fritools::is_of_length_zero(res)) res <- FALSE
                      return(res)
           }
           )
    names(res) <- paths
    return(res)
}

#' Develop Unit Testing for a Code File
#'
#' Looking at the output of
#' \code{\link[covr:zero_coverage]{covr::zero_coverage}}, I want to open a code
#' file an the corresponding unit testing file.
#' @param file The path to the code file, assuming the working directory to be
#' the root of an R package under development.
#' @param force_runit If there is no corresponding \pkg{RUnit} test file:
#' create one?
#' @param force_tiny If there is no corresponding \pkg{tinytest} test file:
#' create one?
#' @template return_invisibly_null
#' @export
#' @family test_helpers
#' @family file utilities
#' @examples
#' \dontrun{
#'     develop_test(file = "R/develop_test.R", force_runit = TRUE)
#'     unlink("inst/tinytest/test_develop_test.R")
#'     unlink("inst/runit_tests/runit-develop_test.R")
#' }
develop_test <- function(file, force_runit = FALSE, force_tiny = TRUE) {
    if (!file.exists(file)) stop("No such file: ", file)
    files <- list("source" = file)
    func <- sub("\\.[Rr]", "", basename(file))
    runit_file <- file.path("inst", "runit_tests",
                            paste0("runit-", basename(file)))
    if (file.exists(runit_file)) {
        files[["runit"]] <- runit_file
    } else {
        if (isTRUE(force_runit)) {
            code <- readLines(system.file("templates", "runit.R",
                                          package = "fritools"))
            writeLines(gsub("(_|\\<)FUNCTION\\>", paste0("\\1", func), code),
                       sep = "\n", con = runit_file)
            files[["runit"]] <- runit_file
        }
    }
    tiny_file <- file.path("inst", "tinytest",
                            paste0("test_", basename(file)))
    if (file.exists(tiny_file)) {
        files[["tinytest"]] <- tiny_file
    } else {
        if (isTRUE(force_tiny)) {
            code <- readLines(system.file("templates", "tinytest.R",
                                          package = "fritools"))
            writeLines(gsub("(_|\\<)FUNCTION\\>", paste0("\\1", func), code),
                       sep = "\n", con = tiny_file)
            files[["tinytest"]] <- tiny_file
        }
    }
    do.call(vim, files)
    return(invisible(NULL))
}

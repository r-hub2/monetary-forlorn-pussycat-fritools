if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


f <- function() {
  a <- FALSE
  return(is_not_false(a))
}
result <- f()
expectation <- FALSE
expect_identical(result, expectation)

a <- NULL
result <- is_not_false(a)
expectation <- FALSE
expect_identical(result, expectation)

if (FALSE) {
    result <- is_not_false(a, null_is_false = FALSE)
    expectation <- TRUE
    # TODO: does not work in batch?!
    if (interactive())
        expect_identical(result, expectation)

    a  <- "not_false"
    # finds a in parent.frame()
    f <- function() {
        return(is_not_false(a))
    }
    result <- f()
    expectation <- TRUE
    # TODO: does not work in batch?!
    if (interactive())
        expect_identical(result, expectation)
}
# suppress search in parent.frame()
f <- function() {
  return(is_not_false(a,
    null_is_false = TRUE,
    inherits = FALSE
  ))
}
result <- f()
expectation <- FALSE
expect_identical(result, expectation)






expectation <- TRUE
result <- is_false(FALSE)
expect_identical(result, expectation)






expectation <- TRUE
result <- is_null_or_true(TRUE)
result <- is_null_or_true(NULL)
expect_identical(result, expectation)

expectation <- FALSE
result <- is_null_or_true(FALSE)
expect_identical(result, expectation)
result <- is_null_or_true("not true")
expect_identical(result, expectation)

if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


result <- is_success(0)
expectation <- TRUE
expect_identical(result, expectation)
result <- is_success(-1)
expectation <- FALSE
expect_identical(result, expectation)

if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


result <- is_windows()
expectation <- checkmate::test_os("windows")
expect_identical(result, expectation)

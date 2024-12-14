if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}

if (run_r_tests_for_known_hosts()) {
  expectation <- normalizePath(tempdir(), mustWork = FALSE)
  result <- normalizePath(with_dir(expectation, getwd()))

  expect_identical(expectation, result)
}
if (interactive()) {

}

if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


result <- is_version_sufficient(installed = "1.0.0", required = "2.0.0")
expect_identical(result, FALSE)
result <- is_version_sufficient(installed = "1.0.0", required = "1.0.0")
expect_identical(result, TRUE)
result <- is_version_sufficient(installed = "1.0.1", required = "1.0.0")
expect_identical(result, TRUE)

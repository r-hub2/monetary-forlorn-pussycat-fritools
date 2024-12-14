if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


result <- call_conditionally(get_package_version,
  condition = TRUE,
  args = list(x = "fritools"),
  fallback = "0.0"
)
expectation <- get_package_version("fritools")
expect_identical(result, expectation)
call_conditionally(get_package_version,
  condition = FALSE,
  args = list(x = "fritools"),
  fallback = "0.0"
)
result <- call_conditionally(get_package_version,
  condition = FALSE,
  args = list(x = "fritools"),
  fallback = "0.0"
)
expectation <- "0.0"
expect_identical(result, expectation)
result <- call_conditionally(get_package_version,
  condition = TRUE,
  args = list(x = "not_there"),
  harden = TRUE,
  fallback = "-1"
)
expectation <- "-1"
expect_identical(result, expectation)

expect_error(call_conditionally(get_package_version,
  condition = TRUE,
  args = list(x = "not_there"),
  harden = FALSE,
  fallback = "-1"
))

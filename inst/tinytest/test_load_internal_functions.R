if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


load_internal_functions("fritools")
result <- environmentName(environment(throw))
expectation <- "fritools"
expect_identical(result, expectation)

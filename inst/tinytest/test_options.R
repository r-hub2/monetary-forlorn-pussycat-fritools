if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


options("fritools" = NULL)
expect_identical(get_options(package_name = "fritools"), NULL)
set_options(package_name = "fritools", max_file_width = 100)
expect_identical(
  get_options(package_name = "fritools"),
  structure(c("max_file_width" = 100),
    package = "fritools"
  )
)
expect_identical(
  get_options(
    package_name = "fritools",
    flatten_list = FALSE
  ),
  structure(c("max_file_width" = 100),
    package = "fritools"
  )
)
expect_identical(
  get_options(
    package_name = "fritools",
    "max_file_width"
  ),
  structure(c("max_file_width" = 100),
    package = "fritools"
  )
)
expect_identical(
  get_options(
    package_name = "fritools",
    "max_file_width",
    flatten_list = FALSE
  ),
  structure(c("max_file_width" = 100),
    package = "fritools"
  )
)
expect_identical(get_options(
  package_name = "fritools",
  "max_file_width",
  remove_names = TRUE
), structure(c(100),
  package = "fritools"
))
expect_identical(get_options(
  package_name = "fritools",
  "max_file_width",
  remove_names = TRUE,
  flatten_list = FALSE
), structure(c(100),
  package = "fritools"
))

set_options(package_name = "fritools", list(
  max_lines = 30,
  max_lines_of_code = 20
))
result <- get_options(package_name = "fritools")
expectation <- structure(c(
  max_file_width = 100, max_lines = 30,
  max_lines_of_code = 20
), package = "fritools")
expect_identical(result, expectation)

set_options(
  package_name = "fritools", list(
    max_lines = 0,
    max_lines_of_code = 0
  ),
  overwrite = FALSE
)
result <- get_options(package_name = "fritools") ## didn't change anything
expect_identical(result, expectation)

set_options(
  package_name = "fritools", list(
    max_lines = 0,
    max_lines_of_code = 0
  ),
  overwrite = TRUE
)
result <- get_options(
  package_name = "fritools", flatten_list = FALSE,
  remove_names = TRUE
)
expectation <- structure(list(100, 0, 0), package = "fritools")
expect_identical(result, expectation)



set_options(
  package_name = "fritools", list(
    max_lines = 0,
    max_lines_of_code = 0,
    max_nesting_depth = 3
  ),
  overwrite = FALSE
)
result <- get_options(package_name = "fritools")
expectation <- structure(c(
  max_file_width = 100, max_lines = 0,
  max_lines_of_code = 0,
  max_nesting_depth = 3
), package = "fritools")
expect_identical(result, expectation)




options("fritools" = NULL)
expectation <- TRUE
result <- is_force("fritools")
expect_identical(result, expectation)
set_options(package_name = "fritools", force = TRUE)
result <- is_force("fritools")
expect_identical(result, expectation)

expectation <- FALSE
set_options(
  package_name = "fritools", list(force = "not true"),
  overwrite = TRUE
)
result <- is_force("fritools")
expect_identical(result, expectation)





options("fritools" = NULL)
expectation <- structure(c(force = TRUE), package = "fritools")
set_options(force = TRUE)
result <- get_options()
expect_identical(result, expectation)

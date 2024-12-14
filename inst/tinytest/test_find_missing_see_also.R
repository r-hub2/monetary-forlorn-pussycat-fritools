if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


path <- system.file("source", package = "fritools")
result <- basename(find_missing_see_also(path, list_families = FALSE))
expectation <- "fritools-package.Rd"
expect_identical(result, expectation)

result <- capture.output(find_missing_see_also(path, list_families = TRUE),
  type = "message"
)

expect_true("Families so far: " %in% result &&
  any(grepl("^Other", result)))
result <- is_of_length_zero(find_missing_family(path,
  list_families = FALSE
),
class = "character"
)
expect_true(result)

result <- capture.output(find_missing_family(path, list_families = TRUE),
  type = "message"
)
expect_true("Families so far: " %in% result &&
  any(grepl("^#' @family", result)))

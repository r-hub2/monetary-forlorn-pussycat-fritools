if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}
if (fritools::is_version_sufficient(
  fritools::get_package_version("base"),
  "4.0.0"
)) {
  if (interactive()) pkgload::load_all(".")

  unlink(dir(tempdir(), full.names = TRUE))
  path <- tempdir()
  data(mtcars)
  data(iris)
  write.csv(mtcars, file.path(path, "mtcars.csv"))
  for (i in 0:9) {
    write.csv(iris, file.path(path, paste0("iris", i, ".csv")))
  }
  expect_error(search_files(
    what = "FOO", path = path,
    verbose = FALSE,
    pattern = ".*\\.csv$"
  ))
  expect_error(summary.filesearch("foo"))
  found <- search_files(
    what = "Mazda", path = path, verbose = FALSE,
    pattern = ".*\\.csv$"
  )
  result <- as.character(summary(found))
  expectation <- file.path(path, "mtcars.csv")
  expect_identical(result, expectation)
  search_pattern <- "5\\.3"
  found <- search_files(
    what = search_pattern, path = path,
    pattern = "iris.*\\.csv$",
    exclude = ".*[2-9]\\.csv",
    verbose = FALSE
  )
  result <- strip_off_attributes(unlist(summary(object = found)))
  expectation <- file.path(path, paste0("iris", 0:1, ".csv"))
  expect_identical(result, expectation)
  result <- strip_off_attributes(unlist(summary(
    object = found,
    type = "file"
  )))
  expectation <- file.path(path, paste0("iris", 0:1, ".csv"))
  expect_identical(result, expectation)
  result <- summary(object = found, type = "what")
  expectation <- data.frame(
    file = file.path(
      path,
      paste0("iris", 0:1, ".csv")
    ),
    what = search_pattern
  )
  expect_identical(
    strip_off_attributes(result),
    strip_off_attributes(expectation)
  )
  result <- summary(object = found, type = "matches")
  expectation <-
    structure(list(
      file = rep(file.path(path, paste0(
        "iris", 0:1,
        ".csv"
      )),
      each = 3
      ),
      matches = c(
        "\"49\",5.3,3.7,1.5,0.2,\"setosa\"",
        "\"112\",6.4,2.7,5.3,1.9,\"virginica\"",
        "\"116\",6.4,3.2,5.3,2.3,\"virginica\"",
        "\"49\",5.3,3.7,1.5,0.2,\"setosa\"",
        "\"112\",6.4,2.7,5.3,1.9,\"virginica\"",
        "\"116\",6.4,3.2,5.3,2.3,\"virginica\""
      )
    ),
    row.names = c(NA, 6L),
    class = c("filesearch", "data.frame")
    )
  expect_identical(result, expectation)
}
if (interactive()) {

}

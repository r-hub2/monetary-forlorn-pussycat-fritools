if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}
if (fritools::is_version_sufficient(
  fritools::get_package_version("base"),
  "4.0.0"
)) {
  if (interactive()) pkgload::load_all(".")

  data(mtcars)
  p <- "\\<4.0[[:alpha:]]*\\>"
  expectation <- structure(list(
    mpg = c(
      16.4, 17.3, 15.2, 10.4, 14.7,
      19.2
    ),
    cyl = c(8, 8, 8, 8, 8, 8),
    disp = c(
      275.8, 275.8, 275.8, 460, 440,
      400
    ),
    hp = c(180, 180, 180, 215, 230, 175),
    drat = c(3.07, 3.07, 3.07, 3, 3.23, 3.08),
    wt = c(
      4.07, 3.73, 3.78, 5.424, 5.345,
      3.845
    ),
    qsec = c(
      17.4, 17.6, 18, 17.82, 17.42,
      17.05
    ),
    vs = c(0, 0, 0, 0, 0, 0),
    am = c(0, 0, 0, 0, 0, 0),
    gear = c(3, 3, 3, 3, 3, 3),
    carb = c(3, 3, 3, 4, 4, 2)
  ),
  row.names = c(
    "Merc 450SE", "Merc 450SL",
    "Merc 450SLC",
    "Lincoln Continental",
    "Chrysler Imperial",
    "Pontiac Firebird"
  ),
  class = "data.frame"
  )
  result <- search_rows(x = mtcars, pattern = p)
  expect_identical(result, expectation)
  expectation <- structure(list(
    mpg = c(10.4, 14.7, 19.2),
    cyl = c(8, 8, 8),
    disp = c(460, 440, 400),
    hp = c(215, 230, 175),
    drat = c(3, 3.23, 3.08),
    wt = c(5.424, 5.345, 3.845),
    qsec = c(17.82, 17.42, 17.05),
    vs = c(0, 0, 0),
    am = c(0, 0, 0),
    gear = c(3, 3, 3),
    carb = c(4, 4, 2)
  ),
  row.names = c(
    "Lincoln Continental",
    "Chrysler Imperial",
    "Pontiac Firebird"
  ),
  class = "data.frame"
  )
  result <- search_rows(
    x = mtcars, pattern = p,
    include_row_names = FALSE
  )
  expect_identical(result, expectation)
  expect_error(search_rows(x = mtcars, pattern = "ABC"))
}
if (interactive()) {

}

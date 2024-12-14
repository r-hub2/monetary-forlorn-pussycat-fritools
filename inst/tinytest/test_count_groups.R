if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


result <- count_groups(mtcars, "am", "gear")
expectation <- structure(list(
  am = c(0, 0, 1, 1),
  gear = c(3, 4, 4, 5),
  count = c(15L, 4L, 8L, 5L)
),
row.names = c(NA, -4L), class = "data.frame"
)
expect_identical(result, expectation)

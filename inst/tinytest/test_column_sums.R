if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


result <- column_sums(iris)
expectation <- c(
  Sepal.Length = 876.5, Sepal.Width = 458.6,
  Petal.Length = 563.7, Petal.Width = 179.9
)
expect_equal(result, expectation, tolerance = 1e-3)

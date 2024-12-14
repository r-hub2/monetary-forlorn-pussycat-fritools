if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


wt <- c(5, 5, 4, 1) / 15
x <- c(3.7, 3.3, 3.5, 2.8)
expectation <- var(x)
result <- weighted_variance(x = x)
expect_identical(result, expectation)
expectation <- 0.0571555555555556
result <- weighted_variance(x = x, weights = wt)
expect_equal(result, expectation)
result <- weighted_variance(x = x, weights = wt, weights_counts = TRUE)
expect_equal(result, Inf)









result <- fritools::tapply(
  object = mtcars, index = list(
    mtcars[["cyl"]],
    mtcars[["vs"]]
  ),
  func = weighted_variance, var = "mpg", w = "wt",
  weights_counts = FALSE
)
expectation <- structure(c(
  NA, 0.376572372584046, 6.83915727277488,
  19.1830134992249, 1.94117209543316, NA
),
.Dim = 3:2,
.Dimnames = list(c("4", "6", "8"), c("0", "1"))
)
expect_equal(result, expectation)

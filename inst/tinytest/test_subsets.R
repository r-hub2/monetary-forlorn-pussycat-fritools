if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


# % regular
result <- subset_sizes(n = 100, k = 6)
expectation <- c(17, 17, 17, 17, 16, 16)
expect_identical(result, expectation)
# % symmetric
result <- subset_sizes(n = 10, k = 5)
expectation <- rep(2, 5)
expect_identical(result, expectation)

# % k too big
## % check the warning
result <- tryCatch(subset_sizes(n = 2, k = 6),
  warning = function(w) {
    return(w)
  }
)
expectation <- tryCatch(
  {
    msg <- "Got k > n, this will result in subsizes of 1 and 0."
    warning(msg)
  },
  warning = function(w) {
    return(w)
  }
)
expect_identical(result[["message"]], expectation[["message"]])
## % check the result
result <- suppressWarnings(subset_sizes(n = 2, k = 6))
expectation <- c(1, 1, 0, 0, 0, 0)
expect_identical(result, expectation)

# % n too small
expect_error(subset_sizes(n = 1, k = 6))





result <- index_groups(n = 10, k = 3)
expectation <- structure(c(1, 2, 3, 1, 5, 8, 4, 3, 3, 4, 7, 10),
  .Dim = 3:4,
  .Dimnames = list(
    NULL,
    c("id", "start", "sizes", "stop")
  )
)
expect_identical(result, expectation)

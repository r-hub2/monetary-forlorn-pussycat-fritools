if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


result <- str2num("1.000.000,11")
expectation <- 1e06 + 0.11
expect_equal(result, expectation)
result <- str2num("not_a_number")
expect_true(is.na(result))

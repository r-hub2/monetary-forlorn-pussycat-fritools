if (interactive()) {
    pkgload::load_all()
    library("tinytest")
}

expectation <- 31.2160691238646
result <- sloboda(a = 0.9, b = 0.02, c = 3, y0 = 30, t0 = 30, t = 35, k = 65)
expect_equal(result, expectation)
result <- sloboda(a = 0.9, b = 0.02, c = 3, y0 = 30, t0 = 30, t = 35, k = 65, type = "kaendler")
expect_equal(result, expectation)

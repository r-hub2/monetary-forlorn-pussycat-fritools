if (interactive()) {
    pkgload::load_all()
    library("tinytest")
}

expectation <- structure(1:4, levels = c("beech", "oak", "spruce", "fir"), class = "factor")
x <- c("beech", "oak", "spruce", "fir")
result <- char2factor(x)
expect_identical(result, expectation)

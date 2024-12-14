if (interactive()) {
    pkgload::load_all()
    library("tinytest")
}

expectation <- FIXME
result <- FUNCTION(FIXME)
expect_identical(result, expectation)

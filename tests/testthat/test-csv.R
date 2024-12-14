if (interactive()) pkgload::load_all()
testthat::test_that("foo", {
    unlink(dir(tempdir(), full.names = TRUE))
    f <- file.path(tempdir(), paste0("a", ".csv"))
    cars <- mtcars[1:2, TRUE]
    a <- write_csv(cars, file = f)
    testthat::expect_true(file.exists(f))
    testthat::expect_identical(strip_off_attributes(get_path(a)), f)
    p <- get_path(a)
    g <- paste0(f, "g")
    testthat::expect_failure(testthat::expect_identical(strip_off_attributes(p),
                                                        g))
}
)

testthat::test_that("throw the fritools exception", {
                        error_message <- "hello, testthat"
                        string <- "hello, testthat"
                        testthat::expect_error(fritools:::throw(string),
                            error_message)
}
)

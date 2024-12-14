if (interactive()) {
    pkgload::load_all()
    library("tinytest")
}
expectation <- structure(list(model = c("Mazda RX4", "Mazda RX4 Wag"), mpg = c(21, 
21), cyl = c(6, 6)), class = "data.frame", row.names = c(NA, 
-2L))
x <- mtcars[1:2, 1:2]
result <- rownames2col(x, "model")
expect_identical(result, expectation)

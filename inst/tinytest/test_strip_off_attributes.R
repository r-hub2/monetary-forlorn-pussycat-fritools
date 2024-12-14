if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


x <- 1:3
y <- stats::setNames(x, letters[1:3])
attr(y, "myattr") <- "qwer"
comment(y) <- "qwer"
expect_identical(x, strip_off_attributes(y))

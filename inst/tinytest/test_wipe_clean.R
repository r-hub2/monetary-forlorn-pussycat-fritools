if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


e <- new.env()
assign("a", 1, envir = e)
expect_identical(ls(envir = e), "a")
result <- wipe_clean(envir = e)
expectation <- "a"
expect_identical(result, expectation)
expect_identical(length(ls(envir = e)), 0L)

if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}

if (get_run_r_tests() && !fritools::is_windows()) {
  e <- new.env()
  assign("va", rep(mtcars, 1), envir = e)
  assign("vb", rep(mtcars, 1000), envir = e)
  assign("vc", rep(mtcars, 2000), envir = e)
  assign("vd", rep(mtcars, 100), envir = e)
  result <- memory_hogs(envir = e)
  expectation <- structure(c(
    va = 4424, vd = 352824, vb = 3520824,
    vc = 7040824
  ), units = "bytes")
  expect_true(all(expectation %in% result))
  result <- memory_hogs(unit = "Mb", decreasing = TRUE, envir = e)
  expectation <- structure(c(
    vc = 6.7, vb = 3.4, vd = 0.3,
    expectation = 0, result = 0, va = 0
  ),
  units = "Mb"
  )
  expect_true(all(expectation %in% result))
  expect_true(all(c("va", "vb", "vc", "vd") %in% ls(envir = e)))
  # see if we can remove some objects
  rm(
    list = names(tail(memory_hogs(decreasing = FALSE, envir = e),
      n = 2
    )),
    envir = e
  )
  expect_true(all(c("va", "vd") %in% ls(envir = e)))
  expect_true(all(!c("vb", "vc") %in% ls(envir = e)))
  # check for character output
  result <- memory_hogs(envir = e, return_numeric = FALSE)
  expectation <- c(va = "4424 bytes", vd = "352824 bytes")
  expect_true(all(expectation %in% result))
}
if (interactive()) {
  rm(list = ls(pattern = "v[a-d]"))
}

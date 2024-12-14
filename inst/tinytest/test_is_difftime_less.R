if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


a <- as.POSIXct(0, origin = "1970-01-01", tz = "GMT")
b <- as.POSIXct(60 * 60 * 24, origin = "1970-01-01", tz = "GMT")
c <- as.POSIXct(60 * 60 * 24 - 1, origin = "1970-01-01", tz = "GMT")
expect_true(!is_difftime_less(a, b, verbose = TRUE))
expect_true(is_difftime_less(a, c, verbose = TRUE))
expect_error(is_difftime_less(a, b,
  verbose = TRUE,
  stop_on_error = TRUE
))
expect_true(is_difftime_less(a, c,
  verbose = TRUE,
  stop_on_error = TRUE
))

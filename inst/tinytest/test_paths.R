if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


x <- 3
# no path set
expect_error(get_path(x))
# path is a directory
expect_error(set_path(x, tempdir()))
# path does not exists
expect_error(set_path(x, tempfile()))
# externally set path
attr(x, "path") <- tempdir()
# path is a directory
expect_error(get_path(x))
# create a file
tempfile <- tempfile()
touch(tempfile)
# path already set
expect_error(set_path(x, tempfile()))
# overwrite
x <- set_path(x, tempfile, overwrite = TRUE)
result <- get_path(x)
expect_identical(strip_off_attributes(result), tempfile)
# csv
a <- write_csv(mtcars, tempfile)
expect_identical(get_mtime(a), file.mtime(tempfile))
# change something
a[1, 1] <- 0.0
a <- write_csv(a)
expect_identical(get_mtime(a), file.mtime(get_path(a)))
# wrong path set
attr(x, "path") <- tempfile()
expect_error(get_path(x))







x <- mtcars
expect_error(get_mtime(x))
tempfile <- tempfile()
touch(tempfile)
x <- set_path(x, tempfile)
expect_true(file.mtime(tempfile) == get_mtime(x))
expect_true(is(get_mtime(x), "POSIXt"))
result <- get_path(x)
expect_true(is_path(result))
expect_true(is(attr(result, "mtime"), "POSIXt"))
expect_true(is.na(attr(result, "last_read")))
expect_true(is.na(attr(result, "last_written")))
Sys.sleep(1)
touch(tempfile)
expect_true(file.mtime(tempfile) > get_mtime(x))
Sys.sleep(1)
if (!is_cran() && !is_windows()) {
  # TODO: Check fails on CRAN Windows, but that seems strange.
  x <- write_csv(x)
  expect_identical(file.mtime(tempfile), get_mtime(x))
  expect_equal(
    get_mtime(x),
    attr(get_path(x), "last_written"),
    tolerance = 0.1
  )
  expect_true(is.na(attr(result, "last_read")))
  Sys.sleep(1)
  y <- read_csv(tempfile)
  expect_true(get_mtime(y) < attr(get_path(y), "last_read"))
  expect_true(is.na(attr(get_path(y), "last_written")))
  # Now we change it:
  y[1, 2] <- y[1, 2] + 1
  Sys.sleep(1)
  y <- write_csv(y)
  expect_equal(
    get_mtime(x),
    attr(get_path(x), "last_written"),
    tolerance = 0.1
  )
  # Now this is ... a feature: it hasn't changed on disc,
  # because the content doesn't change:
  Sys.sleep(1)
  y <- write_csv(y)
  expect_true(get_mtime(y) < attr(get_path(y), "last_written"))
}

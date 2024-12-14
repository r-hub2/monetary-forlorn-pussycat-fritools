if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}

unlink(dir(tempdir(), full.names = TRUE))
f <- file.path(tempdir(), paste0("a", ".csv"))
cars <- mtcars[1:2, TRUE]
a <- write_csv(cars, file = f)
expect_true(file.exists(f))
expect_identical(strip_off_attributes(get_path(a)), f)

# % get_path
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
result <- strip_off_attributes(get_path(x))
expect_identical(result, tempfile)

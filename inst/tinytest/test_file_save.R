if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


f <- file.path(tempfile())
expect_identical(file_save(f, stop_on_error = FALSE), FALSE)
expect_error(file_save(f))
touch(f)
expect_identical(file_save(f, force = FALSE), FALSE)
expect_identical(length(dir(dirname(f), pattern = basename(f))), 1L)
file_save(f, recursive = FALSE)
expect_identical(length(dir(dirname(f), pattern = basename(f))), 2L)
f1 <- paste0(f, ".txt")
touch(f1)
expect_identical(length(dir(dirname(f), pattern = basename(f))), 3L)
file_save(f1)
expect_identical(length(dir(dirname(f), pattern = basename(f))), 4L)
# now both files already exist
expect_true(any(file_save(f, f1), overwrite = TRUE))
expect_true(!any(file_save(f, f1)))

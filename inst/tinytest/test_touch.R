if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


file1 <- tempfile()
file2 <- tempfile()
touch(file1, file2)
t1 <- file.mtime(file1, file2)
touch(file2)
t2 <- file.mtime(file1, file2)
expect_identical(t1 < t2, c(FALSE, TRUE))
file <- file.path(tempfile(), "path", "not", "there.txt")
touch(file)
expect_true(file.exists(file))





file1 <- tempfile()
file2 <- tempfile()
touch2(file1, file2)
t1 <- file.mtime(file1, file2)
touch2(file2)
t2 <- file.mtime(file1, file2)
expect_identical(t1 < t2, c(FALSE, TRUE))
file <- file.path(tempfile(), "path", "not", "there.txt")
touch2(file)
expect_true(file.exists(file))

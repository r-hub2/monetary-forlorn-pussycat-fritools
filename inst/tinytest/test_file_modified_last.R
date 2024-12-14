if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


dir.create(file.path(tempdir(), "new"))
touch(file.path(tempdir(), "file1.txt"))
Sys.sleep(2)
touch(file.path(tempdir(), "file2.txt"))
Sys.sleep(2)
touch(file.path(tempdir(), "new", "file3.txt"))
expectation <- "file2.txt"
found <- file_modified_last(path = tempdir(), pattern = "file.\\.txt$")
result <- basename(found)
expect_identical(expectation, result)
expectation <- "file3.txt"
found <- file_modified_last(
  path = tempdir(), pattern = "file.\\.txt$",
  recursive = TRUE
)
result <- basename(found)
expect_identical(expectation, result)

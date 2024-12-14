if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


template <- system.file("files", "blanks.txt", package = "fritools")
input <- tempfile()
file.copy(template, input)
delete_trailing_blank_lines(file_names = input)
result <- readLines(input)
template <- readLines(template)
expect_identical(length(result), as.integer(length(template) - 2))

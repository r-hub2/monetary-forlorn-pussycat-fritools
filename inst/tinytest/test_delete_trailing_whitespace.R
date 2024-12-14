if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


template <- system.file("files", "blanks.txt", package = "fritools")
input <- tempfile()
file.copy(template, input)
delete_trailing_whitespace(file_names = input)
result <- readLines(input)
template <- readLines(template)
expect_identical(
  nchar(result),
  as.integer(nchar(template) - c(2, 0, 0, 0))
)

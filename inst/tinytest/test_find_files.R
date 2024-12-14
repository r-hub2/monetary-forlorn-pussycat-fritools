if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


# % create some files
temp_dir <- tempfile()
if (interactive()) unlink(temp_dir, recursive = TRUE)
path <- file.path(temp_dir, "foo")
dir.create(path, recursive = TRUE)
files <- sort(unname(sapply(
  file.path(
    path, # Exclude Linting false positive
    paste0(
      sample(letters, 10),
      ".", c("R", "Rnw", "txt")
    )
  ),
  touch
)))
result <- files
expectation <- list.files(path, full.names = TRUE)
expect_identical(result, expectation)
# % file names given
expectation <- files[1:3]
result <- find_files(file_names = files[1:3])
expect_identical(result, expectation)
## % some do not exist:
not_there <- replicate(2, tempfile())
result <- suppressWarnings(find_files(file_names = c(
  files[1:3],
  not_there
)))
expect_identical(result, expectation)
### % check for warning
result <- tryCatch(find_files(file_names = c(files[1:3], not_there)),
  warning = function(w) {
    return(w)
  }
)[["message"]]
expectation <- paste(paste("File", not_there, " not found."),
  collapse = "\n\t"
)
expect_identical(result, expectation)

### % check for find_all
expect_error(find_files(
  file_names = c(files[1:3], not_there),
  find_all = TRUE
))
## % all do not exist:
expect_error(find_files(file_names = replicate(2, tempfile())))
# % path given
result <- find_files(path = temp_dir, recursive = TRUE,
                     pattern = "\\.R$|\\.Rnw$")
expectation <- grep("\\.R$|\\.Rnw$", files, value = TRUE)
expect_identical(result, expectation)
## % none found (by not searching recursively):
expect_error(find_files(path = temp_dir, recursive = FALSE,
                        pattern = "\\.R$|\\.Rnw$"))
## % change pattern
result <- find_files(
  path = temp_dir,
  pattern = ".*\\.[RrSs]$|.*\\.[RrSs]nw$|.*\\.txt",
  recursive = TRUE
)
expectation <- files
expect_identical(result, expectation)
## % find a specific file by it's basename
result <- find_files(path = path, pattern = paste0(
  "^",
  basename(files[1]), "$"
))
expectation <- files[1]
expect_identical(result, expectation)
# % file_names and path given: file_names beats path
result <- find_files(file_names = files[1], path = temp_dir)
expectation <- files[1]
expect_identical(result, expectation)






# % create some files
temp_dir <- tempfile()
if (interactive()) unlink(temp_dir, recursive = TRUE)
path <- file.path(temp_dir, "foo")
dir.create(path, recursive = TRUE)
files <- sort(unname(sapply(
  file.path(
    path, # Exclude Linting false positive
    paste0(
      sample(letters, 10),
      ".", c("R", "Rnw", "txt")
    )
  ),
  touch
)))
write.csv(mtcars, file.path(path, "mtcars.csv"))
find_files(path = path, pattern = ".*")
result <- find_files(
  path = path, pattern = ".*",
  select = list(size = c(min = 1000))
)
expectation <- list.files(path, full.names = TRUE, pattern = "mtcars")
expect_identical(result, expectation)

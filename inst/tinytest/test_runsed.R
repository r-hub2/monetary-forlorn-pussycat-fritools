if (interactive()) {
    pkgload::load_all()
    library("tinytest")
}


source_files <- list.files(system.file(package = "fritools", "source", "R"),
                           pattern = ".*\\.R$", full.names = TRUE)
file.copy(source_files, tempdir(), overwrite = TRUE)
files <- find_files(file_names = file.path(tempdir(),
                                           basename(source_files)))
print(f <- runsed(files, pattern = "_clean", replacement = "_cleanr"))
expect_equal(f, c(file.path(tempdir(), c("wipe_clean.R", "zzz.R"))))
print(f <- runsed(files, pattern = "_cleanr\\>", replacement = "_cleaner"))
expect_equal(f, c(file.path(tempdir(), c("wipe_clean.R"))))

#' Change This Package's Name
#'
#' Does not change the path, we just rename the package, not the repo
#' and we must not change git remotes!
#'
#' @param path The path to the package.
#' @param path The new package name.
#' @return Run for its side effect.
#' @family package functions
#' @keywords internal
rename_package <- function(path, to) {
    if (!file.exists(file.path(path, "DESCRIPTION")))
        throw(paste("Cannot find", file.path(path, "DESCRIPTION"),
              "\n", path, "is no package!"))
    desc_file <- file.path(path, "DESCRIPTION")
    desc <- read.dcf(file = desc_file)
    fields <- colnames(desc)
    desc <- read.dcf(file = desc_file, keep.white = fields)
    from <- desc[1, "Package"]
    desc[1, "Package"] <- to
    write.dcf(x = desc, file = desc_file, keep.white = fields)
    from_pattern <- paste0("\\<", from, "\\>")
    name_pattern <- paste0(from, "\\>")
    file_pattern <- paste0("DESCRIPTION|NAMESPACE|LICENSE|Makefile|",
                      ".*\\.R$|.*\\.Rmd$|.*\\.Rd$|.*\\.md$|.*\\.Rnw$|",
                      ".*\\.Rasciidoc$|.*\\.asciidoc$|.*\\.txt$|.*\\.html?$")
    files <- list.files(path = path, recursive = TRUE, all.files = TRUE,
                        full.names = TRUE, pattern = file_pattern,
                        ignore.case = TRUE)
    files <- files[!grepl(pattern = ".*\\.Rcheck\\>", x = files)]
    fi <- file.info(files, extra_cols = FALSE)
    files <- files[!fi[["isdir"]]]
    for (f in files) {
        lines <- readLines(con = f)
        lines <- gsub(pattern = from_pattern, replacement = to, x = lines)
        # Revert changes in remotes:
        lines <- gsub(file.path(dirname(desc[1, "URL"]), to),
                      file.path(dirname(desc[1, "URL"]), from),
                      lines)
        writeLines(text = lines, con = f)
        if (grepl(pattern = name_pattern, x = f)) {
            file.rename(f, gsub(pattern = name_pattern,
                                replacement = to, x = f))
        }
    }
    return(invisible(NULL))
}

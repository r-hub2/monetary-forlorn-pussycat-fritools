get_r_binary <- function() {
    return(Sys.which(if (is_installed("R-devel")) "R-devel" else "R"))
}

r_cmd_build <- function(..., path = ".",
                        defaults = c("--no-build-vignettes"),
                        output_directory = path,
                      r_args = "--vanilla") {
    wd <- setwd(output_directory)
    on.exit(setwd(wd))
    args <- unique(c(defaults, unlist(list(...))))
    system2(get_r_binary(), args = c(r_args, "CMD build", args, path))
    gct <- tryCatch(get_current_tarball(output_directory),
                    error = function(e) return(FALSE))
    return(invisible(gct))
}

get_desc_value <- function(lines, what) {
    v <- trimws(strsplit(grep(paste0("^", what), lines, value = TRUE),
                         split = ":")[[1]][2])
    return(v)
}

get_current_tarball <- function(path, package_dir = path) {
    is_tarball <- !dir.exists(path) && file.exists(path) &&
        grepl("^.*\\.tar\\.gz$", path)
    if (is_tarball) {
        tarball <- path
    } else {
        description_path <- file.path(package_dir, "DESCRIPTION")
        if (file.exists(description_path)) {
            lines <- readLines(description_path)
            tarball <- paste0(get_desc_value(what = "Package", lines = lines),
                              "_",
                              get_desc_value("Version", lines = lines),
                              ".tar.gz")
            tarball <- file.path(path, tarball)
        } else {
            candiates <- list.files(path, full.names = TRUE,
                                               pattern = "^.*\\.tar\\.gz")
            info <- file.info(candiates)["mtime"]
            info[["name"]] <- rownames(info)
            info <- info[order(info$mtime), ]
            tarball <- info[nrow(info), "name"]
        }
    }
    tarball <- normalizePath(tarball, mustWork = TRUE)
    if (identical(length(tarball), 0L))
        throw(paste("Tarball does not exist!"))
    return(tarball)
}

r_cmd_check <- function(..., path = ".", defaults = c("--no-build-vignettes"),
                      r_args = "--vanilla") {
    tarball <- get_current_tarball(path)
    args <- unique(c(defaults, unlist(list(...))))
    r <- system2(get_r_binary(), args = c(r_args, "CMD check", args, tarball))
    return(r)
}


#' Install a Tarball or a Directory
#'
#' \code{\link[devtools:install]{devtools::install}} by defaults first builds
#' the tarball. Then it calls
#' \code{\link[callr:rcmd]{callr::rcmd}}, which allows for a lot of options.
#'
#' @param ... Arguments passed to \command{CMD INSTALL}.
#' @param r_args Arguments passed to \command{R}.
#' @param r An R binary.
#' @param path A path to a directory, but see \emph{try_tarball}.
#' @param try_tarball If \code{\link{TRUE}}, the \code{path} may be a tarball,
#' else it is interpreted as a path to a directory.
#' @export
#' @keywords internal
#' @family  bits and pieces
#' @return The return value of \code{\link{system2}}.
r_cmd_install <- function(..., path = ".",
                        r = get_r_binary(),
                        r_args = "--vanilla", try_tarball = TRUE) {
    args <- unlist(list(...))
    if (isTRUE(try_tarball)) {
        tarball <- tryCatch(get_current_tarball(path), error = identity)
        if (inherits(tarball, "error")) {
            warning(tarball[["message"]], " using directorty `",
                    normalizePath(path, mustWork = TRUE), "`.")
            what <- path
        } else {
            what <- tarball
        }
    } else {
        what <- path
    }
    r <- system2(r, args = c(r_args, "CMD INSTALL", args, what))
    return(r)
}

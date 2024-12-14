#' Set or Get the \code{path} Attribute to or from an Object
#'
#' We set paths on some objects, these are convenience wrappers to
#' \code{\link{attr}}.
#' @name paths
#' @param x An object.
#' @family file utilities
#' @examples
#' x <- 2
#' path <- tempfile()
#' touch(path)
#' x <- set_path(x, path)
#' get_path(x)
NULL

#' @export
#' @param force Force the retrieval, even if the path is not valid? Only meant
#' for unit testing, leave alone!
#' @rdname paths
#' @aliases get_path
#' @return For \code{get_path} the value of \code{attr(x, "path")}.
get_path <- function(x, force = FALSE) {
    path <- attr(x, "path")
    if (is.null(path)) {
        throw(paste0("No `path` attribute set on ",
                     deparse(substitute(x)), "."))
    } else {
        if (!is_path(path) && !isTRUE(force)) {
            name <- deparse(substitute(x))
            throw(paste0("File `path` does not exists. ",
                        "Attribute `path` of object `", name,
                        "` points to void. ",
                        "Use\n `attr(", name, ", \"path\") <- path`\nfirst."))
        }
        if (!utils::file_test(op = "-f", path))
            throw("`path` not a file, probably a directory.")
    }
    return(path)
}

#' @export
#' @param path The path to be set.
#' @param action Do we have a read or write process? Passed by
#' \code{\link{read_csv}} and \code{\link{write_csv}}. Leave alone otherwise.
#' @param overwrite Overwrite an existing \emph{path} attribute instead of
#' throwing an error?
#' @rdname paths
#' @aliases set_path
#' @return For \code{set_path} the modified object.
set_path <- function(x, path, action = c(NA, "read", "write"),
                     overwrite = FALSE) {
    #% check the path given.
    if (!is.null(attr(x, "path")) && ! isTRUE(overwrite)) {
        throw("Attribute `path` already set, skipping!")
    }
    if (!is_path(path)) {
        warning("Use\n `attr(x, \"path\") <- path`\ninstead.")
        throw("`path` does not exists.")
    }
    if (!utils::file_test(op = "-f", path))
        throw("`path` is a directory, not a file.")

    #% file modification time
    attr(path, "mtime") <- file.mtime(path)
    #% read/write dates
    ##% set defaults first, will be NULL if non-existant
    if (is.null(attr(path, "last_read"))) attr(path, "last_read") <- NA
    if (is.null(attr(path, "last_written"))) attr(path, "last_written") <- NA
    rw <- match.arg(action)
    switch(rw,
           "NA" = { # Do nothing!
           },
           "read" = attr(path, "last_read") <- Sys.time(),
           "write" = attr(path, "last_written") <- Sys.time(),
           throw("Argument `action` has unkown value!"))
    #% add attribute
    attr(x, "path") <- path
    return(x)
}

#' Get the \code{mtime} Attribute from an Object
#'
#' We set modification times on some objects, this is a convenience wrappers to
#' \code{\link{attr}}.
#' @param x An object.
#' @family file utilities
#' @export
#' @return The value of \code{attr(attr(x, "path", "mtime")}.
#' @examples
#' x <- 2
#' path <- tempfile()
#' touch(path)
#' x <- set_path(x, path)
#' get_mtime(x)
get_mtime <- function(x) {
    mtime <- attr(attr(x, "path"), "mtime")
    if (is.null(mtime)) {
        throw(paste0("No `path/mtime` attribute set on ",
                     deparse(substitute(x)), "."))
    }
    return(mtime)
}

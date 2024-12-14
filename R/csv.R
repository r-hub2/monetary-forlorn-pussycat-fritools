#' Convert a German Comma Separated File into a Comma Separated File
#'
#' @param file Path to the file.
#' @param ... Arguments passed to \code{\link{read_csv}}
#' @return \code{\link[base:invisible]{Invisibly}} the return value of
#' \code{\link{write_csv}}, but called for its side effect.
#' @family CSV functions
#' @export
#' @examples
#' f <- tempfile()
#' write.csv2(mtcars, file = f)
#' res <- csv2csv(f)
#' readLines(get_path(res), n = 1)
#' write.csv(mtcars, file = f)
#' readLines(get_path(res), n = 1)
csv2csv <- function(file, ...) {
    content <- read_csv(file = file, ...)
    res <- write_csv(content, csv_type = "standard")
    return(invisible(res))
}

has_digest <- function() return(requireNamespace("digest", quietly = TRUE))

#' Set a Hash Attribute on an Object
#'
#' @param x The object.
#' @return The modified object.
#' @family hash functions for objects
#' @export
set_hash <- function(x) {
    if (has_digest()) {
        attr(x, "hash") <- NULL
        attr(x, "hash") <- digest::digest(x)
    } else {
        throw("Package digest is needed, please install.")
    }
    return(x)
}

#' Separate an Object from its Hash Attribute
#'
#' We calculate a hash value of an object and store it as an attribute of the
#' objects, the hash value of that object will change. So we need to split the
#' hash value from the object to see whether or not the objected changed.
#' @param x The object.
#' @return A list containing the object and its hash attribute.
#' @family hash functions for objects
#' @export
un_hash <- function(x) {
    hash <- attr(x, "hash")
    attr(x, "hash") <- NULL
    res <- list(object = x, hash = hash)
    return(res)
}

is_german_csv <- function(file) {
    l <- readLines(file, n = 1)
    n_semicolae <- length(unlist(strsplit(l, split = ";")))
    n_commatae <- length(unlist(strsplit(l, split = ",")))
    is_german_csv <- n_semicolae >= n_commatae
    return(is_german_csv)
}

is_missing_cell11 <- function(file, quote = "\"") {
    is_german_csv <- is_german_csv(file)
    if (is_german_csv) {
        sep <- ";"
    } else {
        sep <- ","
    }
    l <- readLines(file, n = 1)
    res <- identical(unlist(strsplit(l, split = sep, useBytes = TRUE))[1],
                     paste0(quote, quote))
    return(res)
}

#' Read and Write a Comma Separated File
#'
#' Functions to read and write CSV files. The objects returned by these
#' functions are \code{\link{data.frame}s} with the following attributes:
#' \describe{
#'   \item{path}{The path to the file on disk.}
#'   \item{csv}{The type of CSV: either \code{standard} or \code{german}.}
#'   \item{hash}{The hash value computed with \pkg{digest}'s digest function, if
#'   \pkg{digest} is installed.}
#' }
#' @name csv
#' @param file The path to the file to be read or written.
#' @family CSV functions
NULL

#' @description
#' \code{read_csv} is a wrapper to determine whether to use
#' \code{\link[utils:read.csv2]{utils:read.csv2}} or
#' \code{\link[utils:read.csv]{utils:read.csv}}.
#' It sets the above three arguments.
#' @rdname csv
#' @aliases read_csv
#' @param ... Arguments passed to \code{\link[utils:read.csv]{utils::read.csv}}
#' or \code{\link[utils:read.csv2]{utils::read.csv2}}.
#' @return For \bold{\code{read_csv}}: An object read from the file.
#' @export
#' @examples
#' # read from standard CSV
#' f <- tempfile()
#' write.csv(mtcars, file = f)
#' str(read_csv(f))
#' f <- tempfile()
#' write.csv2(mtcars, file = f)
#' str(read_csv(f))
read_csv <- function(file, ...) {
    arguments <- list(...)
    if (!is.null(arguments[["quote"]])) {
        quote <- arguments[["quote"]]
    } else {
        quote <- "\""
    }
    if (!is_false(arguments[["header"]])) {
        has_header <- TRUE
        if (!("row.names" %in% names(arguments)) &&
            is_missing_cell11(file, quote = quote)) {
            # header not set to false and no rownames given and cell[1,1] empty
            # string
            arguments[["row.names"]] <- 1
        }
    } else {
        has_header <- FALSE
    }
    if (is.null(arguments[["row.names"]])) {
        if (has_header && is_missing_cell11(file, quote = quote)) {
            has_rownames <- TRUE
        } else {
            has_rownames <- FALSE
        }
    } else {
        has_rownames <- !is_false(arguments[["row.names"]])
    }
    if (is_german_csv(file)) {
        x <- do.call(utils::read.csv2, as.list(c(file = file, arguments)))
        assert_read_successfully(x, file, has_header, has_rownames, sep = ";")
        attr(x, "csv") <- "german"
    } else {
        x <- do.call(utils::read.csv, as.list(c(file = file, arguments)))
        assert_read_successfully(x, file, has_header, has_rownames, sep = ",")
        attr(x, "csv") <- "standard"
    }
    x <- set_path(x, path = file, action = "read")
    if (has_digest()) x <- set_hash(x)
    return(x)
}

#' @description
#' \code{write_csv} compares the \code{hash} value stored in the object's
#' attribute
#' with the objects current hash value. If they differ, it writes the object to
#' the \code{file} argument or, if not given, to the \code{path}
#' stored in the object's attribute. If no \code{csv_type} is given, it uses
#' the \code{csv} type stored in object's attribute.
#' If \pkg{digest} is not installed, the object will (unconditionally) be
#' written to disk.
#' @rdname csv
#' @aliases write_csv
#' @param x The object to write to disk.
#' @param csv_type Which \command{csv} type is to be used. If \code{NA}, the
#' \code{csv} attribute is read from the object.
#' @return For \bold{\code{write_csv}}: The object with updated \code{hash}
#' (and possibly \code{path} and \code{csv})
#' attribute.
#' @export
#' @examples
#' # write to standard CSV
#' f <- tempfile()
#' d <- mtcars
#' str(d <- write_csv(d, file = f))
#' file.mtime(f)
#' Sys.sleep(2) # make sure the mtime would have changed
#' write_csv(d, file = f)
#' file.mtime(f)
write_csv <- function(x, file = NULL,
                      csv_type = c(NA, "standard", "german")) {
    tmp <- un_hash(x)
    if (is.null(file)) {
        file <- get_path(x) # do not strip attributes, we need them!
    }
    csv <- match.arg(csv_type)
    if (is.na(csv)) {
        csv <- attr(x, "csv")
        if (is.null(csv)) {
            csv <- "standard"
            message("Set csv type to standard!")
        }
    }
    if (is.null(tmp[["hash"]]) ||
        !identical(csv, attr(x, "csv")) ||
        !has_digest() ||
        !identical(digest::digest(tmp[["object"]]), tmp[["hash"]])) {
        f <- switch(csv,
                    "standard" = utils::write.csv,
                    "german" = utils::write.csv2,
                    throw("Give a csv_type."))
        do.call(f, list(file = file, x = x))
    }
    attr(x, "csv") <- csv
    x <- set_path(x, file, action = "write", overwrite = TRUE)
    if (has_digest()) {
        res <- set_hash(x)
    } else {
        res <- x
    }
    return(invisible(res))
}

#' Bulk Read Comma Separated Files
#'
#' Import a bunch of comma separated files or
#' all comma separated files below a directory using
#' \code{\link{read_csv}}.
#' @param is_latin1 Are the files encoded in "Latin1"?
#' @param stop_on_error Stop if any of the files is not read? Warn and continue
#' otherwise.
#' @param paths A vector of file paths or the directory to find files.
#' @param pattern see \code{\link{find_files}}.
#' Ignored, if \code{paths} is not a directory.
#' @param all_files see \code{\link{find_files}}.
#' Ignored, if \code{paths} is not a directory.
#' @param recursive see \code{\link{find_files}}.
#' Ignored, if \code{paths} is not a directory.
#' @param ignore_case see \code{\link{find_files}}.
#' Ignored, if \code{paths} is not a directory.
#' @param find_all see \code{\link{find_files}}.
#' Ignored, if \code{paths} is not a directory.
#' @param select see \code{\link{find_files}}.
#' Ignored, if \code{paths} is not a directory.
#' @param ... Arguments passed to \code{\link{read_csv}}.
#' @return A named list, each element holding the contents of one \command{csv}
#' file read by \code{\link{read_csv}}.
#' @family CSV functions
#' @export
#' @examples
#' unlink(dir(tempdir(), full.names = TRUE))
#' data(mtcars)
#' mt_german <- mtcars
#' rownames(mt_german)[1] <- "Mazda R\u00f64"
#' names(mt_german)[1] <- "mg\u00dc"
#' #% read from directory
#' for (i in 1:10) {
#'     f <- file.path(tempdir(), paste0("f", i, ".csv"))
#'     write.csv(mtcars[1:5, TRUE], file = f)
#'     f <- file.path(tempdir(), paste0("f", i, "_german.csv"))
#'     write.csv2(mt_german[1:7, TRUE], file = f, fileEncoding = "Latin1")
#' }
#' bulk <- bulk_read_csv(tempdir())
#'
#' #% pass a path
#' f <- list.files(tempdir(), pattern = ".*\\.csv$", full.names = TRUE)[1]
#' bulk <- bulk_read_csv(f)
#'
#' #% pass multiple path
#' f <- list.files(tempdir(), pattern = ".*\\.csv$", full.names = TRUE)[2:4]
#' bulk <- bulk_read_csv(f)
bulk_read_csv <- function(paths,
                          stop_on_error = FALSE,
                          is_latin1 = TRUE,
                          pattern = ".*\\.csv$", all_files = TRUE,
                          recursive = FALSE, ignore_case = FALSE,
                          find_all = FALSE, select = NA,
                          ...) {
    if (identical(length(paths), 1L) && dir.exists(paths)) {
        paths <- find_files(path = paths, pattern = pattern,
                            all_files = all_files, recursive = recursive,
                            ignore_case = ignore_case, find_all = find_all,
                            select = select)
    }
    res <- list()
    for (infile in paths) {
        name <- sub("\\.csv$", "", ignore.case = TRUE, basename(infile))
        res[[name]] <- tryCatch({
            if (isTRUE(is_latin1)) {
                tmp <- read_csv(infile, fileEncoding = "Latin1", ...)
                tmp <- convert_umlauts_to_ascii(tmp)
                if (has_digest()) {
                    tmp <- set_hash(tmp)
                }
            } else {
                tmp <- read_csv(infile, ...)
            }
        },
        error = identity)
        if (inherits(res[[name]], "error")) {
            if (isTRUE(stop_on_error)) {
                throw("Reading file failed.", res[[name]])
            } else {
                warning("Reading of file ", infile, " failed.")
            }
        }
    }
    return(res)
}

#' Bulk Write Comma Separated Files
#'
#' Write a bunch of objects to disk using \code{\link{write_csv}}.
#' @param x A list of objects to be written to \command{csv}.
#' @param ... Arguments passed to
#' \code{\link{write_csv}}.
#' @return The list holding the return values of \code{\link{write_csv}}.
#' @family CSV functions
#' @export
#' @examples
#' unlink(dir(tempdir(), full.names = TRUE))
#' data(mtcars)
#' mt_german <- mtcars
#' rownames(mt_german)[1] <- "Mazda R\u00f64"
#' names(mt_german)[1] <- "mg\u00dc"
#' for (i in 1:10) {
#'     f <- file.path(tempdir(), paste0("f", i, ".csv"))
#'     write.csv(mtcars[1:5, TRUE], file = f)
#'     f <- file.path(tempdir(), paste0("f", i, "_german.csv"))
#'     write.csv2(mt_german[1:7, TRUE], file = f, fileEncoding = "Latin1")
#' }
#' #% read
#' bulk <- bulk_read_csv(tempdir())
#'
#' print(mtime <- file.info(list.files(tempdir(), full.names = TRUE))["mtime"])
#' bulk[["f2"]][3, 5] <- bulk[["f2"]][3, 5] + 2
#' Sys.sleep(2) # make sure the mtimes would change
#' result <- bulk_write_csv(bulk)
#' print(new_times <- file.info(dir(tempdir(), full.names = TRUE))["mtime"])
#' index_change <- grep("f2\\.csv", rownames(mtime))
#' if (requireNamespace("digest", quietly = TRUE)) {
#'     only_f2_changed <- all((mtime == new_times)[-c(index_change)]) &&
#'         (mtime < new_times)[c(index_change)]
#'     RUnit::checkTrue(only_f2_changed)
#' } else {
#'     RUnit::checkTrue(all(mtime < new_times))
#' }
bulk_write_csv <- function(x, ...) {
    res <- lapply(x, write_csv, ...)
    return(invisible(res))
}

#' Check the Number of Lines and Fields in a File
#'
#'
#' @param path Path to a file.
#' @param sep A character separating the fields in the file.
#' @return A list giving the number of lines, number of fields and an boolean
#' indicating whether all lines have the same number of fields.
#' @family CSV functions
#' @export
#' @examples
#' f <- tempfile()
#' write.csv2(mtcars, file = f)
#' check_ascii_file(f)
check_ascii_file <- function(path, sep = ";") {
    lines <- readLines(path)
    num_lines <- length(lines)
    num_fields <- vapply(X = lines, FUN.VALUE = numeric(1), USE.NAMES = FALSE,
                         function(x) length(unlist(strsplit(x, split = sep)))
                         )
    max_fields <- max(num_fields)
    res <- list(number_of_lines = num_lines,
                number_of_fields = max_fields,
                is_all_lines_all_fields =  identical(max_fields,
                                                     min(num_fields))
                )
    return(res)
}

is_read_successfully <- function(x, file, is_header, is_rownames, sep) {
    nrow <- as.integer(check_ascii_file(file, sep)[["number_of_lines"]] -
                       as.numeric(is_header))
    ncol <- as.integer(check_ascii_file(file, sep)[["number_of_fields"]] -
                       as.numeric(is_rownames))
    is_identical <- identical(nrow, nrow(x)) && identical(ncol, ncol(x))
    # utils::read.table reads columns correctly, even if the contain the column
    # separator. However it does so. So we _do not_ check on the number of
    # columns here:
    is_identical <- identical(nrow, nrow(x))
    return(is_identical)
}

assert_read_successfully <- function(x, file, is_header, is_rownames, sep) {
    if (!is_read_successfully(x, file, is_header, is_rownames, sep)) {
        warning("You might want to change argument `quote` ",
                "(to function utils::read.csv or fritools::read_csv) ",
                "to \"\".")
        throw(paste0("File ", file, " not read successfully!"))
    }
}

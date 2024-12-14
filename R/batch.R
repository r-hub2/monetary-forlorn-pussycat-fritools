#' Get the Path of the '\R' Code File in Case of an '\command{R CMD BATCH}' Run
#'
#' Retrieve the path from parsing the command line arguments of a
#' \command{R CMD BATCH} run.
#' @export
#' @return A vector of \code{\link{mode}} character giving the name of the \R
#' code file. Will be character(0) if not in an \command{R CMD BATCH} run.
#' @family script path getter functions
#' @examples
#' get_r_cmd_batch_script_path()
get_r_cmd_batch_script_path <- function() {
    r_call <- commandArgs(trailingOnly = FALSE)
    path <- r_call[which(r_call == "-f") + 1]
    return(path)
}

#' Get the Path of the '\R' Code File in Case of an '\command{Rscript}' Run
#'
#' Retrieve the path from parsing the command line arguments of a
#' \command{Rscript} run.
#' @export
#' @return A vector of \code{\link{mode}} character giving the name of the \R
#' code file. Will be character(0) if not in an \command{Rscript} run.
#' @family script path getter functions
#' @examples
#' get_rscript_script_path()
get_rscript_script_path <- function() {
    r_call <- commandArgs(trailingOnly = FALSE)
    path <- sub("--file=", "", r_call[grep("--file", r_call)])
    return(path)
}

#' Get the Path of the '\R' Code File
#'
#' This is just a wrapper for \code{\link{get_rscript_script_path}} and
#' \code{\link{get_r_cmd_batch_script_path}}.
#' @export
#' @return A vector of \code{\link{length}} 1 and \code{\link{mode}}
#' character giving the name of the \R code file if \R was run via
#' \command{R CMD BATCH} or
#' \command{Rscript}.
#' @family script path getter functions
#' @examples
#' get_script_path()
get_script_path <- function() {
    path <- c(get_r_cmd_batch_script_path(), get_rscript_script_path())
    return(path)
}

#' Get the Name of the '\R' Code File or set it to \code{default}
#'
#' The code file name is retrieved only for \command{R CMD BATCH} and
#' \command{Rscript},
#' if \R is used interactively, the name is set to \code{default},
#' even if you're working with code stored in a (named) file on disk.
#' @param default the name to return if \R is run interactively.
#' @export
#' @return A vector of \code{\link{length}} 1 and \code{\link{mode}}
#' character giving the name of the \R code file if \R was run via
#' \command{R CMD BATCH} or
#' \command{Rscript}, the given default otherwise.
#' @family script path getter functions
#' @examples
#' get_script_name(default = 'foobar.R')
get_script_name <- function(default = "interactive_R_session") {
    path <- get_script_path()
    if (as.logical(length(path))) {
        name <- basename(path)
    } else {
        name <- default
    }
    return(name)
}

#' Is '\R' Run in Batch Mode (via '\command{R CMD BATCH}' or
#' '\command{Rscript}')?
#'
#' Just a wrapper to \code{\link{interactive}}.
#' @export
#' @template return_boolean
#' @family logical helpers
#' @examples
#' is_batch()
is_batch <- function() {
    is_batch <- !interactive()
    return(is_batch)
}

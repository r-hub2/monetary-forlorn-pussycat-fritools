.options <- function(name, value) {
    # programmatically set options
    eval(parse(text = paste("options(", name, "= value)")))
}

#' Set Options For Packages
#'
#' A convenience function for \code{\link{options}}.
#'
#' @param package_name The package's name.
#' @param overwrite [boolean(1)]\cr Overwrite options already set?
#' @param ... See \code{\link{options}}.
#' @template return_invisibly_true
#' @export
#' @family option functions
#' @examples
#' options("cleanr" = NULL)
#' defaults <- list(max_file_width = 80, max_file_length = 300,
#'                  max_lines = 65, max_lines_of_code = 50,
#'                  max_num_arguments = 5, max_nesting_depth = 3,
#'                  max_line_width = 80, check_return = TRUE)
#'
#' set_options(package_name = "cleanr", defaults)
#' getOption("cleanr")
#' set_options(package_name = "cleanr", list(max_line_width = 3,
#'             max_lines = "This is nonsense!"))
#' set_options(package_name = "cleanr", check_return = NULL, max_lines = 4000)
#' get_options(package_name = "cleanr")
set_options <- function(..., package_name = .packages()[1], overwrite = TRUE) {
    if (requireNamespace("checkmate", quietly = TRUE))
        checkmate::qassert(overwrite, "B1")
    option_list <- list(...)
    if (length(option_list) == 1L && is.list(option_list))
        option_list <- unlist(option_list, recursive = FALSE)
    options_set <- get_options(package_name = package_name,
                               flatten_list = FALSE)
    if (isTRUE(overwrite)) {
        if (is.null(options_set)) {
            .options(package_name, option_list)
        } else {
            if (length(options_set) == 1L)
                options_set <- as.list(options_set)
            .options(package_name, utils::modifyList(options_set, option_list))
        }
    } else {
        is_option_unset <- ! (names(option_list) %in% names(options_set))
        if (any(is_option_unset))
            .options(package_name,
                     append(options_set, option_list[is_option_unset]))
    }
    return(invisible(TRUE))
}

#' Get Options For Packages
#'
#' A convenience function for \code{\link{getOption}}.
#'
#' @param package_name The package's name.
#' @param ... See \code{\link{getOption}}.
#' @param remove_names [boolean(1)]\cr Remove the names?
#' @param flatten_list [boolean(1)]\cr Return a vector?
#' @return A (possibly named) list or a vector.
#' @family option functions
#' @export
#' @examples
#' example("set_options", package = "fritools")
get_options <- function(..., package_name = .packages()[1],
                        remove_names = FALSE, flatten_list = TRUE) {
    if (requireNamespace("checkmate", quietly = TRUE)) {
        checkmate::qassert(remove_names, "B1")
        checkmate::qassert(flatten_list, "B1")
    }
    if (missing(...)) {
        option_list <- getOption(package_name)
    } else {
        option_names <- as.vector(...)
        options_set <- getOption(package_name)
        option_list  <- options_set[names(options_set) %in% option_names]
    }
    if (flatten_list) option_list <- unlist(option_list)
    if (remove_names) names(option_list)  <- NULL
    if (!is.null(option_list)) {
        attr(option_list, "package") <- package_name
    }
    return(option_list)
}

#' Opt-out Via Option
#'
#' Check whether or not a package option (set via \code{\link{set_options}})
#' \emph{force} is not set or set to \code{\link[base:TRUE]{TRUE}}.
#' @param x The option under which an element \code{"force"} is to be searched
#' for.
#' @export
#' @return \code{\link[base:TRUE]{TRUE}} if option \code{x[["force"]]} is either
#' \code{\link[base:TRUE]{TRUE}} or \code{\link[base:NULL]{NULL}} (i.e. not set
#' at all).
#' @family option functions
#' @family logical helpers
#' @export
#' @examples
#' is_force()
#' set_options(list(force = FALSE))
#' get_options(flatten_list = FALSE)
#' is_force()
is_force <- function(x = .packages()[1]) {
    res <- is_null_or_true(getOption(x)[["force"]])
    return(res)
}

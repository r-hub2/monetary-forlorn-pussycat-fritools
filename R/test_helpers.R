#' Get a Boolean Environment Variable
#'
#' A convenience wrapper to \code{\link{Sys.getenv}}.
#'
#' As \code{\link{Sys.getenv}} seems to always return a character vector, the
#' \code{\link{class}} of the value you set it to does not matter.
#' @param x The name of the Environment Variable.
#' @param stop_on_failure Throw an error instead of returning
#' \code{\link{FALSE}} if the environment variable is not set or cannot be
#' converted to boolean.
#' @family test helpers
#' @family operating system functions
#' @return The value the environment variable is set to, converted to boolean.
#' \code{\link{FALSE}} if the environment variable is not set or cannot be
#' converted to boolean. But see \strong{Arguments}: \emph{stop_on_failure}.
#' @export
#' @examples
#' message("See\n example(\"get_run_r_tests\", package = \"fritools\")")
get_boolean_envvar <- function(x, stop_on_failure = FALSE) {
    r <- Sys.getenv(x)
    if (identical(r, "")) {
        if (isTRUE(stop_on_failure)) {
            throw(paste("Environment variable", x, "is not set."))
        } else {
            r <- FALSE
        }
    } else {
        # Sys.getenv seems to always return a character vector.
        # So we first try to convert to numeric to take care of "0" and "1".
        # But this will crash for strings like "TRUE" and "FALSE", so we need to
        # try only.
        r <- tryCatch(as.numeric(r), warning = function(w) return(r))
        r <- as.logical(r)
        if (is.na(r)) {
            if (isTRUE(stop_on_failure)) {
                throw(paste("Environment variable", x, "is set to",
                            "a value not interpretable as boolean."))
            } else {
                r <- FALSE
            }
        } else {
            ## do nothing: r is set and not NA.
        }
    }
    return(r)
}

#' Is the Machine Running the Current '\R' Process Owned by FVAFRCU?
#'
#' Is the machine running the current \R process known to me?
#' @template return_boolean
#' @param type An optional selection.
#' @family test helpers
#' @family logical helpers
#' @export
#' @examples
#' is_running_on_fvafrcu_machines()
is_running_on_fvafrcu_machines <- function(type = c("any", "cu", "bwi",
                                                    "fvafr")) {
    sys_info <- Sys.info()
    h <- sys_info[["nodename"]] %in% c("h6", "h7") &&
        .Platform[["OS.type"]] == "unix" &&
        sys_info[["effective_user"]] == "qwer"
    v <- grepl("^fvafr.*CU.*$", sys_info[["nodename"]]) &&
        .Platform[["OS.type"]] == "unix" &&
        sys_info[["effective_user"]] %in%
        c("dominik.cullmann", "dominik", "nik")
    f <- grepl("^FVAFR-.*$", sys_info[["nodename"]]) &&
        tolower(sys_info[["effective_user"]]) == "dominik.cullmann" &&
        is_windows()
    b <- grepl("^L-FVAFR-NB84223$", sys_info[["nodename"]]) &&
        is_windows()

    r <- switch(match.arg(type),
                "cu" = h,
                "fvafr" = v || f,
                "bwi" = b,
                "any" = ,
                h || v || b || f)
    return(r)
}

#' Is the Current Machine Owned by \url{https://about.gitlab.com}?
#'
#' Check whether the current machine is located on
#' \url{https://about.gitlab.com}.
#' This check is an approximation only.
#' @param verbose Be verbose?
#' @template return_boolean
#' @family logical helpers
#' @family test helpers
#' @export
#' @examples
#' is_running_on_gitlab_com()
is_running_on_gitlab_com <- function(verbose = TRUE) {
    gitlab_pattern <- paste0("^runner-.*-project-.*-",
                             "concurrent-.*$")
    r <-  grepl(gitlab_pattern, Sys.info()[["nodename"]]) &&
        .Platform[["OS.type"]] == "unix"
    if (isTRUE(verbose) && !r) {
        msg <- paste(Sys.info()[["nodename"]], .Platform[["OS.type"]])
        attr(r, "message") <- msg
        message(msg)
    }
    return(r)
}

#' Set the System Variable RUN_R_TESTS
#'
#' A convenience wrapper to  \code{\link{Sys.getenv}} for setting
#' \kbd{RUN_R_TESTS}.
#' @param x A logical, typically some function output.
#' @param force Overwrite the variable if already set?
#' @return The value RUN_R_TESTS is set to, \code{\link{NULL}} if nothing is
#' done.
#' @family test helpers
#' @export
#' @examples
#' set_run_r_tests(is_running_on_fvafrcu_machines())
#' get_run_r_tests()
#' set_run_r_tests(TRUE, force = TRUE)
#' get_run_r_tests()
set_run_r_tests  <- function(x, force = FALSE) {
    r <- NULL
    is_unset <- identical(Sys.getenv("RUN_R_TESTS", unset = ""), "")
    if (is_unset || isTRUE(force)) {
        r <- x
        Sys.setenv("RUN_R_TESTS" = r)
    }
    return(invisible(r))
}

#' Get System Variable RUN_R_TESTS
#'
#' A convenience wrapper to
#' \code{\link{get_boolean_envvar}("RUN_R_TESTS")}.
#'
#' @inheritParams get_boolean_envvar
#' @family test helpers
#' @family operating system functions
#' @family logical helpers
#' @return The value RUN_R_TESTS is set to, converted to boolean.
#' \code{\link{FALSE}} if RUN_R_TESTS is not set or cannot be converted to
#' boolean.
#' @export
#' @examples
#' set_run_r_tests("", force = TRUE) # make sure it is not set.
#' get_run_r_tests()
#' try(get_run_r_tests(stop_on_failure = TRUE))
#' set_run_r_tests("A", force = TRUE) # "A" is not boolean.
#' get_run_r_tests()
#' try(get_run_r_tests(stop_on_failure = TRUE))
#' set_run_r_tests(4213, force = TRUE) # All numbers apart from 0 are TRUE
#' get_run_r_tests()
#' set_run_r_tests("0", force = TRUE) # 0 (and "0") is FALSE
#' get_run_r_tests()
#' set_run_r_tests("FALSE", force = TRUE)
#' get_run_r_tests()
#' set_run_r_tests(TRUE, force = TRUE)
#' get_run_r_tests()
get_run_r_tests <- function(stop_on_failure = FALSE) {
    r <- get_boolean_envvar("RUN_R_TESTS", stop_on_failure = stop_on_failure)
    return(r)
}

#' Force Testing on Known Hosts
#'
#' Enforce the environment variable RUN_R_TESTS to TRUE on known hosts.
#'
#' This should go into \code{\link{.onLoad}} to force tests on known hosts.
#' @template return_invisibly_null
#' @export
#' @family test helpers
#' @inherit set_run_r_tests return
#' @examples
#' get_run_r_tests()
#' if (isFALSE(get_run_r_tests())) {
#'     run_r_tests_for_known_hosts()
#'     get_run_r_tests()
#' }
run_r_tests_for_known_hosts <- function() {
    r <- set_run_r_tests(is_running_on_fvafrcu_machines() ||
                         is_running_on_gitlab_com(verbose = FALSE),
                     force = TRUE)
    return(invisible(r))
}

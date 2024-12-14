#' Is the Current R Process an \command{R CMD check}?
#'
#' Check for system variables to guess whether or not this is an
#' \command{R CMD check}.
#' @export
#' @family logical helpers
#' @family test helpers
#' @template return_boolean
is_r_cmd_check <- function() {
    is_r_cmd_check <- ("CheckExEnv" %in% search()) ||
        any(c("_R_CHECK_TIMINGS_", "_R_CHECK_LICENSE_") %in%
            names(Sys.getenv()))
    return(is_r_cmd_check)
}

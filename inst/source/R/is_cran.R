#' Is \R Running on CRAN?
#'
#' \emph{This is a verbatim copy of \code{fda::CRAN} of
#' \pkg{fda} version 5.1.9.}
#'
#'  This function allows package developers to run tests themselves that
#'  should not run on CRAN or with \preformatted{R CMD check --as-cran} because
#'  of compute time constraints with CRAN tests.
#'
#'  The "Writing R Extensions" manual says that \command{R CMD check} can be
#'  customized "by setting environment variables _R_CHECK_*_:, as
#'  described in" the Tools section of the "R Internals" manual.
#'
#'  \command{R CMD check} was tested with R 3.0.1 under Fedora 18 Linux and with
#'  \command{Rtools} 3.0 from April 16, 2013 under Windows 7.  With the
#'  \preformatted{'--as-cran'}
#'  option, 7 matches were found;  without it, only 3 were found.  These
#'  numbers were unaffected by the presence or absence of the '--timings'
#'  parameter.  On this basis, the default value of n_R_CHECK4CRAN was set
#'  at 5.
#'
#'  1.  \code{x. <- Sys.getenv()}
#'
#'  2.  Fix \code{CRAN_pattern} and \code{n_R_CHECK4CRAN} if missing.
#'
#'  3.  Let i be the indices of x. whose names match all the patterns in
#'  the vector x.
#'
#'  4.  Assume this is CRAN if length(i) >= n_R_CHECK4CRAN
#'
#' @param cran_pattern A regular expressions to apply to the names of
#' \code{Sys.getenv()}
#'    to identify possible CRAN parameters.  Defaults to
#'    \code{Sys.getenv('_CRAN_pattern_')} if available and '^_R_' if not.
#' @param n_r_check4cran  Assume this is CRAN if at least n_R_CHECK4CRAN
#' elements of
#'    \code{Sys.getenv()} have names matching x.  Defaults to
#'    \code{Sys.getenv('_n_R_CHECK4CRAN_')} if available and 5 if not.
#' @return
#'  A logical scalar with attributes \samp{'sys_getenv'} containing the
#'  results of \code{Sys.getenv()} and 'matches' containing \code{i} per step 3
#'  above.
#' @export
#' @family test helpers
#' @family logical helpers
#' @examples
#' if (!is_cran()) {
#'     message("Run your tests here.")
#' }
is_cran <- function(cran_pattern, n_r_check4cran) {
    gete <- Sys.getenv()
    ngete <- names(gete)
    i <- seq(along = gete)
    if (missing(cran_pattern)) {
        if ("_cran_pattern_" %in% ngete) {
            cran_pattern <- gete["_cran_pattern_"]
        } else {
            cran_pattern <- "^_R_"
        }
    }
    if (missing(n_r_check4cran)) {
        if ("_n_r_check4cran_" %in% ngete) {
            n_r_check4cran <- as.numeric(gete["_n_r_check4cran_"])
        } else {
            n_r_check4cran <- 5
        }
    }
    for (pati in cran_pattern)
        i <- i[grep(pati, ngete[i])]
    is_cran <- (length(i) >= n_r_check4cran)
    attr(is_cran, "sys_getenv") <- gete
    attr(is_cran, "matches") <- i
    return(is_cran)
}

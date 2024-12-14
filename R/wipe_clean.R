#' Remove All Objects From an Environment
#'
#' Wipe an environment clean. This is similar to the broom button in
#' \command{RStudio}.
#' @param environment The environment that should be wiped clean.
#' @param all_names See argument \code{all.names} for \code{\link{ls}}.
#' @return A character vector containing the names of objects removed, but
#' called for its side effect of removing all objects from the environment.
#' @export
#' @family R memory functions
#' @examples
#' an_object <- 1
#' wipe_clean()
#' ls()
#' e <- new.env()
#' assign("a", 1, envir = e)
#' assign("b", 1, envir = e)
#' ls(envir = e)
#' wipe_clean(envir = e)
#' ls(envir = e)
#' RUnit::checkIdentical(length(ls(envir = e)), 0L)
wipe_clean <- function(environment = getOption("wipe_clean_environment"),
                       all_names = TRUE) {
    if (!is.null(environment)) {
    objects <- ls(name = environment, all.names = all_names)
    rm(list = objects, envir = environment)
    } else {
        throw(paste("Argument `environment` not given and option;",
                    "`wipe_clean_environment` not set!"))
    }
    return(invisible(objects))
}

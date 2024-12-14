#' Apply a Function Over a Ragged Array
#'
#' This is a modified version of \code{\link[base:tapply]{base::tapply}} to
#' allow for \code{\link{data.frame}}s to be passed as \code{X}.
#' @param object See \code{\link[base:tapply]{base::tapply}} \emph{X}.
#' @param index See \code{\link[base:tapply]{base::tapply}} \emph{INDEX}.
#' @param func See \code{\link[base:tapply]{base::tapply}} \emph{FUN}.
#' @param ... See \code{\link[base:tapply]{base::tapply}}.
#' @param default See \code{\link[base:tapply]{base::tapply}}.
#' @param simplify See \code{\link[base:tapply]{base::tapply}}.
#' @return See \code{\link[base:tapply]{base::tapply}}.
#' @family bits and pieces
#' @export
#' @examples
#' result <- fritools::tapply(warpbreaks[["breaks"]], warpbreaks[, -1], sum)
#' expectation <- base::tapply(warpbreaks[["breaks"]], warpbreaks[, -1], sum)
#' RUnit::checkIdentical(result, expectation)
#' data("mtcars")
#' s <- stats::aggregate(x = mtcars[["mpg"]],
#'                       by = list(mtcars[["cyl"]], mtcars[["vs"]]),
#'                       FUN = mean)
#' t <- base::tapply(X = mtcars[["mpg"]],
#'                   INDEX = list(mtcars[["cyl"]], mtcars[["vs"]]),
#'                   FUN = mean)
#' if (require("reshape", quietly = TRUE)) {
#'     suppressWarnings(tm <- na.omit(reshape::melt(t)))
#'     if (RUnit::checkEquals(s, tm, check.attributes = FALSE))
#'         message("Works!")
#' }
#' message("If you don't pass weigths, this is equal to:")
#' w <- base::tapply(X = mtcars[["mpg"]], INDEX = list(mtcars[["cyl"]],
#'                                                     mtcars[["vs"]]),
#'                   FUN = stats::weighted.mean)
#' all.equal(w, t, check.attributes = FALSE)
#' message("But how do you pass those weights?")
#' # we define a wrapper to pass the column names for a data.frame:
#' weighted_mean <- function(df, x, w) {
#'     stats::weighted.mean(df[[x]], df[[w]])
#' }
#' if (RUnit::checkIdentical(stats::weighted.mean(mtcars[["mpg"]],
#'                                                mtcars[["wt"]]),
#'                           weighted_mean(mtcars, "mpg", "wt")))
#'     message("Works!")
#' message("base::tapply can't deal with data.frames:")
#' try(base::tapply(X = mtcars, INDEX = list(mtcars[["cyl"]], mtcars[["vs"]]),
#'                  FUN = weighted_mean, x = "mpg", w = "wt"))
#' wm <- fritools::tapply(object = mtcars, index = list(mtcars[["cyl"]],
#'                                                 mtcars[["vs"]]),
#'                        func = weighted_mean, x = "mpg", w = "wt")
#' subset <- mtcars[mtcars[["cyl"]] == 6 & mtcars[["vs"]] == 0, c("mpg", "wt")]
#' stats::weighted.mean(subset[["mpg"]], subset[["wt"]]) == wm
tapply <- function(object, index, func = NULL, ..., default = NA,
                   simplify = TRUE) {
    func <- if (!is.null(func))
        match.fun(func)
    if (!is.list(index))
        index <- list(index)
    index <- lapply(index, as.factor)
    num_i <- length(index)
    if (!num_i)
        stop("'index' is of length zero")
    if (is.data.frame(object)) {
        if (!all(lengths(index) == nrow(object)))
            stop("arguments must have same length")
    } else {
        if (!all(lengths(index) == length(object)))
            stop("arguments must have same length")
    }
    namelist <- lapply(index, levels)
    extent <- lengths(namelist, use.names = FALSE)
    cumextent <- cumprod(extent)
    if (cumextent[num_i] > .Machine[["integer.max"]])
        stop("total number of levels >= 2^31")
    storage.mode(cumextent) <- "integer"
    ngroup <- cumextent[num_i]
    group <- as.integer(index[[1L]])
    if (num_i > 1L)
        for (i in 2L:num_i) group <- group + cumextent[i - 1L] *
            (as.integer(index[[i]]) - 1L)
    if (is.null(func))
        return(group)
    levels(group) <- as.character(seq_len(ngroup))
    class(group) <- "factor"
    ans <- split(object, group)
    names(ans) <- NULL
    idx <- as.logical(lengths(ans))
    ans <- lapply(X = ans[idx], FUN = func, ...)
    ansmat <- array(if (simplify && all(lengths(ans) == 1L)) {
                        ans <- unlist(ans, recursive = FALSE, use.names = FALSE)
                        if (!is.null(ans) && is.na(default) && is.atomic(ans))
                            vector(typeof(ans))
                        else
                            default
                   } else {
                       vector("list", prod(extent))
                   },
                   dim = extent, dimnames = namelist)
    if (length(ans)) {
        ansmat[idx] <- ans
    }
    ansmat
}

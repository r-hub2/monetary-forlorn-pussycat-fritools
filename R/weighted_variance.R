#' Calculate a Weighted Variance
#'
#' Calculate a weighted variance.
#' @param x A numeric \code{\link{vector}} or \code{\link{data.frame}}.
#' @param ... Other arguments ignored.
#' @return A numeric giving the (weighted) variance of \code{x}.
#' @export
#' @family statistics
weighted_variance <- function(x, ...) {
    UseMethod("weighted_variance", x)
}

#' @rdname weighted_variance
#' @export
#' @param weights A vector of weights.
#' @param weights_counts Are the weights counts of the data? If so, we can
#' calculate the unbiased sample variance, otherwise we calculate the biased
#' (maximum likelihood estimator of the) sample variance.
#' @examples
#' ## GPA from Siegel 1994
#' wt <- c(5,  5,  4,  1)/15
#' x <- c(3.7,3.3,3.5,2.8)
#' var(x)
#' weighted_variance(x = x)
#' weighted_variance(x = x, weights = wt)
#' weighted_variance(x = x, weights = wt, weights_counts = TRUE)
#' weights <- c(5,  5,  4,  1)
#' weighted_variance(x = x, weights = weights)
#' weighted_variance(x = x, weights = weights, weights_counts = FALSE)
weighted_variance.numeric <- function(x, weights, weights_counts = NULL, ...) {
    if (length(x) < 2) {
        variance <- NA
    } else {
        if (missing(weights)) {
            variance <- stats::var(x)
        } else {
            if (!is.logical(weights_counts)) {
                is_counts <- !isTRUE(all.equal(sum(weights), 1))
            } else {
                is_counts <- weights_counts
            }
            if (is_counts) {
                if (isTRUE(all.equal(sum(weights), 1)) &&
                    isTRUE(weights_counts)
                )
                    message("You forced the weights to be counts, ",
                            "but they do sum to 1!")
                mean <- stats::weighted.mean(x = x, w = weights)
                variance <- (x - mean)^2 %*% weights / (sum(weights) - 1)
                variance <- as.numeric(variance)
            } else {
                if (!isTRUE(all.equal(sum(weights), 1)) &&
                    isFALSE(weights_counts)
                )
                    message("You forced the weights not to be counts, ",
                            "but they do not sum to 1!")
                normalized_weights <- weights / sum(weights)
                mean <- sum(x * normalized_weights)
                variance <- sum((x - mean)^2 * normalized_weights)

            }
        }
    }
    return(variance)

}

#' @details
#' The  \code{\link{data.frame}} method is meant for use with
#' \code{\link{tapply}}, see \emph{examples}.
#' @rdname weighted_variance
#' @export
#' @param var The name of the column in \code{x} giving the variable of
#' interest.
#' @param weight The name of the column in \code{x} giving the weights.
#' @examples
#' weighted_variance(x = data.frame(x, wt), var = "x",
#'                              weight = "wt")
#' # apply by groups:
#' fritools::tapply(object = mtcars,
#'                  index = list(mtcars[["cyl"]], mtcars[["vs"]]),
#'                  func = weighted_variance, var = "mpg", w = "wt")
weighted_variance.data.frame <- function(x, var, weight, ...) {# Exclude Linting
    return(weighted_variance(x = x[[var]], weights = x[[weight]], ...))
}

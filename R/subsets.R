#' Determine Subset Sizes Close to Equality
#'
#' Determine the sizes of k subsets of a set with
#' n elements in such a way that the sizes are as
#' equal as possible.
#'
#' @param n The size of the set.
#' @param k The number of subsets.
#' @return A vector of k sizes of the subsets.
#' @family subsetting functions
#' @export
#' @examples
#' subset_sizes(n = 100, k = 6)
#' subset_sizes(n = 2, k = 6)
subset_sizes <- function(n, k) {
    res <- NULL
    if (n < 2) throw("Got n < 2, can't determine subsets.")
    if (k > n) {
        warning("Got k > n, this will result in subsizes of 1 and 0.")
        res <- c(rep(1, n), rep(0, k - n))
    } else {
        if (n %% k == 0) {
            res <- rep(n / k, k)
        } else {
            fl <- floor(n / k)
            ce <- ceiling(n / k)
            res <- c(rep(ce, round((n / k - fl) * k)),
                     rep(fl, round((1 - (n / k - fl)) * k)))
        }
    }
    return(res)
}

#' Determine Indices and Sizes of Subsets
#'
#' Create starting and stopping indices for subsets defined by
#' \code{\link{subset_sizes}}.
#' @param n The size of the set.
#' @param k The number of subsets.
#' @return A matrix with starting index, size, and stopping index for each
#' subset.
#' @family subsetting functions
#' @export
#' @examples
#' index_groups(n = 100, k = 6)
#' index_groups(n = 2, k = 6)
index_groups <- function(n, k) {
    sizes <- subset_sizes(n, k)
    start <- 1 + c(0, cumsum(sizes)[1:(k - 1)])
    stop <- start + sizes - 1
    res <- cbind(id = 1:k, start, sizes, stop)[sizes > 0, TRUE]
    return(res)
}

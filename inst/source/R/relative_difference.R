#' Compute Relative Differences Between the Values of Two Vectors
#'
#' We often try to compare vectors on near equality. This is a wrapper to
#' \code{\link{all.equal}} for our convenience. It also implements relative
#' difference and change as discussed in
#' \url{https://en.wikipedia.org/wiki/Relative_change_and_difference}.
#' @param current One vector.
#' @param reference Another vector, for \code{type = all.equal}, this is passed
#' as \code{target}, for \code{type = all.equal} this can be thought of as the
#' "correct" value or the state "before".
#' @param type The method to be used. See Details.
#' @details
#' The default method (\code{type = all.equal}) applies
#' \code{\link{all.equal}} onto the two
#' vectors. Method \code{type = difference} is somewhat the same as the default,
#' method \code{type = change} takes account of the sign of the differences.
#' @return
#' @export
#' @family statistics
#' @family vector comparing functions
#' @examples
#' n <- 500
#' x <- rnorm(n)
#' y <- x + rnorm(n, sd = 0.0001)
#' plot(relative_difference(x, y), x)
#' plot(relative_difference(x, y, "difference"), x)
#' # They do approximately the same:
#' max(relative_difference(relative_difference(x, y),
#'                             relative_difference(x, y, "difference")))
#' # Takes sign into account:
#' plot(relative_difference(x, y, "change"), x)
#' max(relative_difference(relative_difference(x, y),
#'                         abs(relative_difference(x, y, "change"))))
relative_difference <- function(current, reference,
                                type = c("all.equal", "difference", "change")) {
     switch(match.arg(type),
           "all.equal" = {
               m <- cbind(current = current, reference = reference)
               cmp <- function(x) {
                   res <- all.equal(target = x["reference"],
                                    current = x["current"],
                                    check.attributes = FALSE)
                   return(res)
               }
               ae <- apply(m, 1, cmp)
               rc <- as.numeric(lapply(strsplit(ae, split = ": "), "[", 2))
               rc[is.na(rc)] <- 0
               res <- rc
           },
           "difference" = {
               if (identical(current, reference)) {
                   res <- 0
               } else {
                   denominator <- (abs(current) + abs(reference)) / 2
                   denominator <- ifelse(denominator == 0,  1e-10, denominator)
                   res <- abs((current - reference) / denominator)
               }
           },
           "change" = {
               denominator <- ifelse(reference == 0, 1e-10, reference)
               res <- (current - reference) / abs(denominator)
           }
           )
    return(res)
}

#' Compare Two Vectors
#'
#' Side-by-side comparison of two vectors.
#' The vectors get sorted and are compared element-wise.
#' So the result will be as long as the union of the two vectors plus their
#' number of values unique to one of them.
#' @param x,y Two vectors of the same mode.
#' @param differences_only Report only the differences?
#' @export
#' @family searching functions
#' @family vector comparing functions
#' @return A matrix containing the side-by-side comparison.
#' @examples
#' data(mtcars)
#' cars <- rownames(mtcars)
#' carz <- cars[-grep("Merc", cars)]
#' cars <- cars[nchar(cars) < 15]
#' cars <- c(cars, "foobar")
#' compare_vectors(cars, carz)
compare_vectors <- function(x, y, differences_only = FALSE) {
    names <- c(deparse(substitute(x)), deparse(substitute(y)))
    u <-  sort(union(x, y))
    x_only <- setdiff(u, x)
    y_only <- setdiff(u, y)
    ix <- match(x_only, u)
    iy <- match(y_only, u)
    m <- cbind(x = u, y = u)
    m[iy, "y"] <- NA
    m[ix, "x"] <- NA
    dimnames(m)[[2]] <- names
    dimnames(m)[[1]] <- u
    if (isTRUE(differences_only))
        m <- m[apply(apply(m, 2, is.na), 1, any), TRUE]
    if (is.vector(m))
        m <- as.matrix(t(m))
    return(m)
}

#' Convert German Umlauts to a More or Less Suitable `ascii` Representation
#'
#' @param x A string or \code{data.frame}.
#' @return \bold{x} with the umlauts converted to ascii.
#' @family German umlaut converters
#' @export
convert_umlauts_to_ascii <- function(x) {
    UseMethod("convert_umlauts_to_ascii", x)
}

#' @rdname convert_umlauts_to_ascii
#' @export
#' @examples
#' string <- paste("this is \u00e4 string")
#' print(string)
#' print(convert_umlauts_to_ascii(string))
convert_umlauts_to_ascii.character <- function(x) { # Exclude Linting
    s <- iconv(enc2native(x), to = "UTF-8", sub = "unicode")
    s <- gsub(get_german_umlauts("ae"), "ae", s)
    s <- gsub(get_german_umlauts("Ae"), "Ae", s)
    s <- gsub(get_german_umlauts("oe"), "oe", s)
    s <- gsub(get_german_umlauts("Oe"), "Oe", s)
    s <- gsub(get_german_umlauts("ue"), "ue", s)
    s <- gsub(get_german_umlauts("Ue"), "Ue", s)
    s <- gsub(get_german_umlauts("sz"), "sz", s)
    return(s)
}

#' @rdname convert_umlauts_to_ascii
#' @export
#' @examples
#' string <- paste("this is \u00e4 string")
#' df <- data.frame(v1 = c(string, "foobar"),
#'                  v2 = c("foobar", string), v3 = 3:4)
#' names(df)[3] <- "y\u00dfy"
#' convert_umlauts_to_ascii(df)
convert_umlauts_to_ascii.data.frame <- function(x) { # Exclude Linting
    f <- function(x) {
        res <- x
        if (is.character(res))
            res <- convert_umlauts_to_ascii(res)
        return(res)
    }
    df <- data.frame(lapply(x, f))
    attributes(df) <- attributes(x)
    names(df) <- convert_umlauts_to_ascii(names(x))
    colnames(df) <- convert_umlauts_to_ascii(colnames(x))
    return(df)
}

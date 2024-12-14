#' Tex Codes for German Umlauts
#'
#' Convert German umlauts in a string to their plain TeX representation.
#' @param x A string.
#' @return A string with the umlauts converted to plain TeX.
#' @family German umlaut converters
#' @export
#' @examples
#' string <- paste("this is \u00e4 string")
#' print(string)
#' print(convert_umlauts_to_tex(string))
convert_umlauts_to_tex <- function(x) {
    s <- iconv(enc2native(x), to = "UTF-8", sub = "unicode")
    s <- gsub("\u00e4", "\\\\\u0022a{}", s)
    s <- gsub("\u00c4", "\\\\\u0022A{}", s)
    s <- gsub("\u00f6", "\\\\\u0022o{}", s)
    s <- gsub("\u00d6", "\\\\\u0022O{}", s)
    s <- gsub("\u00fc", "\\\\\u0022u{}", s)
    s <- gsub("\u00dc", "\\\\\u0022U{}", s)
    s <- gsub("\u00df", "\\\\ss{}", s)
    return(s)
}

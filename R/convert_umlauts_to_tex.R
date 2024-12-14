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
    s <- gsub(get_german_umlauts(c("ae")), paste0("\\", get_german_umlauts(c("ae"), type = "latex")), s)
    s <- gsub(get_german_umlauts(c("Ae")), paste0("\\", get_german_umlauts(c("Ae"), type = "latex")), s)
    s <- gsub(get_german_umlauts(c("oe")), paste0("\\", get_german_umlauts(c("oe"), type = "latex")), s)
    s <- gsub(get_german_umlauts(c("Oe")), paste0("\\", get_german_umlauts(c("Oe"), type = "latex")), s)
    s <- gsub(get_german_umlauts(c("ue")), paste0("\\", get_german_umlauts(c("ue"), type = "latex")), s)
    s <- gsub(get_german_umlauts(c("Ue")), paste0("\\", get_german_umlauts(c("Ue"), type = "latex")), s)
    s <- gsub(get_german_umlauts(c("sz")), paste0("\\", get_german_umlauts(c("sz"), type = "latex")), s)
    return(s)
}

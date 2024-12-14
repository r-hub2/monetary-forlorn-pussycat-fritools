#' Get German Umlauts
#'
#' I often need German umlauts in reporting. So I need either a UTF-8 or LaTeX
#' representation.
#' @param which A character vector specifying a subset of the result vector.
#' @param type UTF-8 or LaTeX?
#' @param strip_names Return an unnamed vector?
#' @return A (possibly named) vector of UTF-8 representations of german umlauts.
#' @family German umlaut converters
#' @export
#' @examples
#' get_german_umlauts()
#' get_german_umlauts(type = "latex")
#' get_german_umlauts(strip_names = FALSE)
#' get_german_umlauts(which = c("sz", "Ae"))
#' try(get_german_umlauts(which = c("sz", "foo", "Ae", "bar")))
#' paste0("Cologne is K", get_german_umlauts("oe"), "ln. In LaTeX it's K",
#'        get_german_umlauts("oe", "latex"), "ln")
get_german_umlauts <- function(which = NULL, type = c("utf-8", "latex"),
                               strip_names = TRUE) {
    type <- match.arg(type)
    umlauts <- switch(type,
                     "utf-8" = c(ae = "\u00E4", oe = "\u00F6", ue = "\u00FC",
                                 Ae ="\u00C4", Oe = "\u00D6", Ue = "\u00DC",
                                 sz = "\u00DF"),
                     "latex" = c(ae = "\u005C\u0022a{}", oe = "\u005C\u0022o{}",
                                 ue = "\u005C\u0022u{}", Ae = "\u005C\u0022A{}",
                                 Oe = "\u005C\u0022O{}", Ue = "\u005C\u0022U{}",
                                 sz = "\u005Css{}"))
    if (!is.null(which)) {
        is_valid_name <- which %in% names(umlauts)
        if (!all(is_valid_name)) {
            msg <- paste(which[!is_valid_name],
                         "is no valid german umlaut name.")
            msg <- c(msg, paste0("Valid names are ",
                                 paste(names(umlauts), collapse = ", "),"."))
            throw(paste(msg, collapse = "\n"))
        } else {
            umlauts <- umlauts[which]
        }
    }
    if (isTRUE(strip_names)) names(umlauts) <- NULL
    return(umlauts)
}


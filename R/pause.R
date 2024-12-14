#' Pause
#'
#' @return A \code{\link{data.frame}}.
#' @family bits and pieces
#' @template return_invisibly_null
#' @export
#' @examples
#' pause()
pause <- function() {
    if (interactive())
        invisible(readline(prompt = "Press [enter] to continue: "))
    return(invisible(NULL))
}

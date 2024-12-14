#' Sloboda's Growth Function
#'
#' Implement the growth function
#'   \deqn{
#'     y_t = k^{\beta_{1}} \times \left(\frac{y_0}{k^{\beta_{1}}}\right)^{\exp
#'         \left[
#'             \frac{\beta_{2}}{(\beta_{3}-1) \times t ^{(\beta_{3}-1)}} -
#'             \frac{\beta_{2}}{(\beta_{3}-1) \times t_0 ^{(\beta_{3}-1)}}
#'     \right]
#'     }
#'   }{%
#'     y_t = k^{beta_{1}} (y_{0} / (k^{beta_{1}}))^\exp(
#'             beta_{2}/((beta_{3}-1) t^(beta_{3}-1)) -
#'             beta_{2}/((beta_{3}-1) t_0^(beta_{3}-1)))
#' }
#' published in
#' \cite{Sloboda, B., 1971: Zur Darstellung von Wachstumsprozessen mit Hilfe von
#' Differentialgleichungen erster Ordnung. Mitt. d. Baden-Württembergischen
#' Forstlichen Versuchs- und Forschungsanstalt}.
#' @param a Sloboda's \eqn{\beta_{3}}.
#' @param b Sloboda's \eqn{\beta_{2}}.
#' @param c Sloboda's \eqn{\beta_{1}}.
#' @param y0 Sloboda's \eqn{y_{0}}.
#' @param t0 Sloboda's \eqn{t_{0}}.
#' @param t Sloboda's \eqn{t}.
#' @param k Sloboda's \eqn{k}.
#' @param type Gerald Kaendler reformulated the algorithm, but it doesn't get
#' faster, see the examples.
#' @return The value \eqn{y_t} of Sloboda's growth function.
#' @export
#' @family statistics
#' @examples
#' microbenchmark::microbenchmark(cl = sloboda(0.2, 0.7, 3, 30, 30, 35),
#'                                g =  sloboda(0.2, 0.7, 3, 30, 30, 35,
#'                                             "kaendler"),
#'                                check = "equivalent")
sloboda <- function(a, b, c, y0, t0, t, type = c("classic", "kaendler"),
                    k = 65) {
    type <- match.arg(type)
    res <- switch(type,
                  kaendler =  k^c * (y0 / k^c)**exp(-b / (1 - a) *
                                                    (t**(1 - a) - t0**(1 - a))),
                  classic = k^c * (y0 / k^c)^exp(b / ((a - 1) * t^(a-1)) -
                                                 b / ((a - 1) * t0^(a - 1))))
    return(res)
}


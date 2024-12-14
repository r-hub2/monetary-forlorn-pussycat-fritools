if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


result <- fritools::tapply(warpbreaks[["breaks"]], warpbreaks[, -1], sum)
expectation <- base::tapply(warpbreaks[["breaks"]], warpbreaks[, -1], sum)
expect_identical(result, expectation)







weighted_mean <- function(df, x, w) {
  stats::weighted.mean(df[[x]], df[[w]])
}
data("mtcars")
wm <- fritools::tapply(
  object = mtcars, index = list(
    mtcars[["cyl"]],
    mtcars[["vs"]]
  ),
  func = weighted_mean, x = "mpg", w = "wt"
)
for (cyl in c(4, 6, 8)) {
  for (vs in c(0, 1)) {
    subset <- mtcars[
      mtcars[["cyl"]] == cyl & mtcars[["vs"]] == vs,
      c("mpg", "wt")
    ]
    if (interactive()) {
      print(stats::weighted.mean(
        subset[["mpg"]],
        subset[["wt"]]
      ))
    }
    expect_identical(
      stats::weighted.mean(
        subset[["mpg"]],
        subset[["wt"]]
      ),
      wm[as.character(cyl), as.character(vs)]
    )
  }
}

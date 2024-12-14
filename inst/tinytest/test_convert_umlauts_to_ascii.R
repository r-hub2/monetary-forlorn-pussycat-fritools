if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}
if (fritools::is_version_sufficient(
  fritools::get_package_version("base"),
  "4.0.0"
)) {
  if (interactive()) pkgload::load_all(".")

  string <- c(
    "\u00e4", "\u00c4", "\u00f6", "\u00d6", "\u00fc", "\u00dc",
    "\u00df"
  )
  expectation <- c("ae", "Ae", "oe", "Oe", "ue", "Ue", "sz")
  result <- convert_umlauts_to_ascii(string)
  expect_identical(result, expectation)
  df <- data.frame(
    v1 = c(string, "foobar"),
    v2 = c("foobar", string), v3 = 3:4
  )
  names(df)[3] <- "y\u00dfy"
  result <- convert_umlauts_to_ascii(df)
  expectation <-
    structure(list(
      v1 = c(
        "ae", "Ae", "oe", "Oe", "ue", "Ue", "sz",
        "foobar"
      ),
      v2 = c(
        "foobar", "ae", "Ae", "oe", "Oe", "ue", "Ue",
        "sz"
      ),
      yszy = c(3L, 4L, 3L, 4L, 3L, 4L, 3L, 4L)
    ),
    class = "data.frame", row.names = c(NA, -8L)
    )
  expect_identical(result, expectation)
}
if (interactive()) {

}

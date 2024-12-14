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
  expectation <- c(
    "\\\"a{}", "\\\"A{}", "\\\"o{}", "\\\"O{}", "\\\"u{}",
    "\\\"U{}", "\\ss{}"
  )
  result <- convert_umlauts_to_tex(string)
  expect_identical(result, expectation)
}
if (interactive()) {

}

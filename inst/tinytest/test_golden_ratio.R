if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


gr <- ((1 + sqrt(5)) / 2)
expectation <- list(a = 1, b = gr - 1)
result <- golden_ratio(gr)
expect_identical(result, expectation)

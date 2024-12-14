if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


n <- 1000
r <- replicate(n, get_unique_string())
expect_identical(length(r), length(unique(r)))

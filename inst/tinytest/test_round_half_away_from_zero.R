if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


x <- 22.5
expect_equal(round_half_away_from_zero(x), 23)
expect_equal(base::round(x), 22)
expect_equal(round_half_away_from_zero(-x), -23)
expect_equal(base::round(-x), -22)

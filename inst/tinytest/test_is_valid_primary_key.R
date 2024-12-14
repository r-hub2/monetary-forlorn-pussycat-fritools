if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


data(mtcars)
expect_true(!is_valid_primary_key(mtcars, "qsec"))
expect_true(!is_valid_primary_key(mtcars, "carb"))
expect_true(!is_valid_primary_key(mtcars, c("qsec", "gear")))
expect_true(is_valid_primary_key(mtcars, c("qsec", "carb")))
cars <- mtcars
cars[["id"]] <- seq_len(nrow(cars))
expect_true(is_valid_primary_key(cars, "id"))

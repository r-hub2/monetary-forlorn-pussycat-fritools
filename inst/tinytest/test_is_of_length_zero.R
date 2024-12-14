if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


x <- grep(" ", "")
expect_true(is_of_length_zero(x))
expect_true(!is_of_length_zero(x, "character"))
expect_true(is_of_length_zero(x, "numeric"))
expect_true(is_of_length_zero(x, "integer"))

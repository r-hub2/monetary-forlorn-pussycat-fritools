if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}

expect_error(fritools:::throw("Hello, error!"))

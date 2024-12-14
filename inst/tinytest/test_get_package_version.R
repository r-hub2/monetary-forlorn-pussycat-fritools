if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


v <- get_package_version("base")
expect_true(is(package_version(v), "package_version"))
expect_error(get_package_version("no_package"))

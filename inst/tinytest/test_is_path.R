if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


expect_true(is_path(tempdir()))
path <- tempfile()
expect_true(!is_path(path))
touch(path)
expect_true(is_path(path))

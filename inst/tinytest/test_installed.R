if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


if (is_running_on_fvafrcu_machines() || is_running_on_gitlab_com()) {
  # NOTE: There are CRAN machines where neither "R" nor "R-devel" is in
  # the path, so we skipt this test on unkown machines.
  expect_true(is_installed("R"))
}
expect_true(!is_installed("This_program_is_not_installed"))





expect_true(is_r_package_installed("fritools", "1.1.0"))
expect_true(!is_r_package_installed("fritools", "9999"))

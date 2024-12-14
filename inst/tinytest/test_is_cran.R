if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


result <- is_cran()
if (is_running_on_fvafrcu_machines()) {
  if (fritools::is_r_cmd_check()) {
    expect_true(strip_off_attributes(result))
  } else {
    expect_true(strip_off_attributes(!result))
  }
}

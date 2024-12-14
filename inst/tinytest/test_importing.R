if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}

if (get_run_r_tests() && !is_running_on_gitlab_com()) {
  path <- system.file("DESCRIPTION", package = "fritools")
  deps <- desc::desc_get_deps()
  result <- !any(deps[["type"]] == "Depends" & deps[["package"]] != "R")
  msg <- "fritools must only depend on R itself!"
  expect_true(result, info = msg)
  if (is_running_on_fvafrcu_machines()) {
      core <- row.names(installed.packages(priority = "base"))
      dput(core)
  } else {
      core <- c("base", "compiler", "datasets", "graphics", "grDevices", "grid",
                "methods", "parallel", "splines", "stats", "stats4", "tcltk",
                "tools", "utils")
  }
  result <- !any(deps[["type"]] == "Imports" %in% core)
  msg <- paste(
    "fritools must not import any package!",
    "You may suggest packages and use dem conditionally as I",
    "have done with checkmate, see fritools::is_not_false."
  )
  expect_true(result, info = msg)
}

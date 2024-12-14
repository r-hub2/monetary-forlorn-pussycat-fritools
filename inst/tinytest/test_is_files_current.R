if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


p1 <- tempfile()
p2 <- tempfile()
p3 <- tempfile()
touch(p1)
touch(p2)
Sys.sleep(2)
touch(p3)
# one file
expect_true(is_files_current(p3,
  newer_than = 1, units = "days",
  within = 4, within_units = "secs"
))
# more files
expect_true(is_files_current(p1, p2, p3,
  newer_than = 1,
  units = "days",
  within = 4, within_units = "secs"
))
# within not TRUE
expect_true(!is_files_current(p1, p2, p3,
  newer_than = 1,
  units = "days",
  within = 1, within_units = "secs"
))
# newer not TRUE
expect_true(!is_files_current(p1, p2, p3,
  newer_than = 1,
  units = "secs",
  within = 4, within_units = "secs"
))

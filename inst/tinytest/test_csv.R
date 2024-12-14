if (interactive()) {
  pkgload::load_all()
  library("tinytest")
} else {
  has_digest <- fritools:::has_digest
}




unlink(dir(tempdir(), full.names = TRUE))
cars <- mtcars[1:2, TRUE]
f <- file.path(tempdir(), paste0("cars_german", ".csv"))
utils::write.csv2(cars, file = f)
l <- readLines(f, n = 1)
n_semicolae <- length(unlist(strsplit(l, split = ";")))
n_commatae <- length(unlist(strsplit(l, split = ",")))
expect_true(n_semicolae >= n_commatae)
res <- csv2csv(f, row.names = 1)
expect_true(all.equal(
  strip_off_attributes(res),
  strip_off_attributes(cars)
))
l <- readLines(f, n = 1)
n_semicolae <- length(unlist(strsplit(l, split = ";")))
n_commatae <- length(unlist(strsplit(l, split = ",")))
expect_true(n_semicolae < n_commatae)







# % provide data
unlink(dir(tempdir(), full.names = TRUE))
f <- file.path(tempdir(), paste0("a", ".csv"))
cars <- mtcars[1:2, TRUE]
a <- write_csv(cars, file = f)
expect_true(file.exists(f))
if (fritools::is_running_on_fvafrcu_machines()) {
  expect_identical(strip_off_attributes(get_path(a)), f)
}

mtime <- file.info(f)[["mtime"]]
Sys.sleep(1)

# % read file, setup expectation
a <- read_csv(f)
expectation <-
  structure(list(
    mpg = c(21L, 21L), cyl = c(6L, 6L),
    disp = c(160L, 160L), hp = c(110L, 110L),
    drat = c(3.9, 3.9), wt = c(2.62, 2.875),
    qsec = c(16.46, 17.02), vs = c(0L, 0L), am = c(1L, 1L),
    gear = c(4L, 4L), carb = c(4L, 4L)
  ),
  class = "data.frame",
  row.names = c("Mazda RX4", "Mazda RX4 Wag"),
  csv = "standard",
  path = structure("/tmp/RtmpGyKumR/a.csv",
    mtime = structure(1638788464.61958,
      class = c(
        "POSIXct",
        "POSIXt"
      )
    ),
    last_read = structure(1639122705.98385,
      class = c(
        "POSIXct",
        "POSIXt"
      )
    ),
    last_written = NA
  ),
  hash = "062a5b662192887791002c72fd196426"
  )
if (!has_digest()) {
  expectation <- un_hash(expectation)[["object"]]
}

# % write
result <- write_csv(a)
## % check return
expect_identical(
  strip_off_attributes(expectation),
  strip_off_attributes(result)
)

## % no writing with digest
if (has_digest()) {
  expect_identical(mtime, file.info(f)[["mtime"]])
} else {
  expect_true(mtime < file.info(f)[["mtime"]])
}

## % modify data and write to disk
a[1, 3] <- 300
write_csv(a)

## % on a: hash not updated, still writing:
expect_true(mtime < file.info(f)[["mtime"]])
## % on result: hash already updated, not writing with digest:
mtime <- file.info(f)[["mtime"]]
Sys.sleep(1)
write_csv(result)
if (has_digest()) {
  expect_identical(mtime, file.info(f)[["mtime"]])
} else {
  expect_true(mtime < file.info(f)[["mtime"]])
}
if (has_digest()) {
  ## % We update the hash value:
  a <- set_hash(a)
  write_csv(a)
  expect_identical(mtime, file.info(f)[["mtime"]])
}







# % provide data
unlink(dir(tempdir(), full.names = TRUE))
data(mtcars)
mt_german <- mtcars
rownames(mt_german)[1] <- "Mazda R\u00f64"
names(mt_german)[1] <- "mg\u00dc"
for (i in 1:10) {
  f <- file.path(tempdir(), paste0("f", i, ".csv"))
  write.csv(mtcars[1:5, TRUE], file = f)
  f <- file.path(tempdir(), paste0("f", i, "_german.csv"))
  write.csv2(mt_german[1:7, TRUE], file = f, fileEncoding = "Latin1")
}
# % pass a path
f <- list.files(tempdir(), pattern = ".*\\.csv$", full.names = TRUE)[1]
bulk <- bulk_read_csv(f)
expect_identical(length(bulk), 1L)

# % pass multiple path
f <- list.files(tempdir(), pattern = ".*\\.csv$", full.names = TRUE)[2:4]
bulk <- bulk_read_csv(f)
expect_identical(length(bulk), 3L)

# % read
bulk <- bulk_read_csv(tempdir())
path <- structure("/tmp/RtmpGyKumR/f1.csv",
  mtime = structure(1638788464.61958,
    class = c("POSIXct", "POSIXt")
  ),
  last_read = structure(1639122705.98385,
    class = c("POSIXct", "POSIXt")
  ),
  last_written = NA
)
expectation <- structure(list(
  mpg = c(21, 21, 22.8, 21.4, 18.7),
  cyl = c(6L, 6L, 4L, 6L, 8L),
  disp = c(160L, 160L, 108L, 258L, 360L),
  hp = c(110L, 110L, 93L, 110L, 175L),
  drat = c(3.9, 3.9, 3.85, 3.08, 3.15),
  wt = c(2.62, 2.875, 2.32, 3.215, 3.44),
  qsec = c(16.46, 17.02, 18.61, 19.44, 17.02),
  vs = c(0L, 0L, 1L, 1L, 0L),
  am = c(1L, 1L, 1L, 0L, 0L),
  gear = c(4L, 4L, 4L, 3L, 3L),
  carb = c(4L, 4L, 1L, 1L, 2L)
),
class = "data.frame",
row.names = c(
  "Mazda RX4", "Mazda RX4 Wag",
  "Datsun 710", "Hornet 4 Drive",
  "Hornet Sportabout"
),
csv = "standard",
path = path,
hash = "9f8cabc0eaa06329b42d697642497a29"
)
if (!has_digest()) {
  expectation <- un_hash(expectation)[["object"]]
}
expect_identical(
  strip_off_attributes(bulk[["f1"]]),
  strip_off_attributes(expectation)
)

# % write
result <- bulk_write_csv(bulk)
expectation <- bulk
expect_identical(
  lapply(result, strip_off_attributes),
  lapply(expectation, strip_off_attributes)
)
dmtime <- file.info(list.files(tempdir(),
  full.names = TRUE,
  pattern = ".*\\.csv"
))["mtime"]
mtime <- lapply(bulk, get_mtime)
mtime <- as.data.frame(do.call(c, mtime))
expect_true(all(mtime == dmtime))

Sys.sleep(1)

bulk[["f2"]][3, 5] <- bulk[["f2"]][3, 5] + 2
result <- bulk_write_csv(bulk)
new_times <- file.info(dir(tempdir(), full.names = TRUE))["mtime"]
index_change <- which(rownames(mtime) == "f2")
if (has_digest()) {
  only_f2_changed <- all((dmtime == new_times)[-c(index_change)]) &&
    (dmtime < new_times)[c(index_change)]
  expect_true(only_f2_changed)
} else {
  expect_true(all(mtime < new_times))
}

# When a file is not read.
file.remove(f[1])
bulk <- bulk_read_csv(f)
expect_true(inherits(bulk[[1]], "error"))
expect_error(bulk_read_csv(f, stop_on_error = TRUE))

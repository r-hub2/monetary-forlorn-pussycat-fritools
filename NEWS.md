# fritools 4.3.0.9000

* Added `char2factor()`.
* Added `rownames2col()`.
* Added `pause()`
* Added `string2words()`.
* Added `get_session_string()`.
* Added `runsed()`.
* Added tests for `relative_difference()`.
* Harden testing for FVA against upper case user names.

# fritools 4.3.0

* Added `get_german_umlauts()`.

# fritools 4.2.0

* Added Sloboda's growth function: `sloboda()`.

# fritools 4.1.1

* Fixed CRAN notes on Escaped LaTeX specials.

# fritools 4.1.0

* Renamed the package to `fritools`.
* Add `rename_package()`.
* We do not check on the number of columns anymore since `utils::read.table()`
  seems do get the columns right anyways. However it manages.
* _`find_files()`: changed default to argument `pattern` 
  from `".*\\.[RrSs]$|.*\\.[RrSs]nw$"` to `NULL`_.
* Hardened `find_files()` against failing `pattern`s on windows.
* `is_running_on_fvafrcu_machines()` now has value `bwi` for argument `type`.
  This is `TRUE` for the nfi notebook only.
* Add function `grep_file()`.

# fritools 4.0.0

* Got rid of suggested packages `packager` and `rasciidoc`.
* Switched from RUnit to tinytest. Excluded RUnit tests from tarball due to CRAN
  requirement. I can still find them in 
  [(https://gitlab.com/fvafrcu/fritools/-/tree/master/inst/runit_tests)](https://gitlab.com/fvafrcu/fritools/-/tree/master/inst/runit_tests).


# fritools 3.7.0

* Changed argument order for `find_files()` from `names, path, pattern` to
  `path, pattern, names` for convenience.
* Added `relative_difference()`,  a convenience wrapper to `base::all.equal()`
* Added `column_sums()`, a convenience wrapper to `base::colSums()`.

# fritools 3.6.0

* `split_code_file()` now works with files with hidden functions (i.e. function
  whose names start with a period).
* Under unix, `clipboard_path()` now prints the path as `file.path` to the console.
* Added `count_groups()`, a specialized wrapper to `stats::aggregate()`, gives 
  results similar to `dplyr::count()`.

# fritools 3.5.1

* `view()` now normalizes the path first in order to deal with blanks in the
  path.
* Added example to vignette.
* Linted exhaustively.

# fritools 3.5.0

* Added `delete_trailing_blank_lines()`.
* `view()` now uses `base::shQuote()` under Unix.

# fritools 3.4.0

* Made `vim()` warn instead of throw when called non-interactively.
* `touch()` now digests paths to several files.
  Replaced argument `path` by `...` but the ui did not change.
* `vim()` now digests paths to several files.
  Replaced argument `file` by `...` but the ui did not change.
* `file_save()` now digests paths to several files.
  Replaced argument `x` by `...` but the ui did not change.
* `file_copy()` now digests paths to several files.
* Added `delete_trailing_whitespace()`.
* Added `develop_test()`.
* Added `wipe_tempdir()`.
* Added 'clipboard_path()` to help me with paths under Windows.
* `view()` now tries to use `program` only if it is installed.
* `is_files_current()` now warns, if any file is newer than `Sys.time()`.

# fritools 3.3.0

* Added `view()` as an unix equivalent to `shell.exec()`.
* Added `vim()` as a wrapper to `file.edit()`.
* Added `file_copy()` to force copying while backing up.
* Added `file_save()` to create backup copies for files.
* Added appropriate error messages to `fromto()` and allowing for NA in its
  arguments `from` and `to` to read from first item and to last item.

# fritools 3.2.0

* Added function `round_half_away_from_zero()` that implements commercial
  rounding.
* Added function `str2num()` to convert string representations of (potentially
  German) numbers.

# fritools 3.1.0

* Added a global option to pass `.GlobalEnv` as default environment to 
  `wipe_clean()`.
* Added calls to `Sys.sleep(1)` to unit testing to ensure that the files' time
  stamps are correct.

# fritools 3.0.0

## Major changes

* Added function `check_ascii_file()` to check for number of lines and fields of
  an ascii file.
  This is used to now check whether files read via `read_csv()` are read
  completely. Otherwise an error is thrown.
  `bulk_read_csv()` now knows an argument `stop_on_error` to stop reading if one
  of the files in the bulk fails to be read.

## Minor changes

* `set_path()` now adds reading and writing times to the path. So we can compare
  reading times with modification times on disk.
* Added argument `force` to `get_path()` to enable unit testing.

# fritools 2.5.0

* Added argument `differences_only` to function `compare_vectors()`.
* Added function `is_path`.
* Added function `fromto`.
* Added function `find_missing_see_also` and `find_missing_family`.
* Function `set_path` now sets a path attribute which itself has a file time
  modification date attribute.

# fritools 2.4.0

* Added argument `select` to function `find_files()`. This allows us to select
  files by their attributes, like file size. 
* Changed argument default for `recursive` for `find_files()` from `TRUE` to
  `FALSE`.

# fritools 2.3.0

* Added functions `is_files_current()` and `is_difftime_less()`.
* Added function `is_valid_primary_key()` from `wehamr`.
* Function `convert_umlauts_to_ascii()` now converts `rownames`, too.

# fritools 2.2.1

* Fixed function `convert_umlauts_to_tex()`.
* Fixed unit test that threw an error when running unit test on CRAN M1mac.

# fritools 2.2.0

* Added functions to read an write (bulks of) CSV files.
* Added `csv2csv()`, which converts German to standard CSV.

# fritools 2.1.0

* Added `convert_umlauts_to_ascii()`.
* Added `file_last_modified()`.
* Added `is_cran()`, a copy of `fda::CRAN()`.
* `touch()` now creates directories as needed.
* `get_path()` and `set_path()` now throw errors, if a path to get is not set or
  if a path to set is already set and argument `overwrite` is not `TRUE`.

# fritools 2.0.0

## Major changes
* `search_files()` now throws an error if no matches are found.

## Minor changes
* Added function `search_rows()`.
* Added function `is_success()`.
* Added function `convert_umlauts_to_tex()`.

# fritools 1.4.0

* Added function `split_code_file()`.
* Added function `weighted_variance()`.
* Added function `tapply()` to fix the base version which will not digest
  `data.frame`s as input.

# fritools 1.3.0

* Extended `is_running_on_fvafrcu_machines()` to catch a new machine.
* Added function `with_dir()` as this is often the only function I import from
  package `withr` making `withr` a dependency.
* Added function `get_boolean_envvar()`, `get_run_r_tests()` is
  now a wrapper to that.
* Added function `is_of_length_zero()`.
* Added function `get_unique_string()`.
* Added function `is_r_cmd_check()`.
* Added function `run_r_tests_for_known_hosts()`.
* Added functions `get_path()` and `set_path()`.
* The `matrix` returned by `compare_vectors` now has named rows.

# fritools 1.2.0

* Skipping tests for `search_files()` if R has not at least version 4.0.0.
* Added function `r_cmd_install()` as a quick alternative to `devtools::install()`.
  `devtools` calling `callr`, calling `processx::run` seemed too bloated for 
  such a simple task.
* Added function `compare_vectors()` which returns a side-by-side comparison of 
  two vectors.
* Updated test\_helper to recognize machines running at the Forest Research
  Institute of the state of Baden-Wuerttemberg.

# fritools 1.1.0

* Fixed buggy regular expression in `is_running_on_gitlab_com()`
* Added `get_options`, `set_options`, `is_force`; 
  `call_conditionally`, `call_safe`;
  `is_installed`, `is_r_package_installed`;
  `is_false`, `is_null_or_true`;
  `search_files`, `find_files`, `summary.filesearch` and
  `strip_off_attributes`
  from package `packager`.


# fritools 1.0.0

* Got the compilation of utilities from
   - rasciidoc/R/utils.R: *
   - packager/R/is\_version\_sufficient.R: *
   - rasciidoc/R/is\_version\_sufficient.R: *
   - document/R/test\_helpers.R: *
   - fakemake/R/tools.R: *
   - cleanr/R/utils.R: *
   - bundeswaldinventur/R/utils.R: golden\_ratio()
   - cuutils/R/utils.R: *
   - cuutils/R/?.R: ?
   - packager/R/package\_version.R





if (interactive()) {
    pkgload::load_all()
    library("tinytest")
}

file_paths <- list.files(path = system.file("tinytest", package = "fritools"),
                         pattern = ".*\\.R", full.names = TRUE)
file_paths <- grep("test_grep_file.R", file_paths, invert = TRUE, value = TRUE)
res <- grep_file(path = file_paths,
                 pattern = "forSureNotThere", a = 3, b = 2, ignore.case = TRUE)
tinytest::expect_true(all(res == FALSE))
result <- grep_file(path = file_paths, pattern = "^ *#", a = 1, b = 1,
                    ignore.case = TRUE)
expectation <- c("test_boolean.R", "test_call.R", "test_column_sums.R",
                 "test_compare_vectors.R",
                 "test_convert_umlauts_to_ascii.R",
                 "test_convert_umlauts_to_tex.R",
                 "test_count_groups.R", "test_csv.R",
                 "test_delete_trailing_blank_lines.R",
                 "test_delete_trailing_whitespace.R", "test_file_copy.R",
                 "test_file_modified_last.R",
                 "test_file_save.R", "test_find_files.R",
                 "test_find_missing_see_also.R",
                 "test_fritools.R", "test_fromto.R",
                 "test_get_package_version.R",
                 "test_get_unique_string.R", "test_golden_ratio.R",
                 "test_importing.R",
                 "test_installed.R", "test_is_cran.R",
                 "test_is_difftime_less.R",
                 "test_is_files_current.R", "test_is_of_length_zero.R",
                 "test_is_path.R",
                 "test_is_success.R", "test_is_valid_primary_key.R",
                 "test_is_version_sufficient.R",
                 "test_is_windows.R", "test_load_internal_functions.R",
                 "test_memory_hogs.R",
                 "test_options.R", "test_paths.R",
                 "test_round_half_away_from_zero.R",
                 "test_search_files.R", "test_search_rows.R",
                 "test_split_code_file.R",
                 "test_str2num.R", "test_strip_off_attributes.R",
                 "test_subsets.R",
                 "test_tapply.R", "test_test_helpers.R", "test_throw.R",
                 "test_touch.R",
                 "test_weighted_variance.R", "test_wipe_clean.R",
                 "test_with_dir.R"
                 )
tinytest::expect_true(all(expectation %in% basename(names(result))))

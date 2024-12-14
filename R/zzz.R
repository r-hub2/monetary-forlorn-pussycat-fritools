.onLoad <- function(libname, pkgname) { # Exclude Linting
    run_r_tests_for_known_hosts()
    options(wipe_clean_environment = .GlobalEnv)
}

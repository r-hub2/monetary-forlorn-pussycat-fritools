if (interactive()) pkgload::load_all(".")
test_FUNCTION <- function() {
    result <- FUNCTION(FIXME)
    expectation <- FIXME
    RUnit::checkIdentical(result, expectation)
}
if (interactive()) {
    test_FUNCTION()
}

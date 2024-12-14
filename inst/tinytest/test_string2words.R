if (interactive()) {
    pkgload::load_all()
    library("tinytest")
}

expectation <- "beech, oak and ash"
result <- string2words(c("beech", "oak", "ash"))
expect_identical(result, expectation)
expectation <- "beech,oakandash"
result <- string2words(c("beech", "oak", "ash"), add_whitespace = FALSE)
expect_identical(result, expectation)

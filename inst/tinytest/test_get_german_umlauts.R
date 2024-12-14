if (interactive()) {
    pkgload::load_all()
    library("tinytest")
}

expectation <- c(ae = "\u00E4", oe = "\u00F6", ue = "\u00FC",
                                 Ae ="\u00C4", Oe = "\u00D6", Ue = "\u00DC",
                                 sz = "\u00DF")
names(expectation) <- NULL
result <- get_german_umlauts()
expect_identical(result, expectation)
result <- get_german_umlauts(c("sz", "Ae"))
expect_identical(result, expectation[c(7, 4)])
expectation <- c( ae = "\u005C\u0022a{}", oe = "\u005C\u0022o{}",
                                 ue = "\u005C\u0022u{}", Ae = "\u005C\u0022A{}",
                                 Oe = "\u005C\u0022O{}", Ue = "\u005C\u0022U{}",
                                 sz = "\u005Css{}")
names(expectation) <- NULL
result <- get_german_umlauts(type = "latex")
expect_identical(result, expectation)

expect_error(get_german_umlauts(c("sz", "foo", "Ae", "bar")), pattern = "foo is no.*bar is no")

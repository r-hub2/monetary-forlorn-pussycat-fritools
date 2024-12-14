if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


data(mtcars)
cars <- rownames(mtcars)
carz <- cars[-grep("Merc", cars)]
cars <- cars[nchar(cars) < 15]
expectation <-
  structure(c(
    "AMC Javelin", NA, "Camaro Z28", NA, "Datsun 710",
    NA, "Duster 360", "Ferrari Dino", "Fiat 128", "Fiat X1-9",
    "Ford Pantera L",
    "Honda Civic", "Hornet 4 Drive", NA, NA, "Lotus Europa",
    "Maserati Bora",
    "Mazda RX4", "Mazda RX4 Wag", "Merc 230", "Merc 240D",
    "Merc 280",
    "Merc 280C", "Merc 450SE", "Merc 450SL", "Merc 450SLC", NA,
    "Porsche 914-2",
    "Toyota Corolla", "Toyota Corona", "Valiant", "Volvo 142E",
    "AMC Javelin",
    "Cadillac Fleetwood", "Camaro Z28", "Chrysler Imperial",
    "Datsun 710",
    "Dodge Challenger", "Duster 360", "Ferrari Dino",
    "Fiat 128",
    "Fiat X1-9", "Ford Pantera L", "Honda Civic",
    "Hornet 4 Drive",
    "Hornet Sportabout", "Lincoln Continental", "Lotus Europa",
    "Maserati Bora",
    "Mazda RX4", "Mazda RX4 Wag", NA, NA, NA, NA, NA, NA, NA,
    "Pontiac Firebird",
    "Porsche 914-2", "Toyota Corolla", "Toyota Corona",
    "Valiant",
    "Volvo 142E"
  ),
  .Dim = c(32L, 2L),
  .Dimnames = list(
    c(
      "AMC Javelin", "Cadillac Fleetwood",
      "Camaro Z28", "Chrysler Imperial",
      "Datsun 710", "Dodge Challenger",
      "Duster 360", "Ferrari Dino", "Fiat 128",
      "Fiat X1-9", "Ford Pantera L",
      "Honda Civic", "Hornet 4 Drive",
      "Hornet Sportabout", "Lincoln Continental",
      "Lotus Europa", "Maserati Bora",
      "Mazda RX4", "Mazda RX4 Wag", "Merc 230",
      "Merc 240D", "Merc 280", "Merc 280C",
      "Merc 450SE", "Merc 450SL", "Merc 450SLC",
      "Pontiac Firebird", "Porsche 914-2",
      "Toyota Corolla", "Toyota Corona",
      "Valiant", "Volvo 142E"
    ),
    c("cars", "carz")
  )
  )
result <- compare_vectors(cars, carz)
expect_identical(result, expectation)
expect_identical(
  sort(intersect(cars, carz)),
  row.names(result)[complete.cases(result)]
)

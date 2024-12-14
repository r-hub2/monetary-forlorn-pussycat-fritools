if (interactive()) {
  pkgload::load_all()
  library("tinytest")
}


foo <- c(
  "f1", "A", "f2", rep("B", 4), "t1", "f3", "C", "t2",
  rep("D", 4), "t3"
)
result <- fromto(foo, "^f", "^t")
expectation <- c("f1", "A", "f2", "B", "B", "B", "B", "t1")
expect_identical(result, expectation)

result <- fromto(foo, "^f", "^t", from_i = 2)
expectation <- c("f2", "B", "B", "B", "B", "t1")
expect_identical(result, expectation)

result <- fromto(foo, "^f", "^t", from_i = 2, to_i = 2)
expectation <- c("f2", "B", "B", "B", "B", "t1", "f3", "C", "t2")
expect_identical(result, expectation)

result <- fromto(foo, "^f", "^t",
  from_i = 2, to_i = 2, shift_from = 1,
  shift_to = -1
)
expectation <- c("B", "B", "B", "B", "t1", "f3", "C")
expect_identical(result, expectation)

result <- fromto(foo, "^f", "^t",
  from_i = 2, to_i = 2, shift_from = -1,
  shift_to = 2
)
expectation <- c(
  "A", "f2", "B", "B", "B", "B", "t1", "f3",
  "C", "t2", "D", "D"
)
expect_identical(result, expectation)
# give NA
foo <- c(
  "f1", "A", "f2", rep("B", 4), "t1", "f3", "C", "t2",
  rep("D", 4), "t3"
)
result <- fromto(foo, "^A", "^B", to_i = 3)
expectation <- c("A", "f2", "B", "B", "B")
expect_identical(result, expectation)

result <- fromto(foo, NA, "^B", to_i = 3)
expectation <- c("f1", "A", "f2", "B", "B", "B")
expect_identical(result, expectation)

result <- fromto(foo, NA, NA, to_i = 3)
expectation <- foo
expect_identical(result, expectation)

expect_error(fromto(x = foo, from = "^Not_there", to = "B"))
expect_error(fromto(x = foo, from = NA, to = "^Not_there"))

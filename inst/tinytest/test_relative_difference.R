if (interactive()) {
    pkgload::load_all()
    library("tinytest")
}

n <- 10
set.seed(1235234)
x <- rnorm(n)
y <- x + rnorm(n, sd = 0.0001)

expectation <- c(0.0001526129, 0.0002144986, 2.015898e-05, 4.770634e-05, 8.002617e-05, 
0.0005593562, 0.0005412592, 0.0004308844, 0.0007256816, 0.005457296)
result <- relative_difference(x, y)
expect_equal(result, expectation)
result <- relative_difference(x, y, type = "all.equal")
expect_equal(result, expectation)
expectation <- c(0.00015262451169963, 0.000214475596318681, 2.015877609855e-05, 
4.77051995154432e-05, 8.00229661082034e-05, 0.000559512649256763, 
0.000541405761235337, 0.000430791544304639, 0.000725945016756263, 
0.00544244542045673)
result <- relative_difference(x, y, type = "difference")
expect_equal(result, expectation)
expectation <- c(-0.000152612865467594, 0.000214498598676112, -2.0158979288725e-05, 
4.7706337435616e-05, 8.00261680738711e-05, -0.000559356165831652, 
-0.000541259240799691, -0.000430884354972987, 0.000725681614280444, 
0.00545729593809993)
result <- relative_difference(x, y, type = "change")
expect_equal(result, expectation)

expect_equal(relative_difference(0, 0, type = "change"), 0)
expect_equal(relative_difference(0, 0, type = "difference"), 0)

expect_equal(relative_difference(3, 0, type = "change"), Inf)
expect_equal(relative_difference(-5, 0, type = "change"), -Inf)

expect_equal(relative_difference(5, 0, type = "difference"), 2)
expect_equal(relative_difference(-3, 0, type = "difference"), 2)

expect_equal(relative_difference(0, 0, type = "change2"), 0)
expect_equal(relative_difference(5, 0, type = "change2"), 2)
expect_equal(relative_difference(0, 5, type = "change2"), -2)
expect_equal(relative_difference(-5, 0, type = "change2"), -2)
expect_equal(relative_difference(0, -5, type = "change2"), 2)


test_that("dist_cdf() returns the right base-R CDF per family", {
  expect_identical(dist_cdf(Gamma(shape = 1, rate = 1)), pgamma)
  expect_identical(dist_cdf(LogNormal(meanlog = 0, sdlog = 1)), plnorm)
  expect_identical(dist_cdf(Normal(mean = 0, sd = 1)), pnorm)
  expect_identical(dist_cdf(Exponential(rate = 1)), pexp)
  expect_identical(dist_cdf(Weibull(shape = 1, scale = 1)), pweibull)
})

test_that("dist_quantile() returns the right base-R quantile function per family", {
  expect_identical(dist_quantile(Gamma(shape = 1, rate = 1)), qgamma)
  expect_identical(dist_quantile(LogNormal(meanlog = 0, sdlog = 1)), qlnorm)
  expect_identical(dist_quantile(Normal(mean = 0, sd = 1)), qnorm)
  expect_identical(dist_quantile(Exponential(rate = 1)), qexp)
  expect_identical(dist_quantile(Weibull(shape = 1, scale = 1)), qweibull)
})

test_that("dist_cdf() and dist_quantile() error for a distribution with no method", {
  expect_error(dist_cdf(Dirichlet(c(1, 1, 1))), "has no CDF")
  expect_error(dist_quantile(Dirichlet(c(1, 1, 1))), "has no quantile function")
})

test_that("dist_quantile() inverts dist_cdf() for a fitted distribution", {
  d <- Gamma(shape = 3, rate = 2)
  params <- get_parameters(d)
  q <- do.call(dist_quantile(d), c(list(p = 0.3), params))
  p <- do.call(dist_cdf(d), c(list(q = q), params))
  expect_equal(p, 0.3)
})

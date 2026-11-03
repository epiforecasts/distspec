test_that("family_cdf() returns the right base-R CDF per family", {
  expect_identical(family_cdf(Gamma(shape = 1, rate = 1)), pgamma)
  expect_identical(family_cdf(LogNormal(meanlog = 0, sdlog = 1)), plnorm)
  expect_identical(family_cdf(Normal(mean = 0, sd = 1)), pnorm)
  expect_identical(family_cdf(Exponential(rate = 1)), pexp)
  expect_identical(family_cdf(Weibull(shape = 1, scale = 1)), pweibull)
})

test_that("family_quantile() returns the right base-R quantile function per family", {
  expect_identical(family_quantile(Gamma(shape = 1, rate = 1)), qgamma)
  expect_identical(family_quantile(LogNormal(meanlog = 0, sdlog = 1)), qlnorm)
  expect_identical(family_quantile(Normal(mean = 0, sd = 1)), qnorm)
  expect_identical(family_quantile(Exponential(rate = 1)), qexp)
  expect_identical(family_quantile(Weibull(shape = 1, scale = 1)), qweibull)
})

test_that("family_cdf() and family_quantile() error for a distribution with no method", {
  expect_error(family_cdf(Dirichlet(c(1, 1, 1))), "has no CDF")
  expect_error(
    family_quantile(Dirichlet(c(1, 1, 1))), "has no quantile function"
  )
})

test_that("family_quantile() inverts family_cdf() for a fitted distribution", {
  d <- Gamma(shape = 3, rate = 2)
  params <- get_parameters(d)
  q <- do.call(family_quantile(d), c(list(p = 0.3), params))
  p <- do.call(family_cdf(d), c(list(q = q), params))
  expect_equal(p, 0.3)
})

test_that("dist_cdf() and dist_quantile() are deprecated but still work", {
  d <- Gamma(shape = 1, rate = 1)
  lifecycle::expect_deprecated(expect_identical(dist_cdf(d), pgamma))
  lifecycle::expect_deprecated(expect_identical(dist_quantile(d), qgamma))
})

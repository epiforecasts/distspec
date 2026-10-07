test_that("quantile of an unbounded distribution matches the base R quantile function", {
  dist <- Gamma(shape = 2, rate = 1)
  probs <- c(0.05, 0.5, 0.95)
  expect_equal(quantile(dist, probs), qgamma(probs, shape = 2, rate = 1))
})

test_that("quantile respects the `max` bound", {
  dist <- Gamma(shape = 2, rate = 1, max = 3)
  probs <- c(0, 0.25, 0.5, 0.75, 1)
  truncated <- qgamma(probs * pgamma(3, shape = 2, rate = 1), shape = 2, rate = 1)
  expect_equal(quantile(dist, probs), truncated)
  expect_equal(quantile(dist, 1), 3)
})

test_that("quantile respects the `cdf_max` bound", {
  dist <- bound_dist(Gamma(shape = 2, rate = 1), cdf_max = 0.9)
  cutoff <- qgamma(0.9, shape = 2, rate = 1)
  expect_equal(quantile(dist, 1), cutoff)
  expect_equal(quantile(dist, 0.5), qgamma(0.45, shape = 2, rate = 1))
})

test_that("quantile applies the tighter of `max` and `cdf_max`", {
  max_binds <- bound_dist(Gamma(shape = 2, rate = 1, max = 3), cdf_max = 0.99)
  expect_equal(quantile(max_binds, 1), 3)
  cdf_binds <- bound_dist(Gamma(shape = 2, rate = 1, max = 10), cdf_max = 0.8)
  expect_equal(quantile(cdf_binds, 1), qgamma(0.8, shape = 2, rate = 1))
})

test_that("quantile doesn't collapse for a bound deep in the tail", {
  ## pnorm(20, 100, 1) underflows to 0 in double precision
  dist <- Normal(mean = 100, sd = 1, max = 20)
  q <- quantile(dist, c(0.1, 0.9))
  expect_true(all(is.finite(q)))
  expect_true(all(q <= 20))
})

test_that("quantile of a fixed distribution always returns its value", {
  expect_equal(quantile(Fixed(3), c(0, 0.1, 0.5, 0.9, 1)), rep(3, 5))
})

test_that("quantile errors on a distribution with uncertain parameters", {
  uncertain <- LogNormal(meanlog = Normal(3, 0.5), sdlog = 1)
  expect_error(quantile(uncertain, 0.5), "fixed parameters")
})

test_that("quantile errors on distributions with no quantile function", {
  expect_error(quantile(Beta(shape1 = 2, shape2 = 5), 0.5), "quantile")
  expect_error(
    quantile(NonParametric(c(0.1, 0.2, 0.7)), 0.5),
    "nonparametric"
  )
})

test_that("quantile validates probs", {
  dist <- Gamma(shape = 2, rate = 1)
  expect_error(quantile(dist, -0.1), "\\[0, 1\\]")
  expect_error(quantile(dist, 1.1), "\\[0, 1\\]")
  expect_error(quantile(dist, NA), "\\[0, 1\\]")
})

test_that("quantile of a composite returns a matrix of per-component quantiles", {
  composite <- Gamma(shape = 2, rate = 1) + Exponential(rate = 1)
  probs <- c(0.1, 0.5, 0.9)
  q <- quantile(composite, probs)
  expect_true(is.matrix(q))
  expect_equal(dim(q), c(3, 2))
  expect_equal(q[, 1], qgamma(probs, shape = 2, rate = 1))
  expect_equal(q[, 2], qexp(probs, rate = 1))
})

test_that("quantile errors on a bound set on a composite as a whole", {
  bounded <- bound_dist(
    Gamma(shape = 2, rate = 1) + Gamma(shape = 3, rate = 1), max = 4
  )
  expect_error(quantile(bounded, 0.5), "bound of its own")
})

test_that("cdf of an unbounded distribution matches the base R CDF function", {
  dist <- Gamma(shape = 2, rate = 1)
  q <- c(0.5, 1, 2)
  expect_equal(cdf(dist, q), pgamma(q, shape = 2, rate = 1))
})

test_that("cdf respects the `max` bound", {
  dist <- Gamma(shape = 2, rate = 1, max = 3)
  q <- c(0.5, 1, 2, 3, 4)
  expected <- pmin(pgamma(q, shape = 2, rate = 1) / pgamma(3, shape = 2, rate = 1), 1)
  expect_equal(cdf(dist, q), expected)
  expect_equal(cdf(dist, 3), 1)
  expect_equal(cdf(dist, 10), 1)
})

test_that("cdf respects the `cdf_max` bound", {
  dist <- bound_dist(Gamma(shape = 2, rate = 1), cdf_max = 0.9)
  cutoff <- qgamma(0.9, shape = 2, rate = 1)
  expect_equal(cdf(dist, cutoff), 1)
})

test_that("cdf and quantile are inverses of one another on a bounded distribution", {
  dist <- Gamma(shape = 2, rate = 1, max = 3)
  probs <- c(0.05, 0.3, 0.7, 0.95)
  expect_equal(cdf(dist, quantile(dist, probs)), probs)
})

test_that("cdf of a fixed distribution is a step function", {
  expect_equal(cdf(Fixed(3), c(2, 2.9, 3, 4)), c(0, 0, 1, 1))
})

test_that("cdf errors on a distribution with uncertain parameters", {
  uncertain <- LogNormal(meanlog = Normal(3, 0.5), sdlog = 1)
  expect_error(cdf(uncertain, 1), "fixed parameters")
})

test_that("cdf of a composite returns a matrix of per-component values", {
  composite <- Gamma(shape = 2, rate = 1) + Exponential(rate = 1)
  q <- c(1, 2)
  result <- cdf(composite, q)
  expect_true(is.matrix(result))
  expect_equal(dim(result), c(2, 2))
  expect_equal(result[, 1], pgamma(q, shape = 2, rate = 1))
  expect_equal(result[, 2], pexp(q, rate = 1))
})

test_that("cdf errors on a bound set on a composite as a whole", {
  bounded <- bound_dist(
    Gamma(shape = 2, rate = 1) + Gamma(shape = 3, rate = 1), max = 4
  )
  expect_error(cdf(bounded, 1), "bound of its own")
})

test_that("Exp() is deprecated in favour of Exponential()", {
  lifecycle::expect_deprecated(Exp(rate = 1))
  expect_equal(
    suppressWarnings(Exp(rate = 1)),
    Exponential(rate = 1)
  )
  expect_s3_class(suppressWarnings(Exp(rate = 1)), "dist_spec")
})

test_that("cdf_max below 0.5 is rejected with a helpful error", {
  expect_error(
    bound_dist(Gamma(mean = 4, sd = 1), cdf_max = 0.01),
    "keep less than half"
  )
  expect_error(
    Gamma(mean = 4, sd = 1, cdf_max = 0.01),
    "keep less than half"
  )
  expect_error(
    bound_dist(Gamma(mean = 4, sd = 1), cdf_max = 1.5),
    "must be a single number"
  )
})

test_that("cdf_cutoff is deprecated in favour of cdf_max", {
  lifecycle::expect_deprecated(
    bound_dist(Gamma(mean = 4, sd = 1), cdf_cutoff = 0.999),
    "cdf_max"
  )
  lifecycle::expect_deprecated(
    Gamma(mean = 4, sd = 1, cdf_cutoff = 0.999),
    "cdf_max"
  )
  ## the value is interpreted as cdf_max, so the result is identical
  expect_equal(
    suppressWarnings(Gamma(mean = 4, sd = 1, cdf_cutoff = 0.999)),
    Gamma(mean = 4, sd = 1, cdf_max = 0.999)
  )
  lifecycle::expect_deprecated(
    new_dist_spec(
      params = list(mean = 2, sd = 1), distribution = "normal",
      cdf_cutoff = 0.999
    ),
    "cdf_max"
  )
  ## a tail-probability-to-drop value still lands in the below-0.5 guard
  expect_error(
    suppressWarnings(Gamma(mean = 4, sd = 1, cdf_cutoff = 0.001)),
    "keep less than half"
  )
})

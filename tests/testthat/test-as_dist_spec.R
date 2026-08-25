test_that("as_dist_spec() returns a <dist_spec> unchanged", {
  dist <- Gamma(mean = 4, sd = 1)
  expect_identical(as_dist_spec(dist), dist)
  composite <- Gamma(mean = 4, sd = 1) + LogNormal(meanlog = 1, sdlog = 0.5)
  expect_identical(as_dist_spec(composite), composite)
})

test_that("as_dist_spec() converts a PMF vector to a nonparametric", {
  pmf <- c(0.1, 0.4, 0.3, 0.2)
  expect_equal(as_dist_spec(pmf), NonParametric(pmf = pmf))
  ## integer vectors dispatch to the numeric method
  expect_equal(
    suppressWarnings(as_dist_spec(c(1L, 2L, 1L))),
    suppressWarnings(NonParametric(pmf = c(1, 2, 1)))
  )
})

test_that("as_dist_spec() converts a single number to a fixed distribution", {
  expect_equal(as_dist_spec(3), Fixed(3))
  expect_equal(as_dist_spec(0), Fixed(0))
})

test_that("as_dist_spec() passes bounds on to the constructor", {
  pmf <- c(0.1, 0.4, 0.3, 0.2)
  expect_equal(as_dist_spec(pmf, max = 2), NonParametric(pmf = pmf, max = 2))
})

test_that("as_dist_spec() errors informatively on unsupported classes", {
  expect_error(as_dist_spec("gamma"), "character")
  expect_error(as_dist_spec(list(shape = 2)), "list")
  expect_error(as_dist_spec(TRUE), "logical")
})

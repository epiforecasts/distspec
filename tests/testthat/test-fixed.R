test_that("dist_spec discretises a fixed distribution", {
  expect_equal(get_pmf(discretise(Fixed(value = 3))), c(0, 0, 0, 1))
  ## fractional fixed values split probability across adjacent intervals
  expect_equal(get_pmf(discretise(Fixed(value = 2.5))), c(0, 0, 0.5, 0.5))
  expect_equal(get_pmf(discretise(Fixed(value = 1.25))), c(0, 0.75, 0.25))
  expect_equal(get_parameters(Fixed(value = 3.5))$value, 3.5)
})

test_that("a fixed distribution accepts a value of zero", {
  zero <- Fixed(value = 0)
  expect_identical(lower_bounds(zero), c(value = 0))
  expect_equal(mean(zero), 0)
  expect_equal(sd(zero), 0)
  expect_equal(get_pmf(discretise(Fixed(value = 0))), 1)
})

test_that("a fixed distribution rejects a value below its lower bound", {
  expect_error(Fixed(value = -1), "lower bound")
  expect_error(Fixed(value = -0.5), "lower bound")
  ## an uncertain value is bound-checked when sampled, not at construction
  expect_no_error(Fixed(value = Normal(0.3, 0.05)))
  ## the same bound is enforced when a zero-sd normal collapses to fixed
  expect_error(Normal(-3, 0), "lower bound")
  expect_no_error(Normal(3, 0))
})

test_that("an uncertain fixed value is not truncated below one when sampled", {
  set.seed(1)
  ## with the old lower bound of 1 the sampled value would be truncated at 1
  sampled <- fix_parameters(
    Fixed(value = Normal(0.3, 0.05)), strategy = "sample"
  )
  expect_lt(get_parameters(sampled)$value, 1)
})

test_that("bounding a fixed distribution keeps the PMF valid", {
  ## a max that would drop all mass at discretisation is rejected upfront,
  ## including the integer edge case where the value has no bin below max
  expect_error(Fixed(6, max = 5), "drop all probability mass")
  expect_error(Fixed(5, max = 5), "drop all probability mass")
  expect_error(Fixed(4.5, max = 4), "drop all probability mass")
  ## the smallest max the guard admits discretises fine
  expect_equal(get_pmf(discretise(Fixed(3, max = 4))), c(0, 0, 0, 1))
  ## partial truncation of a fractional point mass renormalises
  expect_equal(get_pmf(discretise(Fixed(4.5, max = 5))), c(0, 0, 0, 0, 1))
  ## the discretisation backstop errors if a doomed bound arrives by attribute
  doomed <- Fixed(5)
  attr(doomed, "max") <- 5
  expect_error(discretise(doomed), "leaves no probability")
})

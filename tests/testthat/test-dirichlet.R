test_that("Dirichlet works with alpha vector", {
  alpha <- c(1, 2, 3)
  result <- Dirichlet(alpha)
  expect_s3_class(result, "dist_spec")
  expect_equal(get_distribution(result), "dirichlet")
  expect_equal(get_parameters(result)$alpha, alpha)
  expect_equal(mean(result), alpha / sum(alpha))
})

test_that("Dirichlet works with prior and concentration", {
  prior <- c(0.1, 0.3, 0.4, 0.2)
  conc <- 10
  result <- Dirichlet(prior = prior, concentration = conc)
  expect_s3_class(result, "dist_spec")
  expect_equal(get_distribution(result), "dirichlet")
  expect_equal(get_parameters(result)$alpha, conc * prior / sum(prior))
  expect_equal(mean(result), prior / sum(prior))
})

test_that("Dirichlet rejects a bad numeric prior and warns on an un-normalised one", {
  expect_error(Dirichlet(prior = c(0.5, -0.1, 0.6), concentration = 10),
    "negative"
  )
  expect_error(Dirichlet(prior = c(0.5, NA, 0.5), concentration = 10), "finite")
  expect_error(Dirichlet(prior = c(0, 0, 0), concentration = 10), "all zero")
  ## an un-normalised prior is normalised, but warns
  expect_warning(
    Dirichlet(prior = c(1, 2, 1), concentration = 10), "does not sum to 1"
  )
  expect_no_warning(
    Dirichlet(prior = c(0.25, 0.5, 0.25), concentration = 10)
  )
})

test_that("Dirichlet works with dist_spec prior", {
  dist <- LogNormal(meanlog = 1, sdlog = 0.5, max = 10)
  result <- Dirichlet(prior = dist, concentration = 5)
  expect_s3_class(result, "dist_spec")
  expect_equal(get_distribution(result), "dirichlet")
  expected_pmf <- get_pmf(discretise(dist))
  expect_equal(mean(result), expected_pmf)
  expect_equal(get_parameters(result)$alpha, 5 * expected_pmf)
})

# Nonparametric distribution

A nonparametric distribution as a `<dist_spec>`, defined directly by its
probability mass function. The PMF can instead be left uncertain by
passing a
[`Dirichlet()`](https://epiforecasts.io/distspec/dev/reference/Dirichlet.md)
prior.

## Usage

``` r
NonParametric(pmf, ...)
```

## Arguments

- pmf:

  Probability mass function, as a zero-indexed numeric vector (the first
  entry is the mass at zero) or a `<dist_spec>` (e.g. from
  [`Dirichlet()`](https://epiforecasts.io/distspec/dev/reference/Dirichlet.md)).
  A numeric vector is normalised to sum to one.

- ...:

  Limits of the distribution, passed to
  [`bound_dist()`](https://epiforecasts.io/distspec/dev/reference/bound_dist.md).

## Value

A `<dist_spec>`.

## Details

A distribution constructed with a
[`Dirichlet()`](https://epiforecasts.io/distspec/dev/reference/Dirichlet.md)
prior has no concrete PMF, in the same way that
`Gamma(shape = Normal(3, 0.5), rate = 2)` has an uncertain `shape` in
place of a fixed value.
[`get_pmf()`](https://epiforecasts.io/distspec/dev/reference/get_pmf.md)
errors and
[`has_uncertainty()`](https://epiforecasts.io/distspec/dev/reference/has_uncertainty.md)
returns `TRUE` until
[`fix_parameters()`](https://epiforecasts.io/distspec/dev/reference/fix_parameters.md)
resolves the prior into a PMF (e.g. with `strategy = "mean"`).

## See also

[Distributions](https://epiforecasts.io/distspec/dev/reference/Distributions.md)
for an overview and the other distributions.

## Examples

``` r
NonParametric(c(0.1, 0.3, 0.2, 0.4))
#> - nonparametric distribution
#>   PMF: [0.1 0.3 0.2 0.4]

# With a Dirichlet prior (PMF left uncertain)
NonParametric(pmf = Dirichlet(c(1, 1, 1, 1)))
#> - nonparametric distribution:
#>   pmf:
#>     - dirichlet distribution:
#>       alpha:
#>         1 1 1 1
```

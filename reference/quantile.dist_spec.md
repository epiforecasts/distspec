# Returns quantiles of a delay distribution

Computes quantiles of a `<dist_spec>` with fixed (non-uncertain)
parameters, respecting any `max`/`cdf_max` bound set with
[`bound_dist()`](https://epiforecasts.io/distspec/reference/bound_dist.md):
the quantiles are those of the truncated distribution, not the unbounded
one. A [`Fixed()`](https://epiforecasts.io/distspec/reference/Fixed.md)
(point-mass) distribution has every quantile equal to its value.

Only a distribution with fixed parameters can have its quantiles
computed. If any parameter is itself a distribution (a prior), there is
no single distribution to compute quantiles of and an error is raised;
resolve it first with
[`fix_parameters()`](https://epiforecasts.io/distspec/reference/fix_parameters.md).

A composite (multi-component) distribution returns one set of quantiles
per component, in keeping with
[`mean()`](https://rdrr.io/r/base/mean.html)/[`sd()`](https://epiforecasts.io/distspec/reference/sd.md),
which also return one value per component. A `max`/`cdf_max` bound set
on the composite itself (with
[`bound_dist()`](https://epiforecasts.io/distspec/reference/bound_dist.md)
on the sum) refers to that combined distribution, which has no
closed-form quantile function, so this raises an error. Bound the
components individually to get their quantiles under a bound.

## Usage

``` r
# S3 method for class 'dist_spec'
quantile(x, probs = seq(0, 1, 0.25), ...)

# S3 method for class 'multi_dist_spec'
quantile(x, probs = seq(0, 1, 0.25), ...)
```

## Arguments

- x:

  A `<dist_spec>` with fixed parameters.

- probs:

  Numeric vector of probabilities in `[0, 1]`.

- ...:

  Not used.

## Value

For a single distribution, a numeric vector of quantiles the same length
as `probs`. For a composite distribution of `k` components, a
`length(probs)` by `k` matrix, one column per component.

## See also

[`cdf()`](https://epiforecasts.io/distspec/reference/cdf.md) for the
corresponding cumulative distribution function, and
[`fix_parameters()`](https://epiforecasts.io/distspec/reference/fix_parameters.md)
to resolve an uncertain distribution first.

## Examples

``` r
# Quantiles of a fixed-parameter gamma distribution
quantile(Gamma(shape = 2, rate = 1), c(0.05, 0.5, 0.95))
#> [1] 0.3553615 1.6783470 4.7438645

# A `max` bound truncates the quantiles accordingly
quantile(Gamma(shape = 2, rate = 1, max = 3), c(0.05, 0.5, 0.95))
#> [1] 0.3137584 1.3776470 2.7530668

# A fixed (point-mass) distribution: every quantile equals its value
quantile(Fixed(3), c(0.1, 0.9))
#> [1] 3 3
```

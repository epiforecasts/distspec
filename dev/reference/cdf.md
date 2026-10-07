# Returns the cumulative distribution function of a delay distribution

Evaluates the CDF of a `<dist_spec>` with fixed (non-uncertain)
parameters at the given values, respecting any `max`/`cdf_max` bound set
with
[`bound_dist()`](https://epiforecasts.io/distspec/dev/reference/bound_dist.md):
this is the CDF of the truncated distribution, not the unbounded one, so
it is `1` for any value at or beyond the bound. A
[`Fixed()`](https://epiforecasts.io/distspec/dev/reference/Fixed.md)
(point-mass) distribution has a step-function CDF: `0` below its value
and `1` at or above it.

Only a distribution with fixed parameters can have its CDF evaluated. If
any parameter is itself a distribution (a prior), there is no single
distribution to evaluate and an error is raised; resolve it first with
[`fix_parameters()`](https://epiforecasts.io/distspec/dev/reference/fix_parameters.md).

A composite (multi-component) distribution returns one set of values per
component, in keeping with
[`mean()`](https://rdrr.io/r/base/mean.html)/[`sd()`](https://epiforecasts.io/distspec/dev/reference/sd.md)/[`quantile.dist_spec()`](https://epiforecasts.io/distspec/dev/reference/quantile.dist_spec.md).
A `max`/`cdf_max` bound set on the composite itself (with
[`bound_dist()`](https://epiforecasts.io/distspec/dev/reference/bound_dist.md)
on the sum) refers to that combined distribution, which has no
closed-form CDF, so this raises an error. Bound the components
individually to evaluate their CDF under a bound.

## Usage

``` r
cdf(x, ...)

# S3 method for class 'dist_spec'
cdf(x, q, ...)

# S3 method for class 'multi_dist_spec'
cdf(x, q, ...)
```

## Arguments

- x:

  A `<dist_spec>` with fixed parameters.

- ...:

  Not used.

- q:

  Numeric vector of values to evaluate the CDF at.

## Value

For a single distribution, a numeric vector the same length as `q`. For
a composite distribution of `k` components, a `length(q)` by `k` matrix,
one column per component.

## See also

[`quantile.dist_spec()`](https://epiforecasts.io/distspec/dev/reference/quantile.dist_spec.md)
for the corresponding quantile function, and
[`fix_parameters()`](https://epiforecasts.io/distspec/dev/reference/fix_parameters.md)
to resolve an uncertain distribution first.

## Examples

``` r
# The CDF of a fixed-parameter gamma distribution
cdf(Gamma(shape = 2, rate = 1), c(1, 2, 3))
#> [1] 0.2642411 0.5939942 0.8008517

# A `max` bound truncates the CDF accordingly: it reaches 1 at the bound
cdf(Gamma(shape = 2, rate = 1, max = 3), c(1, 2, 3))
#> [1] 0.3299501 0.7417030 1.0000000

# A fixed (point-mass) distribution has a step-function CDF
cdf(Fixed(3), c(2, 3, 4))
#> [1] 0 1 1
```

# Quantile function respecting a `max`/`cdf_max` bound

Used by
[`quantile.dist_spec()`](https://epiforecasts.io/distspec/reference/quantile.dist_spec.md).
If `x` is unconstrained this just calls the unbounded quantile function
`dist_quantile(x)`. Otherwise it computes the quantile of the truncated
distribution exactly: `F_trunc^{-1}(p) = F^{-1}(p * F(upper))`, where
`upper` is the smaller of `max` and the `cdf_max` quantile (see
[`log_upper_bound()`](https://epiforecasts.io/distspec/reference/log_upper_bound.md)).
This mirrors
[`sample_bounded()`](https://epiforecasts.io/distspec/reference/sample_bounded.md),
but for a requested probability `p` instead of a uniform draw.

## Usage

``` r
quantile_bounded(x, probs)
```

## Arguments

- x:

  A single (non-composite) `<dist_spec>` with fixed parameters.

- probs:

  Numeric vector of probabilities in `[0, 1]`.

## Value

A numeric vector of quantiles, the same length as `probs`.

# CDF respecting a `max`/`cdf_max` bound

Used by
[`cdf.dist_spec()`](https://epiforecasts.io/distspec/reference/cdf.md).
If `x` is unconstrained this just calls the unbounded CDF `dist_cdf(x)`.
Otherwise it computes the CDF of the truncated distribution:
`F_trunc(q) = F(q) / F(upper)`, capped at `1` for `q` at or beyond
`upper` (see
[`log_upper_bound()`](https://epiforecasts.io/distspec/reference/log_upper_bound.md)).

## Usage

``` r
cdf_bounded(x, q)
```

## Arguments

- x:

  A single (non-composite) `<dist_spec>` with fixed parameters.

- q:

  Numeric vector of values to evaluate the CDF at.

## Value

A numeric vector, the same length as `q`.

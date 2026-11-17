# Get a distribution's CDF or quantile function

**\[deprecated\]**

`dist_cdf()` and `dist_quantile()` are deprecated because they ignore
any `max`/`cdf_max` bound set with
[`bound_dist()`](https://epiforecasts.io/distspec/reference/bound_dist.md).
Use [`cdf()`](https://epiforecasts.io/distspec/reference/cdf.md) and
[quantile()](https://epiforecasts.io/distspec/reference/quantile.dist_spec.md)
instead, which respect the bound.

## Usage

``` r
dist_cdf(x)

dist_quantile(x)
```

## Arguments

- x:

  A `<dist_spec>`.

## Value

A function.

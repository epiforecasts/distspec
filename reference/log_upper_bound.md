# Log of `F(upper)` for a `max`/`cdf_max` bound

Shared by
[`quantile_bounded()`](https://epiforecasts.io/distspec/reference/quantile_bounded.md)
and
[`cdf_bounded()`](https://epiforecasts.io/distspec/reference/cdf_bounded.md):
`upper` is the smaller of `max` and the `cdf_max` quantile. This returns
`log F(upper)`, computed on the log scale throughout, so a bound deep in
the tail (where `F(upper)` underflows to zero in double precision) still
gives the correct value instead of collapsing onto the support boundary.

## Usage

``` r
log_upper_bound(x, params, cdf)
```

## Arguments

- x:

  A single (non-composite) `<dist_spec>` with fixed parameters.

- params:

  The result of `get_parameters(x)`.

- cdf:

  The family's CDF function, as returned by `dist_cdf(x)`.

## Value

A single numeric value, `log F(upper)`.

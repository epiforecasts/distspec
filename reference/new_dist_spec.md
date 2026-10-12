# Internal function for generating a `dist_spec` given parameters and a distribution.

This will convert all parameters to natural parameters before generating
a `dist_spec`. If they are uncertain the uncertainty is propagated to
the natural parameters with a first-order (delta-method) approximation
(see
[`convert_to_natural()`](https://epiforecasts.io/distspec/reference/convert_to_natural.md)).

## Usage

``` r
new_dist_spec(
  params,
  distribution,
  max = Inf,
  cdf_max = 1,
  cdf_cutoff = deprecated()
)
```

## Arguments

- params:

  Parameters of the distribution (including `max`)

- distribution:

  Character; the distribution type (e.g. `"gamma"`, `"lognormal"`,
  `"nonparametric"`).

- max:

  Numeric, maximum value of the distribution. The distribution will be
  truncated at this value. Default: `Inf`, i.e. no maximum.

- cdf_max:

  Numeric in `(0, 1]`; the cumulative probability up to which the
  distribution is kept, i.e. it is truncated at the `cdf_max` quantile.
  For example `cdf_max = 0.999` keeps the distribution up to its 99.9th
  percentile. Default: `1`, i.e. keep the full distribution. A value
  below `0.5` is rejected, as it is almost certainly the tail
  probability to *drop* rather than the CDF level to keep (use `1 - x`
  instead).

- cdf_cutoff:

  \[Deprecated\] Renamed to `cdf_max`. Supplying it warns and the value
  is interpreted as `cdf_max`, i.e. the CDF level to keep (the distspec
  0.1.0 convention). A value in the historical EpiNow2 convention (the
  tail probability to drop) is caught by the guard against values below
  `0.5`; pass `cdf_max = 1 - cdf_cutoff` instead.

## Value

A `dist_spec` of the given specification.

## Examples

``` r
new_dist_spec(
  params = list(mean = 2, sd = 1),
  distribution = "normal"
)
#> - normal distribution:
#>   mean:
#>     2
#>   sd:
#>     1
```

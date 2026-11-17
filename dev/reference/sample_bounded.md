# Draw samples respecting a `max`/`cdf_max` bound

Used by each parametric distribution's
[`sample_dist()`](https://epiforecasts.io/distspec/dev/reference/sample_dist.md)
method. If `x` is unconstrained this just calls the unbounded generator
`rng`. Otherwise it draws exactly from the bounded distribution via
inverse-CDF sampling: `upper` is the smaller of `max` and the `cdf_max`
quantile, `u` is drawn uniformly on `(0, F(upper))`, and the quantile at
`u` is returned. This takes a single pass, unlike a rejection loop
(resampling from the unbounded distribution until a draw falls within
the bound), which can hang when the bound cuts off nearly all of the
mass (e.g. `Normal(mean = 100, sd = 1, max = 90)`, whose tail beyond 90
has probability of order 1e-24).

The computation runs on the log scale throughout, so a bound far enough
into the lower tail for `F(upper)` to underflow to zero in double
precision (e.g. `Normal(mean = 100, sd = 1, max = 20)`) still samples
correctly.

## Usage

``` r
sample_bounded(x, n, rng, cdf, quantile)
```

## Arguments

- x:

  A single (non-composite) `<dist_spec>`.

- n:

  The number of samples to draw.

- rng:

  The base-R random-generation function for the family (e.g.
  [`rgamma()`](https://rdrr.io/r/stats/GammaDist.html)).

- cdf:

  The base-R CDF function for the family (e.g.
  [`pgamma()`](https://rdrr.io/r/stats/GammaDist.html)).

- quantile:

  The base-R quantile function for the family (e.g.
  [`qgamma()`](https://rdrr.io/r/stats/GammaDist.html)).

## Value

A numeric vector of `n` samples.

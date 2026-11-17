# Sample from a distribution

Draws random samples from a `<dist_spec>` whose parameters are fixed
numbers. An unbounded distribution uses the base-R random-generation
function for its family (e.g.
[`rgamma()`](https://rdrr.io/r/stats/GammaDist.html) for a gamma
distribution). A discretised distribution is sampled on its integer
support.

A `max`/`cdf_max` set with
[`bound_dist()`](https://epiforecasts.io/distspec/reference/bound_dist.md)
on a parametric distribution is respected: samples are drawn from the
truncated distribution by inverse CDF rather than by discarding draws
beyond the bound, so the cost does not depend on how much of the mass
the bound cuts off.

Only distributions with fixed parameters can be sampled. If any
parameter is itself a distribution (a prior), there is no single
distribution to sample from and an error is raised.

A composite (multi-component) distribution is sampled per component, in
keeping with
[`mean()`](https://rdrr.io/r/base/mean.html)/[`sd()`](https://epiforecasts.io/distspec/reference/sd.md),
which also return one value per component. Use
[`rowSums()`](https://rdrr.io/r/base/colSums.html) on the result to
obtain samples of the combined (convolved) distribution. A
`max`/`cdf_max` set on the composite itself (with
[`bound_dist()`](https://epiforecasts.io/distspec/reference/bound_dist.md)
on the sum) refers to that combined distribution, which has no
closed-form distribution to draw from, so sampling such a composite
raises an error. Bound the components individually to sample them under
a bound.

## Usage

``` r
sample_dist(x, n, ...)

# S3 method for class 'dist_spec'
sample_dist(x, n, ...)

# S3 method for class 'multi_dist_spec'
sample_dist(x, n, ...)
```

## Arguments

- x:

  A `<dist_spec>`.

- n:

  The number of samples to draw.

- ...:

  Not used.

## Value

For a single distribution, a numeric vector of `n` samples. For a
composite distribution of `k` components, an `n` by `k` matrix, one
column of `n` samples per component
([`rowSums()`](https://rdrr.io/r/base/colSums.html) gives `n` samples of
the combined distribution).

## See also

[`fix_parameters()`](https://epiforecasts.io/distspec/reference/fix_parameters.md)
to resolve an uncertain distribution to fixed parameters before
sampling, and
[`discretise()`](https://epiforecasts.io/distspec/reference/discretise.md)
to obtain a PMF instead.

## Examples

``` r
# Samples from a fixed gamma distribution
sample_dist(Gamma(shape = 2, rate = 1), 10)
#>  [1] 1.7886779 0.7392341 2.7166481 2.0169146 3.0680064 0.8968142 1.1668660
#>  [8] 1.4537819 0.8449688 3.7339663

# Samples from a discretised distribution, drawn on its integer support
sample_dist(discretise(Gamma(shape = 2, rate = 1, max = 20)), 10)
#>  [1] 1 1 2 1 2 2 3 0 2 6

# A fixed distribution always returns the same value
sample_dist(Fixed(3), 5)
#> [1] 3 3 3 3 3

# A composite: an n-by-k matrix, one column per component
sample_dist(Gamma(shape = 2, rate = 1) + Gamma(shape = 3, rate = 1), 10)
#>            [,1]     [,2]
#>  [1,] 4.2401783 8.350871
#>  [2,] 1.3299248 1.469430
#>  [3,] 1.5603809 1.591709
#>  [4,] 0.7035864 1.290698
#>  [5,] 1.2219251 4.707147
#>  [6,] 2.4513660 3.257427
#>  [7,] 1.2317076 7.385438
#>  [8,] 0.4952153 2.719755
#>  [9,] 4.0489445 3.570825
#> [10,] 1.8144533 2.120910
```

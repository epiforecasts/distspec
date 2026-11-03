# Coerce an object to a `<dist_spec>`

Converts other representations of a probability distribution into a
`<dist_spec>`. A `<dist_spec>` is returned unchanged. A numeric vector
is interpreted as a probability mass function and becomes a
[`NonParametric()`](https://epiforecasts.io/distspec/dev/reference/NonParametric.md)
distribution; a single number becomes a
[`Fixed()`](https://epiforecasts.io/distspec/dev/reference/Fixed.md)
point mass at that value.

Other packages can provide methods for their own distribution classes by
registering an `as_dist_spec.<class>` method, without distspec depending
on them or them re-implementing the `<dist_spec>` format.

## Usage

``` r
as_dist_spec(x, ...)

# S3 method for class 'dist_spec'
as_dist_spec(x, ...)

# S3 method for class 'numeric'
as_dist_spec(x, ...)

# Default S3 method
as_dist_spec(x, ...)
```

## Arguments

- x:

  Object to convert: a `<dist_spec>`, a single number, or a numeric
  vector representing a probability mass function (zero-indexed, i.e.
  the first entry is the mass at zero; normalised to sum to one).

- ...:

  Additional arguments passed to methods. Every method forwards them to
  [`bound_dist()`](https://epiforecasts.io/distspec/dev/reference/bound_dist.md)
  (directly for a `<dist_spec>`, via the constructor otherwise), so
  limits such as `max` apply regardless of the input class.

## Value

A `<dist_spec>`.

## See also

[Distributions](https://epiforecasts.io/distspec/dev/reference/Distributions.md)
for the constructors this converts to.

## Examples

``` r
# a PMF vector becomes a nonparametric distribution
as_dist_spec(c(0.1, 0.4, 0.3, 0.2))
#> - nonparametric distribution
#>   PMF: [0.1 0.4 0.3 0.2]

# a single number becomes a fixed (point mass) distribution
as_dist_spec(3)
#> - fixed value:
#>   3

# a <dist_spec> is returned unchanged
as_dist_spec(Gamma(mean = 4, sd = 1))
#> - gamma distribution:
#>   shape:
#>     16
#>   rate:
#>     4
```

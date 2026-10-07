# Get a distribution's quantile function

Returns the distribution's quantile function as a base-R `q*` function
(e.g. `qgamma`), ready to call with its own parameters.

## Usage

``` r
dist_quantile(x)
```

## Arguments

- x:

  A `<dist_spec>`.

## Value

A function.

## Examples

``` r
dist_quantile(Gamma(shape = 1, rate = 1))
#> function (p, shape, rate = 1, scale = 1/rate, lower.tail = TRUE, 
#>     log.p = FALSE) 
#> {
#>     if (!missing(rate) && !missing(scale)) {
#>         if (abs(rate * scale - 1) < 1e-15) 
#>             warning("specify 'rate' or 'scale' but not both")
#>         else stop("specify 'rate' or 'scale' but not both")
#>     }
#>     .Call(C_qgamma, p, shape, scale, lower.tail, log.p)
#> }
#> <bytecode: 0x56230d764a98>
#> <environment: namespace:stats>
```

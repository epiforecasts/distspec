# Draw an `n` by `k` matrix of per-component samples

A thin wrapper around [`vapply()`](https://rdrr.io/r/base/lapply.html)
that always returns a matrix, even when `n = 1` (where
[`vapply()`](https://rdrr.io/r/base/lapply.html) would otherwise
simplify to a plain vector).

## Usage

``` r
draw_components(x, n)
```

## Arguments

- x:

  A `<multi_dist_spec>`.

- n:

  The number of samples to draw.

## Value

An `n` by `length(x)` matrix.

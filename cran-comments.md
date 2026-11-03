## R CMD check results

0 errors | 0 warnings | 0 notes

## Submission timing

This update follows 0.3.0 by three weeks. It deprecates `dist_cdf()` and `dist_quantile()`, exported in 0.3.0. Both ignore any truncation bound and return the wrong function for a truncated distribution. With this release, code that calls them warns and points to `cdf()` and `quantile()`, which respect the bound.

## Reverse dependencies

The one reverse dependency, epidist, suggests distspec and does not call the deprecated functions.

## R CMD check results

0 errors | 0 warnings | 0 notes

## Submission timing

This update follows 0.3.0 by a few weeks. It deprecates `dist_cdf()` and `dist_quantile()`, exported in 0.3.0, because they ignore a distribution's truncation bound and so return the wrong function for a truncated distribution. We would like the deprecation on CRAN before other packages build on them.

## Reverse dependencies

We checked the one reverse dependency, epidist, which only suggests distspec and does not call the deprecated functions.

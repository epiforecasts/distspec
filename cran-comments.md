## R CMD check results

0 errors | 0 warnings | 0 notes

## Notes

This release adds `dist_cdf()`, `dist_quantile()`, `quantile.dist_spec()` and `cdf()`, and fixes two bugs in `sample_dist()` (bounds were not respected when sampling, and a composite distribution's `n = 1` case returned the wrong shape). No breaking changes.

# CDF and quantile interface
#
# `family_cdf()`/`family_quantile()` return a distribution's cumulative
# distribution and quantile functions (base-R `p*`/`q*` functions such as
# `pgamma`/`qgamma`). `family_cdf()` is used to discretise a distribution via
# {primarycensored}, and both underlie the bound-aware `cdf()` and
# `quantile()`. Both are an optional per-type capability: a distribution
# without a method (e.g. beta, the Dirichlet prior, the already-discretised
# nonparametric) errors informatively via the `.default` method.

#' Get a distribution's base-R CDF or quantile function
#'
#' @description
#' Returns the base-R `p*` or `q*` function (e.g. `pgamma`) for the family of
#' `x`, ignoring any `max`/`cdf_max` bound.
#' @param x A `<dist_spec>`.
#' @return A function.
#' @keywords internal
#' @noRd
family_cdf <- function(x) UseMethod("family_cdf")

#' @exportS3Method
family_cdf.default <- function(x) {
  cli::cli_abort(
    "{.val {class(x)[1]}} has no CDF and cannot be discretised."
  )
}

#' @noRd
#' @importFrom stats qexp qgamma qlnorm qnorm qweibull
family_quantile <- function(x) UseMethod("family_quantile")

#' @exportS3Method
family_quantile.default <- function(x) {
  cli::cli_abort(
    "{.val {class(x)[1]}} has no quantile function."
  )
}

#' Get a distribution's CDF or quantile function
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `dist_cdf()` and `dist_quantile()` are deprecated because they ignore any
#' `max`/`cdf_max` bound set with [bound_dist()]. Use [cdf()] and
#' [quantile()][quantile.dist_spec()] instead, which respect the bound.
#' @param x A `<dist_spec>`.
#' @return A function.
#' @keywords internal
#' @export
dist_cdf <- function(x) {
  lifecycle::deprecate_warn("0.3.1", "dist_cdf()", "cdf()")
  family_cdf(x)
}

#' @rdname dist_cdf
#' @export
dist_quantile <- function(x) {
  lifecycle::deprecate_warn("0.3.1", "dist_quantile()", "quantile()")
  family_quantile(x)
}

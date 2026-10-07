# CDF and quantile interface
#
# `dist_cdf()`/`dist_quantile()` return a distribution's cumulative
# distribution and quantile functions (base-R `p*`/`q*` functions such as
# `pgamma`/`qgamma`). `dist_cdf()` is used to discretise a distribution via
# {primarycensored}. Both are an optional per-type capability: a distribution
# with no closed-form CDF/quantile function (e.g. beta, the Dirichlet prior,
# the already-discretised nonparametric) provides no method and errors
# informatively via the `.default` method.

#' Get a distribution's cumulative distribution function
#'
#' @description
#' Returns the distribution's CDF as a base-R `p*` function (e.g. `pgamma`),
#' ready to call with its own parameters. Used to discretise a distribution
#' via `{primarycensored}`.
#' @param x A `<dist_spec>`.
#' @return A function.
#' @keywords internal
#' @export
#' @examples
#' dist_cdf(Gamma(shape = 1, rate = 1))
dist_cdf <- function(x) UseMethod("dist_cdf")

#' @exportS3Method
dist_cdf.default <- function(x) {
  cli::cli_abort(
    "{.val {class(x)[1]}} has no CDF and cannot be discretised."
  )
}

#' Get a distribution's quantile function
#'
#' @description
#' Returns the distribution's quantile function as a base-R `q*` function
#' (e.g. `qgamma`), ready to call with its own parameters.
#' @inheritParams dist_cdf
#' @return A function.
#' @keywords internal
#' @export
#' @importFrom stats qexp qgamma qlnorm qnorm qweibull
#' @examples
#' dist_quantile(Gamma(shape = 1, rate = 1))
dist_quantile <- function(x) UseMethod("dist_quantile")

#' @exportS3Method
dist_quantile.default <- function(x) {
  cli::cli_abort(
    "{.val {class(x)[1]}} has no quantile function."
  )
}

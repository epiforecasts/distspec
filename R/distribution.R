# CDF interface for discretisation
#
# `dist_cdf()` returns a distribution's cumulative distribution function (a
# base-R `p*` function such as `pgamma`), used to discretise it via
# {primarycensored}. It is an optional per-type capability: a distribution that
# is never discretised (e.g. beta, the Dirichlet prior, the already-discretised
# nonparametric) provides no method and errors informatively via
# `dist_cdf.default()`.

dist_cdf <- function(x) UseMethod("dist_cdf")

#' @exportS3Method
dist_cdf.default <- function(x) {
  cli::cli_abort(
    "{.val {class(x)[1]}} has no CDF and cannot be discretised."
  )
}

# `dist_quantile()` returns a distribution's quantile function (a base-R `q*`
# function such as `qgamma`), the counterpart to `dist_cdf()` used by
# `quantile.dist_spec()`. Like `dist_cdf()` it is an optional per-type
# capability: a type without a method errors informatively via
# `dist_quantile.default()`.

dist_quantile <- function(x) UseMethod("dist_quantile")

#' @exportS3Method
dist_quantile.default <- function(x) {
  cli::cli_abort(
    "{.val {class(x)[1]}} has no quantile function."
  )
}

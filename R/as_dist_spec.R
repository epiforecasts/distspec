# Coercion into <dist_spec>. The generic lives here so that other packages
# can register methods for their own classes (e.g. an epiparameter method in
# epiparameter) without a dependency in either direction; see #140.

#' Coerce an object to a `<dist_spec>`
#'
#' @description
#' Converts other representations of a probability distribution into a
#' `<dist_spec>`. A `<dist_spec>` is returned unchanged. A numeric vector is
#' interpreted as a probability mass function and becomes a [NonParametric()]
#' distribution; a single number becomes a [Fixed()] point mass at that value.
#'
#' Other packages can provide methods for their own distribution classes by
#' registering an `as_dist_spec.<class>` method, without distspec depending on
#' them or them re-implementing the `<dist_spec>` format.
#'
#' @param x Object to convert: a `<dist_spec>`, a single number, or a numeric
#'   vector representing a probability mass function (zero-indexed, i.e. the
#'   first entry is the mass at zero; normalised to sum to one).
#' @param ... Additional arguments passed to methods. The numeric method
#'   passes them to [NonParametric()] (for a vector) or [Fixed()] (for a
#'   single number).
#' @return A `<dist_spec>`.
#' @seealso [Distributions] for the constructors this converts to.
#' @export
#' @examples
#' # a PMF vector becomes a nonparametric distribution
#' as_dist_spec(c(0.1, 0.4, 0.3, 0.2))
#'
#' # a single number becomes a fixed (point mass) distribution
#' as_dist_spec(3)
#'
#' # a <dist_spec> is returned unchanged
#' as_dist_spec(Gamma(mean = 4, sd = 1))
as_dist_spec <- function(x, ...) {
  UseMethod("as_dist_spec")
}

#' @rdname as_dist_spec
#' @export
as_dist_spec.dist_spec <- function(x, ...) {
  x
}

#' @rdname as_dist_spec
#' @export
as_dist_spec.numeric <- function(x, ...) {
  if (length(x) == 1) {
    Fixed(x, ...)
  } else {
    NonParametric(pmf = x, ...)
  }
}

#' @rdname as_dist_spec
#' @importFrom cli cli_abort
#' @export
as_dist_spec.default <- function(x, ...) {
  cli_abort(
    c(
      "!" = "Can't convert an object of class {.cls {class(x)}} to a
      {.cls dist_spec}.",
      "i" = "Supported inputs are a {.cls dist_spec}, a single number, or a
      numeric PMF vector; packages can add support for their own classes by
      providing an {.fn as_dist_spec} method."
    )
  )
}

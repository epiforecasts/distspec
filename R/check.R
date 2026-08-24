#' Check that PMF tail is not sparse
#'
#' @description Checks if the tail of a PMF vector has more than `span`
#' consecutive values smaller than `tol` and throws a warning if so.
#' @param pmf A probability mass function vector
#' @param span The number of consecutive indices in the tail to check
#' @param tol The value which to consider the tail as sparse
#' @importFrom cli cli_warn col_blue
#' @importFrom utils tail
#'
#' @return Called for its side effects.
#' @keywords internal
check_sparse_pmf_tail <- function(pmf, span = 5, tol = 1e-6) {
  if (all(tail(pmf, span) < tol)) {
    cli_warn(
      c(
        "!" = "The PMF tail has {col_blue(span)} consecutive value{?s} smaller
        than {col_blue(tol)}.",
        "i" = "This will increase run times with very small increases in
        accuracy. Consider using the `cdf_max` argument when constructing
        the distribution object, or using the `bound_dist()` function."
      ),
      .frequency = "regularly",
      .frequency_id = "sparse_pmf_tail"
    )
  }
}

#' Check that a numeric PMF or weight vector is valid
#'
#' @description
#' A numeric probability mass function or weight vector must be numeric, contain
#' only finite, non-negative values, and not be all zero, so that it can be
#' normalised to sum to one. Raises an informative error otherwise. An
#' un-normalised vector is allowed (it is treated as weights and normalised by
#' the caller) but warns.
#'
#' @param x A numeric vector.
#' @param arg The name of the calling argument, used in the messages.
#' @return `x`, invisibly, if it is valid; otherwise an error is raised.
#' @importFrom cli cli_abort
#' @keywords internal
check_pmf_values <- function(x, arg = "pmf") {
  if (!is.numeric(x)) {
    cli_abort("{.arg {arg}} must be a numeric vector.")
  }
  if (any(!is.finite(x))) {
    cli_abort("{.arg {arg}} must contain only finite, non-missing values.")
  }
  if (any(x < 0)) {
    cli_abort("{.arg {arg}} must not contain negative values.")
  }
  total <- sum(x)
  if (total == 0) {
    cli_abort(
      "{.arg {arg}} must not be all zero; it cannot be normalised to a
      probability mass function."
    )
  }
  if (!isTRUE(all.equal(total, 1))) {
    cli_warn(
      c(
        "!" = "{.arg {arg}} does not sum to 1 (it sums to {.val {total}}).",
        "i" = "It has been normalised to a probability mass function."
      )
    )
  }
  invisible(x)
}

#' Validate the structure of a `<dist_spec>`
#'
#' @description
#' Asserts the structural invariants of a `<dist_spec>`: its class, the shape of
#' its parameters, and its `max`/`cdf_max` attributes. Called by every
#' constructor on the object it builds, so a `<dist_spec>` from the package is
#' always well-formed. A composite is valid when each of its components is.
#'
#' @param x A `<dist_spec>` object.
#' @return `x`, invisibly, if it is valid; otherwise an error is raised.
#' @importFrom cli cli_abort
#' @keywords internal
validate_dist_spec <- function(x) {
  if (!inherits(x, "dist_spec")) {
    cli_abort(
      c(
        "!" = "{.arg x} must be a {.cls dist_spec}.",
        "i" = "You have supplied an object of class {.cls {class(x)}}."
      )
    )
  }

  ## a composite is valid when each of its (single, non-composite) components is
  if (inherits(x, "multi_dist_spec")) {
    if (!is.list(x)) {
      cli_abort(
        "A {.cls multi_dist_spec} must be a list of component distributions."
      )
    }
    for (i in seq_along(x)) {
      component <- x[[i]]
      if (inherits(component, "multi_dist_spec")) {
        cli_abort(
          "Component {i} of a {.cls multi_dist_spec} must itself be a single
          {.cls dist_spec}, not a composite."
        )
      }
      validate_dist_spec(component)
    }
    return(invisible(x))
  }

  distribution <- x$distribution
  if (!is.character(distribution) || length(distribution) != 1 ||
        is.na(distribution) || !nzchar(distribution)) {
    cli_abort(
      "The {.field distribution} of a {.cls dist_spec} must be a single
      non-empty string."
    )
  }

  ## the object carries a type class (its `$distribution`) followed by the
  ## `"dist_spec"` tail, optionally with markers (such as the uncertainty
  ## marker) prepended. The type class is therefore the one immediately before
  ## `"dist_spec"`, which must equal `$distribution`; this validates the match
  ## without hard-coding any marker name
  obj_classes <- class(x)
  type_class <- obj_classes[match("dist_spec", obj_classes) - 1L]
  if (length(type_class) == 0 || is.na(type_class) ||
        !identical(type_class, distribution)) {
    cli_abort(
      c(
        "!" = "The {.field distribution} of a {.cls dist_spec} must match its
        type class.",
        "i" = "The distribution is {.val {distribution}} but the leading type
        class is {.val {type_class}}."
      )
    )
  }

  ## a nonparametric distribution stores its PMF in `$pmf`; every other type
  ## stores a named parameter list in `$parameters`
  if (!is.null(x$parameters)) {
    if (!is.list(x$parameters) || is.null(names(x$parameters)) ||
          any(!nzchar(names(x$parameters)))) {
      cli_abort(
        "The {.field parameters} of a {.cls dist_spec} must be a named list."
      )
    }
  }

  ## the `max` and `cdf_max` attributes, if present, must be well-formed
  max_value <- attr(x, "max")
  if (!is.null(max_value)) {
    if (!is.numeric(max_value) || length(max_value) != 1 || is.na(max_value) ||
          max_value < 0) {
      cli_abort(
        "The {.field max} attribute of a {.cls dist_spec} must be a single
        numeric that is non-negative or {.val {Inf}}."
      )
    }
  }

  cdf_max <- attr(x, "cdf_max")
  if (!is.null(cdf_max)) {
    if (!is.numeric(cdf_max) || length(cdf_max) != 1 ||
          is.na(cdf_max) || cdf_max <= 0 || cdf_max > 1) {
      cli_abort(
        "The {.field cdf_max} attribute of a {.cls dist_spec} must be a
        single numeric in {.code (0, 1]}."
      )
    }
  }

  invisible(x)
}

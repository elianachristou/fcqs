#' Discretize Response
#'
#' \code{discretize} converts the response into a discrete form by creating
#' slices and assigning each part of the response to the slice it is in.
#'
#' This function converts a vector response into a vector of the slices each
#' value in the response is a part of. This is important for the Functional
#' Sliced Inverse Regression method which relies on using these slices for
#' reducing the dimension of data.
#'
#' @param y A vector representing the response variable
#' @param yunit A vector defining the slices used
#'
#' @return A vector defining the slices each item in the response corresponds to
#'
#' @noRd
#' @examples
#' y -> c(1, 2, 3, 2)
#' yunit -> unique(y)
#' discretize(y, yunit)
discretize <- function(y, yunit) {

  # Check if y is a vector
  if (!is.vector(y)) {
    stop("y must be a vector.")
  }

  # Check if yunit is a vector
  if (!is.vector(yunit)) {
    stop("yunit must be a vector.")
  }

  n <- length(y)
  # Add small amount of noise to y
  y <- y + .00001 * mean(y) * stats::rnorm(n)
  nsli <- length(yunit)
  # Order y values in ascending order
  yord <- y[order(y)]
  n <- length(y)
  nwidth <- floor(n / nsli)
  # Instantiate vector of division points between slices
  divpt <- rep(0, nsli - 1)
  # Set each division point to the values of yord that represent the boundaries
  # between slices
  for(i in 1:(nsli - 1)) {
    divpt[i] <- yord[i * nwidth + 1]
  }

  y1 <- rep(0, n)
  # Assign slice labels to the upper boundary slice
  y1[y >= divpt[nsli - 1]] <- nsli
  # Assign slice labels to the lower boundary slice
  y1[y < divpt[1]] <- 1
  # Assign slices labels to intermediate slices
  for(i in 2:(nsli - 1)) {
    y1[(y >= divpt[i - 1]) & (y < divpt[i])] <- i
  }
  # Return discretized y
  y1
}
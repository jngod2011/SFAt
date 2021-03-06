#' generate simulated cross-section data for testing purposes
#' @param N number of observations
#' @param x_coeff coefficients for explanatory variables
#' @param z_coeff coefficients for exogeneous varaibles
#' @param sigma_u variance of the inefficiency term
#' @param sigma_v variance of the random noise
#' @param ineff production (-1) or cost inefficiency form (1),
#' @param aslist TRUE/FALSE to return list or array
#' @export
sim_data_cs <- function(N = 500,
                        x_coeff = c(10, 6, 3),
                        z_coeff = c(3, 1.5, 0.5),
                        sigma_u = 2,
                        sigma_v = 3,
                        ineff   = -1,
                        aslist  = F) {

  x_ncols <- length(x_coeff) - 1
  z_ncols <- length(z_coeff) - 1

  X <- matrix(rtnorm(n     = N*x_ncols,
                     mean  = 5,
                     sd    = 3,
                     lower = 0),
              nrow = N,
              ncol = x_ncols)

  colnames(X) <- paste0("x", 1:x_ncols)

  if (z_ncols > 0 ) {
    Z <- matrix(rnorm(n    = N*z_ncols,
                      mean = 3,
                      sd   = 2),
                nrow = N,
                ncol = z_ncols)

    colnames(Z) <- paste0("z", 1:z_ncols)

    u <- sapply(as.vector(cbind(1,  Z) %*% z_coeff),
                function(x) {
                  rtnorm(n     = 1,
                         mean  = x,
                         lower = 0,
                         sd    = sigma_u)
                }
    )
  } else {

    u <- rtnorm(N,
                mean = z_coeff,
                lower = 0,
                sd = sigma_u)
    Z <- NULL
  }

  v <- rnorm(N,
             mean = 0,
             sd = sigma_v)

  eps <- ineff*u + v

  # y <- 10 + 6*x1 + 3*x2 + eps
  y <- as.vector( cbind(1, X) %*% x_coeff) + eps

  if (aslist) {
    return(list(y = y, X = X, Z = Z, u = u, v = v, eps = eps))
  } else
    return(cbind(y, X, Z, u, v, eps))
}

#' generate simulated panel data for testing purposes
#' @param k number of individuals - cross section
#' @param t number of observations per individual
#' @param x_coeff coefficients for explanatory variables
#' @param z_coeff coefficients for exogeneous varaibles
#' @param sigma_u variance of the inefficiency term
#' @param sigma_v variance of the random noise
#' @param ineff production (-1) or cost inefficiency form (1),
#' @param aslist TRUE/FALSE to return list or array
#' @export
sim_data_panel <- function(k = 20, # number of individuals - cross section
                           t = 10, # number of observations per individual
                           x_mean = 10,
                           x_sd = 1,
                           z_mean = 10,
                           z_sd = 1,
                           x_coeff = c(10, 6, 3),
                           z_intercept = 5,
                           z_coeff = c(1.9, -0.9),
                           sigma_u = 2, # variance of the inefficiency term
                           sigma_v = 3, # variance of the random noise
                           ineff = -1,
                           aslist = F) {

  N <- t * k

  x_ncols <- length(x_coeff) - 1
  z_ncols <- length(z_coeff)

  # random explanatory data
  X <- matrix(rtnorm(n     = N*x_ncols,
                     mean  = x_mean,
                     sd    = z_sd,
                     lower = 0),
              nrow = N,
              ncol = x_ncols)

  colnames(X) <- paste0("x", 1:x_ncols)

  # random exogeneous data

  # intercept for each individual (cross section)
  mu_unique <- rnorm(k, z_intercept, 3)
  mu <- rep(mu_unique, each = t)
  K <- cbind(k = rep(1:k, each = t), t = rep(1:t, times = k))

  if (z_ncols > 0 ) {
    Z <- matrix(rnorm(n    = N*z_ncols,
                      mean = z_mean,
                      sd   = z_sd),
                nrow = N,
                ncol = z_ncols)

    colnames(Z) <- paste0("z", 1:z_ncols)

    u <- sapply(mu + as.vector(as.vector(Z %*% z_coeff)),
                function(x) {
                  rtnorm(n     = 1,
                         mean  = x,
                         lower = 0,
                         sd    = sigma_u)
                }
    )

  } else {

    u <- rtnorm(n     = N,
                mean  = mu,
                lower = 0,
                sd    = sigma_u)
    Z <- NULL
  }

  # error terms
  v <- rnorm(n    = N,
             mean = 0,
             sd   = sigma_v)

  eps <- ineff*u + v

  y <- as.vector( cbind(1, X) %*% x_coeff) + eps

  if (aslist) {
    return(list(y = y, X = X, Z = Z, K = K,
                u = u, v = v, eps = eps,
                N = N, t = t, k = k, mu = mu_unique))
  } else
    return(cbind(y, X, Z, u, v, eps))
}

#' @export
sim_data_panel_ar <- function(k           = 20, # number of individuals - cross section
                              t           = 10, # number of observations per individual
                              x_mean      = 10,
                              x_sd        = 1,
                              z_mean      = 0,
                              z_sd        = 1,
                              x_coeff     = c(10, 6, 3),
                              z_coeff     = c(0.5, 0.1),
                              fe          = 5,
                              ar_coeff    = 0.9,
                              sigma_u     = 2, # variance of the inefficiency term
                              sigma_v     = 3, # variance of the random noise
                              ineff       = -1,
                              aslist      = F) {

  N <- t * k

  x_ncols <- length(x_coeff) - 1
  z_ncols <- length(z_coeff)

  # random explanatory data
  X <- matrix(rtnorm(n     = N*x_ncols,
                     mean  = x_mean,
                     sd    = x_sd,
                     lower = 0),
              nrow = N,
              ncol = x_ncols)

  colnames(X) <- paste0("x", 1:x_ncols)

  # random exogeneous data

  # intercept for each individual (cross section)
  mu <- rtnorm(k, fe, 3)

  if (z_ncols > 0) {

    Z <- matrix(rnorm(n    = N*z_ncols,
                      mean = z_mean,
                      sd   = z_sd),
                nrow = N,
                ncol = z_ncols)
    colnames(Z) <- paste0("z", 1:z_ncols)

  } else {
    Z <- 0
    z_coeff <- 0
  }

  u <- rep(0.0, N)

  for (i in 1:k) {
    u[(i-1)*t + 1] <- mu[i]
    for (j in 2:t) {
      current    <- (i-1)*t + j
      umean      <- u[current - 1]*ar_coeff + z_coeff %*% Z[current, ]
      u[current] <- rtnorm(n = 1, mean = umean, sd = 2, lower = 0)
    }
  }

  # matrix of panel data indices
  K <- cbind(k = rep(1:k, each = t), t = rep(1:t, times = k))

  # error terms
  v <- rnorm(n    = N,
             mean = 0,
             sd   = sigma_v)

  eps <- ineff*u + v

  y <- as.vector( cbind(1, X) %*% x_coeff) + eps

  if (aslist) {
    return(list(y = y, X = X, Z = Z, K = K,
                u = u, v = v, eps = eps,
                N = N, t = t, k = k, mu = mu))
  } else
    return(cbind(y, X, u, v, eps))
}

sim_data_cs_homo <- function(N, ineff = -1) {

  x1 <- rnorm(N, 8)
  x2 <- rnorm(N, 15)

  u <- rtnorm(N, mean = 2, lower = 1, sd = 3)
  v <- rnorm(N, 0, 1)
  eps <- ineff*u + v

  y <- 10 + 6*x1 + 3*x2 + eps

  return(cbind(y, x1, x2, z1, z2, u, v, eps))
}

#' draw random values from truncated normal distribution
#' @export
rtnorm <- function(n = 1, mean = 0, sd = 1, lower = -Inf, upper = Inf) {
  rtnorm_(n, mean, sd, lower, upper)
}

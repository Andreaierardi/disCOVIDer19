#' Logistic curve fitting
#'
#' @param sample_cases values for growth fitting.
#' @param sample_date sample dates as serial consecutive dates (should be included in \code{days}).
#' @param days full vector of serial dates.
#'
#' @return a list of fitting results. Specifically:
#' \describe{
#'   \item{out_fit}{The output of the fitting performed by \link[growthcurver]{SummarizeGrowth}.}
#'   \item{fittedPoints}{A data frame containing dates and corresponding fitted values of cumulative cases, listed by columns.}
#'   \item{out_chisq}{The output of the chi-squared independence test of residuals.}
#'   \item{fittedPoints_der}{A data frame containing dates and the corresponding fitted values of new cases, listed by columns.}
#' }
#'
#' @examples
#' \dontrun{
#'   data <- get_regionTS()
#'   data <- subset(data, denominazione_regione == "Lombardia")
#'   exe_fit(data$totale_casi, data$data_seriale, c(1:50))
#' }
#'
#' @export
exe_fit <- function(sample_cases, sample_date, days) {
  # Curve fitting
  out_fit <- growthcurver::SummarizeGrowth(sample_date, sample_cases)
  k=out_fit[["vals"]][["k"]]
  n0=out_fit[["vals"]][["n0"]]
  r=out_fit[["vals"]][["r"]]

  # Creation of fitted points
  yFitted <- (n0*k)/(n0 + (k-n0) * exp(-r*days))
  yFitted_der <- (k*n0*r*(k - n0)*exp(-r*days))/((k - n0)*exp(-r*days) + n0)^2
  fittedPoints <- data.frame(days,yFitted)
  fittedPoints_der <- data.frame(days,yFitted_der)

  # Chi-squared test
  yFitted_chi <- (n0*k)/(n0 + (k-n0) * exp(-r*sample_date))
  if(is.null(out_fit$model))
    output_resid <- NULL
  else
    output_resid <- nlstools::nlsResiduals(out_fit$model)

  output_fin <- list("out_fit" = out_fit, "fittedPoints" = fittedPoints,
                     "out_resid" = output_resid, "fittedPoints_der" = fittedPoints_der)
  return(output_fin)
}

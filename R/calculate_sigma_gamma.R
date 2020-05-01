#' Calculate sigma and gamma using distributions IT, SRT, IBST
#' 
#' @param IT array-like
#' @param SRT array-like
#' @param IBST array-like
#'	
#' @return a list:
#' \describe{
#'   \item{sigma}{float}
#'   \item{gamma}{float}
#' } 
#' @export		
calculate_sigma_gamma <- function(IT, SRT, IBST){
  #### Functions ####
  expected_value <- function(X){
    out <- c(1:(length(X))) %*% X
    out <- as.numeric(out)
    return(out)
  }
  
  #### Operations ####
  sigma <- 1/expected_value(IT)
  gamma <- 1/(expected_value(SRT)+expected_value(IBST))
  
  out <- list('sigma'=sigma, 'gamma'=gamma)
  
  return(out)	
}
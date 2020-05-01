#' Estimate R0
#' 
#' Estimate R0 of a time series I using an exponential approximation of I (I_approx) in early stages of diffusion.
#' The method used is a least square fitting of I_approx over I. 
#' 
#' 
#' @param sigma float
#' @param gamma float
#' @param I array-like
#' @param time_start int time serie of which to calculate R0
#' @param time_end int
#' 
#' @return a list containing: R0, start, end. start and end are the extremes of J (see details). Ignore if any is passed by user.
#' 
#' @details
#' 	R0 will be estimated using I[J], where J is:
#'		(time_start:time_end) 	if user provides both 
#'		(1:time_end) 			if user provides time_end but not time_start
#'		(time_start:length(I))  if user provides time_start but not time_end
#'		(start:end)             if user provides neither. start and end are extrapolated with exp_period
#'									and aim to identify the extremes of the stage of exponential growth in I 
#' @export
estimate_R0 <- function(sigma, gamma, I, time_start, time_end){
  #### Functions ####
  
  # Find the period of exponential growth for X
  exp_period <- function(X){
    start <- 1
    for(t in (1:(length(X)-1))){
      end <- t
    }
    period <- c(start, end)
    return(period)
  }
  # Define the exponential approximation of I 
  I_approx <- function(R0, sigma, gamma, I0, t) {
    
    out <- I0*exp(1/2*(sqrt(4*(R0-1)*sigma*gamma+(sigma+gamma)^2)-(sigma+gamma))*t)
    
    return(out) 
    
  }
  # Define the target function, ie the sup distance of I and I_approx
  sqdist_log <- function(R0, sigma, gamma, I){
    
    out = 0
    for(t in (1:length(I)))
      # out = out + (log(I_approx(R0, sigma, gamma, I[1],t-1))-log(I[t]))^2
      out <- max(out, (log(I_approx(R0, sigma, gamma, I[1],t-1))-log(I[t]))^2)
    
    return(out)
  }
  
  #### Operations ####
  if(missing(time_start) & missing(time_end)) {
    period<-exp_period(I); start<-period[1]; end<-period[2]
  }	
  else if(missing(time_start)) {
    start <- 1
    end <- time_end
  }	
  else if(missing(time_end)) {
    start <- time_start
    end <- length(I)
  }	
  else {
    start<-time_start; end<-time_end
  }
  
  t <- (start:end)
  
  I <- I[t]
  opt <- stats::optimise(sqdist_log, sigma=sigma, gamma=gamma, I=I, interval=c(0,20))
  R0 <- opt$minimum
  mf <- opt$objective/(end-start+1)
  
  out <- list('start'=start, 'end'=end, 'R0'=R0, 'R0_fitting'=mf)
  
  return(out)
}

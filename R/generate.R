#' Generates densities 
#' 
#' Generates densities given distribution names and parameters.
#' Generates distribution without values of 3th quartile (trade off: accuracy - data)
#' 
#' @export
generate <- function(distr, parameters){
		if(distr=='norm' & !is.null(parameters$mean) & !is.null(parameters$std)){
			mean <- parameters$mean
			std <- parameters$std
			sup <- floor(mean+0.675*std)
				out <- stats::dnorm(seq(0,sup), mean, std)
		}
		else if(distr=='exp' & !is.null(parameters$rate)){
			rate <- parameters$rate
			sup <- floor(log(4)/rate)
			out <- stats::dexp(seq(0, sup), rate)
		}
		else if(distr=='none'){
			out <- c(1)
		}
		else {
			out <- NULL
		}
		return(out)
	}
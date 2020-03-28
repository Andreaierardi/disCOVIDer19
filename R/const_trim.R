#' Trims leading values in numerical vector
#'
#' Removes the first elements of a numerical vector till they do show
#' an increase higher than threshold.
#'
#' @param v a numerical vector
#' @param threshold the threshold used for cutting the vector
#'
#' @return the first index of the vector which entry grows more than \code{threshold}, starting from 1 to \code{length(v)}
#'
#' @examples
#' \dontrun{
#' 	const_trim(c(0,0,0,1,1.3,1.7,2,3,4.5,6,9,12),1)
#' }
#' @export
const_trim <- function(v,threshold) {
	if(is.null(v) || length(v) == 0 || !is.numeric(v))
		return(NULL)

	i <- 1
	while(i+1 <= length(v) && v[i+1]-v[i] <= threshold) {
		# FIRST VERSION: v <- v[-i]
	  i <- i+1
	}
	
	# FIRST VERSION: return(v)
	return(i)
}

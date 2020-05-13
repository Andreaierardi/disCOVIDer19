#'Detects start and end of outbreak
#'  
#'... more specifics ...
#'  
#'@param v
#'@param threshold
#'  
#'@return a list of start and end indexes
#'
#'@examples
#'\dontrun{
#' 
#' }
#'  
#'@export
detect_start_end <- function(v, threshold = 0.005) {
  if(is.null(v) || !is.numeric(v) || length(v) == 0)
    return(NULL)
  
  tot <- tail(v[!is.na(v)],1)
  
  for(i in c(1:length(v))) {
    if(!is.na(v[i]) && v[i]/tot > threshold)
      break
  }
  
  for(j in c(length(v):1)) {
    if(!is.na(v[j]) && v[j]/tot < (1-threshold) )
      break
  }
  
  return(list("start" = i, "end" = j))
}

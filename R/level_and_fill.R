#' Level and fill
#' 
#' FOR CUMULATIVE DATA ONLY!
#' 
#' @export
level_and_fill <- function(v, direction = "forward", method = "locf") {
  if(!is.numeric(v) || !is.vector(v) || length(v) == 0 || !(NA %in% v))
    return(v)
  
  n <- length(v)
  
  if(direction == "forward") {
    
    while(NA %in% v) {
      
      i <- which(is.na(v))[1]
      if(i == 1)
        return(v)
      
      last <- v[i-1]
      while(i <= n && (is.na(v[i]) || v[i] < last)) {
        v[i] <- NA
        i <- i+1
      }
      if(i > n)
        return(v)
      
      v[1:i] <- switch(method,
                       "locf" = imputeTS::na_locf(v[1:i]),
                       "linear" = as.integer(round(imputeTS::na_interpolation(v[1:i], option = "linear"), 0)),
                       "spline" = as.integer(round(imputeTS::na_interpolation(v[1:i], option = "spline"), 0)),
                       imputeTS::na_locf(v[1:i])
                       )
    }
  } else if(direction == "backward") {
    
    v <- rev(v)
    
    while(NA %in% v) {
      
      i <- which(is.na(v))[1]
      if(i == 1)
        return(rev(v))
      
      last <- v[i-1]
      while(i <= n && (is.na(v[i]) || v[i] > last)) {
        v[i] <- NA
        i <- i+1
      }
      if(i > n)
        return(rev(v))
      
      v[1:i] <- switch(method,
                       "locf" = imputeTS::na_locf(v[1:i]),
                       "linear" = as.integer(round(imputeTS::na_interpolation(v[1:i], option = "linear"), 0)),
                       "spline" = as.integer(round(imputeTS::na_interpolation(v[1:i], option = "spline"), 0)),
                       imputeTS::na_locf(v[1:i])
      )
    }
    
    v <- rev(v)
  }
  
  return(v)
  
}

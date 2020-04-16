#' Cleans data
#' 
#' Introduces NAs when data is biased, e.g. when cumulative counts are decreasing.
#' 
#' @param PCD Protezione Civile dataset
#' @return the cleaned dataset
#' 
#' @examples
#' \dontrun{
#' sicily <- get_regionTS()$Sicilia
#' sicily_cl <- data_cleaner(sicily)
#' }
#'@export
data_cleaner <- function(PCD) {
  nam <- names(PCD)
  if("totale_casi" %in% nam) {
    if("tamponi" %in% nam) {
      PCD[c(1,diff(PCD$tamponi)) < c(0,diff(PCD$totale_casi)), "tamponi"] <- NA 
    }
    
    PCD[c(0,diff(PCD$totale_casi)) < 0, "totale_casi"] <- NA
  }
  
  return(PCD)
}

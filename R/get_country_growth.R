#' Data manipulation
#'
#' @export
get_country_growth <- function() {
  
  countryTS$Italy %>%
    dplyr::select(totale_casi) %>%
    dplyr::mutate(growth=round(((totale_casi-dplyr::lag(totale_casi))/dplyr::lag(totale_casi))*100,2) ) %>%
    dplyr::mutate(growth_change=round(growth-dplyr::lag(growth),2) )

}

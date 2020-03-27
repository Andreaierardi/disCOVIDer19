#' Italy temperatures' getter
#' 
#' Downloads mean temperatures in Italy from \url{https://www.ilmeteo.it}, throughout the period
#' 2020/02/24 - today and put them in a table after rearranging and interpolating missing values.
#' 
#' @return A data frame with three columns: \code{loc} (locality), \code{date}, \code{temp} (temperature).
#' 
#' @details 
#' A search of the mean temperatures of the 107 italian provinces is performed. The available data is stored
#' and manipulated as follows: missing dates are added; missing temperature values are linearly interpolated 
#' through the preceding and following values of the same province; a weighted mean of the mean temperatures
#' of each day, with provinces' areas as weights, is performed; its result is interpreted as the mean temperature
#' of the whole country and is appended to the data frame.
#' 
#' @examples
#' \dontrun{
#'  temperatures <- get_temperatures()
#'  subset(temperatures, loc == "Italy")
#' }
#' @export
get_temperatures <- function() {
  
  provnames <- italy_ext$province$territorio
  temperatures <- data.frame()
  
  for(prov in provnames) {
    skip <- FALSE
    url1 <- paste("https://www.ilmeteo.it/portale/archivio-meteo/",
                 prov,
                 "/2020/Febbraio?format=csv", sep = "")
    url2 <- paste("https://www.ilmeteo.it/portale/archivio-meteo/",
                  prov,
                  "/2020/Marzo?format=csv", sep = "")
    tryCatch( {tab1 <- read.csv(url1, sep = ";")
               tab2 <- read.csv(url2, sep = ";")}, 
              error = function(e){ skip <<- TRUE }
              )
    if(skip || nrow(tab1) == 0 || nrow(tab2) == 0) { next }
    
    tab1 <- tab1 %>%
      dplyr::rename(loc = 1, date = 2, temp = 3) %>%
      dplyr::select(loc,date,temp) %>%
      dplyr::mutate(date = as.Date(date, format = "%d/%m/%Y")) %>%
      dplyr::mutate(loc = prov) %>%
      dplyr::filter(date >= as.Date("2020-02-24"))
    
    tab2 <- tab2 %>%
      dplyr::rename(loc = 1, date = 2, temp = 3) %>%
      dplyr::select(loc,date,temp) %>%
      dplyr::mutate(date = as.Date(date, format = "%d/%m/%Y")) %>%
      dplyr::mutate(loc = prov)
    
    temperatures <- rbind(temperatures, tab1, tab2)
  }
  
  # adding missing dates
  seqDates <- seq(as.Date("2020-02-24"), Sys.Date()-1, by = 1)
  tmp <- data.frame()
  availableProv <- unique(temperatures$loc)
  for(prov in availableProv) {
    missingDates <- seqDates[!(seqDates %in% subset(temperatures, loc == prov)$date)]
    if(length(missingDates) > 0)
      temperatures <- rbind(temperatures, 
                            data.frame(loc = prov, date = missingDates, temp = NA))
    
    # interpolation of missing values
    ordered <- subset(temperatures, loc == prov)
    ordered <- ordered[order(ordered$date),]
    ordered$temp <- imputeTS::na_interpolation(ordered$temp)
    tmp <- rbind(tmp, ordered)
  }
  
  temperatures <- tmp
  
  italy <- data.frame()

  for(i in c(1:length(seqDates)) ) {
    italy <- rbind(italy, 
                   data.frame(loc = "Italy",
                              date = seqDates[i],
                              temp = stats::weighted.mean(x = subset(temperatures, date == seqDates[i])$temp, 
                                                   w = subset(italy_ext$province, territorio %in% availableProv)$valore)
                   )
    )
  }
  
  return(rbind(temperatures, italy))
}


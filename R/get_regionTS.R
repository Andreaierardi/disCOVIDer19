#' Data acquisition sorted by region
#'
#' @return A list containing the original dataset splitted into each region.
#'
#' @examples
#' \dontrun{
#' regTS <- get_regionTS()
#' names(regTS) # List of regions names
#' }
#'
#' @export
get_regionTS <- function() {
  data <- read.csv("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-regioni/dpc-covid19-ita-regioni.csv",
                   header = TRUE)

  data$data <- as.Date(as.character(data$data), format = "%Y-%m-%d")

  out <- list()
  for(region in unique(data$denominazione_regione)) {
    out[[as.character(region)]] <- subset(data, denominazione_regione == region)
    n <- nrow(out[[as.character(region)]])
    out[[as.character(region)]]$data_seriale <- c(1:n)
  }



  return(out)
}

#' Data acquisition sorted by province
#'
#' @return A list containing the original dataset splitted into single provinces.
#'
#' @examples
#' \dontrun{
#'   names(get_provTS()) # List of provinces names
#' }
#'
#' @export
get_provTS <- function() {
  data <- read.csv("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-province/dpc-covid19-ita-province.csv",
                   header = TRUE, na.strings = "In fase di definizione/aggiornamento")

  data <- subset(data, !is.na(denominazione_provincia))
  data$data <- as.Date(as.character(data$data), format = "%Y-%m-%d")

  out <- list()
  for(province in unique(data$denominazione_provincia)) {
    out[[as.character(province)]] <- subset(data, denominazione_provincia == province)
    n <- nrow(out[[as.character(province)]])
    out[[as.character(province)]]$data_seriale <- c(1:n)
  }

  return(out)
}

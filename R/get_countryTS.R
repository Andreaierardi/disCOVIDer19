#' Data acquisition of Italy
#'
#' @return dataframe. Return a dataframe containing the dataset covid19 for Italty
#'
#' @examples
#' \dontrun{
#' get_countryTS()
#' }
#'
#' @export
get_countryTS <- function() {
  data <- read.csv("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-andamento-nazionale/dpc-covid19-ita-andamento-nazionale.csv",
                   header = TRUE)

  data$data <- as.Date(as.character(data$data), format = "%Y-%m-%d")
  data["data_seriale"] = c(1:length(data$data)-1)
  
  return(list("Italy" = data))

}

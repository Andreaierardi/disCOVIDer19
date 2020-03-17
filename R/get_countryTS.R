#' Data acquisition of Italy
#'
#' @return the national dataset
#' @examples
#' get_countryTS()
#' @export

get_countryTS <- function() {
  data <- read.csv("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-andamento-nazionale/dpc-covid19-ita-andamento-nazionale.csv",
                   header = TRUE)

  data$data <- as.Date(as.character(data$data), format = "%Y-%m-%d")

  return(data)

}

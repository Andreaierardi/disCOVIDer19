#' Data acquisition regional insentive care capacity
#'
#'
#' @examples
#' \dontrun{
#' regionTS = get_regionTS()
#' get_intensivecare_cap(regionTS,intensivecare_cap)
#' }
#' 
#' @param regionTS list. List of the Italy regional dataset
#'
#' @return dataframe. Return a dataframe containing information about regional intensive care capacity
#' @export
get_intensivecare_cap <- function(regionTS) {
  
  readfile = as.data.frame(intensivecare_capacity)
  colnames(readfile) = c("region","capacity")

#  readfile$region = split(as.character(readfile$region)," ")
  readfile = readfile[order(readfile$region),]
  
  sortedreg = regionTS[order(names(regionTS))]

  newdf = data.frame()
  for(i in 1:length(readfile$region))
  {
    reg = readfile$region[i]
    date = sortedreg[[reg]]$data
    intensive = sortedreg[[readfile$region[i]]]$terapia_intensiva
    perc = intensive /readfile$capacity[i] * 100
    perc = round(perc ,digits = 2)
    v = data.frame(date, intensive, readfile$capacity[i],perc,readfile$region[i])
    
    names(v) = c("data","occupancy","capacity","perc","region")
    newdf <- rbind(newdf, v)
  }
  colnames(newdf) = c("data","occupancy","capacity","perc","region")
  
  
  return(newdf)
}

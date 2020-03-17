#' Data acquisition regional insentive care capacity
#'
#'
#' @examples
#' \dontrun{
#' regionTS = get_regionTS()
#' get_intensivecare_cap(regionTS)
#' }
#' 
#' @param regionTS list. List of the Italy regional dataset
#' @return dataframe. Return a dataframe containing information about regional intensive care capacity
#' @export
get_intensivecare_cap <- function(regionTS) {
  
  readfile  <- read.csv(system.file("extdata", "Posti_TI.csv", package="covid19"),header=TRUE)
  colnames(readfile) = c("region","capacity")
  readfile = readfile[order(readfile$region),]
  occupation =c()
  
  sortedreg = regionTS[order(names(regionTS))]
  for(index_region in 1:length(sortedreg)) 
  {
    
    vector = sortedreg[[index_region]]$terapia_intensiva  
    occupation[index_region] = tail(vector, n = 1)
    
  }
  df = data.frame(readfile,occupation)
  colnames(df)= c("region","capacity","occupation")
  perc = c(as.integer(df$occupation/df$capacity*100))
  df = data.frame(df,perc)
  df = df[order(df$perc,decreasing = TRUE),]
  rownames(df) <- 1:nrow(df)
  
  return(df)
}

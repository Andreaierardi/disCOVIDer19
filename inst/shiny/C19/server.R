library(tidyverse)
library(plotly)
library(devtools)
library(shinydashboard)
library(httr)

## server.R ##

server <- function(input, output, session) {
  
  get_country <- function() {
    data <- read.csv("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-andamento-nazionale/dpc-covid19-ita-andamento-nazionale.csv",
                     header = TRUE)
    
    data$data <- as.Date(as.character(data$data), format = "%Y-%m-%d")
    data["data_seriale"] = c(1:length(data$data)-1)
    return(data)
    
  }
  
  
  source("exe_fit.R")
  source("get_intesivecare_cap.R")
  source("get_provTS.R")
  source("get_regionTS.R")

  countryTS <- get_country()
  regionTS <- get_regionTS()
  provTS <- get_provTS()
  intensivecare_capacity = get_intensivecare_cap(regionTS)
  
  source(file.path("server", "global/shinyjs.R"),  local = TRUE)$value
  
  source(file.path("server", "global/sidebar.R"),  local = TRUE)$value
  

 
  source(file.path("server/3module", "analysis.R"),  local = TRUE)$value
  
  source(file.path("server/2module", "intensivecare_cap.R"),  local = TRUE)$value
  
  source(file.path("server/1module", "map.R"),  local = TRUE)$value
  
}


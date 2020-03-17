library(tidyverse)
library(plotly)
library(devtools)
library(shinydashboard)
library(httr)

## server.R ##

server <- function(input, output, session) {
  
  source("get_provTS.R")
  source("get_regionTS.R")
  source("get_countryTS.R")
  source("get_intesivecare_cap.R")
  source("exe_fit.R")
  countryTS <- get_countryTS()
  regionTS <- get_regionTS()
  provTS <- get_provTS()
  intensivecare_capacity = get_intensivecare_cap(regionTS)
  
  source(file.path("server", "global/shinyjs.R"),  local = TRUE)$value
  
  source(file.path("server", "global/sidebar.R"),  local = TRUE)$value
  

 
  source(file.path("server/3module", "analysis.R"),  local = TRUE)$value
  
  source(file.path("server/2module", "intensivecare_cap.R"),  local = TRUE)$value
  
  source(file.path("server/1module", "map.R"),  local = TRUE)$value
  
}


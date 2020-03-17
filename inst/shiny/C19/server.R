library(tidyverse)
library(plotly)
library(devtools)
library(shinydashboard)
library(httr)

## server.R ##

server <- function(input, output, session) {
  
  regionTS <- covid19:::get_regionTS()
  countryTS <- covid19:::get_countryTS()

  provTS <- covid19:::get_provTS()
  intensivecare_capacity = covid19:::get_intensivecare_cap(regionTS)
  
  source(file.path("server", "global/shinyjs.R"),  local = TRUE)$value
  
  source(file.path("server", "global/sidebar.R"),  local = TRUE)$value
  

 
  source(file.path("server/3module", "analysis.R"),  local = TRUE)$value
  
  source(file.path("server/2module", "intensivecare_cap.R"),  local = TRUE)$value
  
  source(file.path("server/1module", "map.R"),  local = TRUE)$value
  
}


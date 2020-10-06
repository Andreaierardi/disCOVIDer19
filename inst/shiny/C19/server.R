
## server.R ##

server <- function(input, output, session) {
  
  
  source(file.path("server", "global/shinyjs.R"),  local = TRUE)$value
  
  source(file.path("server", "global/sidebar.R"),  local = TRUE)$value
  

  source(file.path("server/1module", "home.R"),  local = TRUE)$value
  
  source(file.path("server/2module", "inspection.R"),  local = TRUE)$value
  
  source(file.path("server/3module", "analysis.R"),  local = TRUE)$value
  
  source(file.path("server/3module", "analysis_2.R"),  local = TRUE)$value
  
  source(file.path("server/4module", "documentation.R"),  local = TRUE)$value
  
  
  shinyalert::shinyalert(imageWidth=100,imageUrl="https://cdn1.vectorstock.com/i/1000x1000/68/55/data-analysis-round-vector-7826855.jpg",animation="slide-from-top","Welcome!", 
                         "You can navigate through the app easily through the panels on the left and the scrollbars.\n\nNB. All plots are INTERACTIVE: draw a square to zoom in and take full advantage of dynamic tools!", type = "success")
  
  
}


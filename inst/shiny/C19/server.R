
## server.R ##

server <- function(input, output, session) {
  
  source(file.path("server", "global/shinyjs.R"),  local = TRUE)$value
  
  source(file.path("server", "global/sidebar.R"),  local = TRUE)$value
  

  source(file.path("server/0module", "home.R"),  local = TRUE)$value
  
  source(file.path("server/1module", "map.R"),  local = TRUE)$value
  
  source(file.path("server/2module", "inspection.R"),  local = TRUE)$value
  
  source(file.path("server/3module", "analysis.R"),  local = TRUE)$value
  
  source(file.path("server/3module", "analysis_2.R"),  local = TRUE)$value
  
  source(file.path("server/4module", "documentation.R"),  local = TRUE)$value
  
  
  shinyalert::shinyalert(imageWidth=100,imageUrl="https://cdn1.vectorstock.com/i/1000x1000/68/55/data-analysis-round-vector-7826855.jpg",animation="slide-from-top","Welcome!", 
                         HTML("You can navigate through the app easily through the panels on the left and the scrollbars.\n\nNB. All plots are INTERACTIVE: draw a square to zoom in and take full advantage of dynamic tools! \n\n\n ====  Notice ==== \n We and selected partners, use cookies or similar technologies as specified in the cookie policy.
You can consent to the use of such technologies by closing this notice, by scrolling this page, by interacting with any link or button outside of this notice or by continuing to browse otherwise."), type = "success")
  
}


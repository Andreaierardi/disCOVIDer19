shinydashboard::tabItem(
  tabName = "tab_3_2",
  
  shinydashboard::valueBox(
    "Entropy",
    "Analysis",
    icon = icon("chart-bar"),
    color = "red",
    width = NULL
  ),
  
  shinydashboard::box(title = "Entropy", status = "danger", solidHeader = TRUE,
                      width = NULL,
                      
                      shinydashboard::tabBox(width = 12,
                                             title = NULL,
                                             tabPanel(h4("Conditional Entropy"),
                                                      highcharter::highchartOutput("c_entropy_plot")%>%shinycssloaders::withSpinner( color="#dd4b39")
                                             ),
                                             tabPanel(h4("Entropy"),
                                                      highcharter::highchartOutput("entropy_plot")%>%shinycssloaders::withSpinner( color="#dd4b39")
                                             ))
)
)
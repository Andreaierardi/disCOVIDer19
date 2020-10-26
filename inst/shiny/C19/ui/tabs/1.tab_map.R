shinydashboard::tabItem(tabName = "map",
                        shinydashboard::valueBox("Map", 
                                                 paste("Most recent update:",
                                                       tail(countryTS$Italy$data,1)),
                                                 icon=icon("history"),
                                                 color = "red", width = NULL),
                                 
                                 shinydashboard::box(title="Number of cases", solidHeader = T,
                                                     width = NULL,
                                                     color = "red",
                                                     tags$head(tags$style(HTML('
 /* tabBox background */

 .nav-tabs-custom > .nav-tabs > li.active {
     border-top-color: red !important;
 }
 
  .btn-default {
    background-color: #dd4b39 !important;
    color: white !important;
    border-color: #dd4b39 !important;
}
                                               '))),
                                                     
                                                     shinydashboard::tabBox(
                                                       width = 12,
                                                       # height = "250px",
                                                       title = fluidRow(
                                                         div(style="display: inline-block;vertical-align:top;",
                                                             tags$head(tags$style("
                       .jhr{
                       display: inline;
                       vertical-align: middle;
                       padding-left: 10px;
                       }")),
                                                             
                                                             selectInput(inputId = "map_value",
                                                                         label = NULL,
                                                                         choices = c("absolute", "proportion", "density", "growth"),
                                                                         width="150px"),
                                                             
                                                             #   shinyWidgets::pickerInput(inputId = "map_value",
                                                             #          label = NULL,
                                                             #          choices = c("absolute", "proportion", "density"),
                                                             #          choicesOpt = list(content = c(
                                                             #            sprintf("<img src='https://www.color-hex.com/palettes/4699.png' width=30px><div class='jhr'>%s</div></img>", factor("absolute",levels=c("absolute","proportion","density")) ),
                                                             #            sprintf("<img src='https://www.color-hex.com/palettes/12521.png' width=30px><div class='jhr'>%s</div></img>", factor("proportion",levels=c("absolute","proportion","density")) ),
                                                             #            sprintf("<img src='https://www.color-hex.com/palettes/30573.png' width=30px><div class='jhr'>%s</div></img>", factor("density",levels=c("absolute","proportion","density")) )
                                                             #          )))
                                                             
                                                         ),
                                                          div(style="display: inline-block;vertical-align:top;",
                                                             
                                                             # shinyWidgets::circleButton("show", icon=icon("search-plus"),size="sm")
                                          
                                                             # actionButton(inputId="show", icon=icon("search-plus"), label="")
                                                             
                                                          )
                                                       ),
                                                       # The id lets us use input$tabset1 on the server to find the current tab
                                                       id = "tabset1",
                                                       tabPanel("By Province",
                                                                shinycssloaders::withSpinner(
                                                                  highcharter::highchartOutput('map_province',
                                                                                               width = "100%",
                                                                                               height = "600px"),
                                                                  color="#dd4b39"
                                                                )
                                                       ),
                                                       tabPanel("By Region",
                                                                shinycssloaders::withSpinner(
                                                                  highcharter::highchartOutput('map_region',
                                                                                               width = "100%",
                                                                                               height = "600px"
                                                                  ),
                                                                  color="#dd4b39"
                                                                )
                                                       )
                                                     ),
                                                     height=NULL, status="danger"
                                 )
                        
)
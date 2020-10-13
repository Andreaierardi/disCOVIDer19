shinydashboard::tabItem(tabName = "home",
                        shinydashboard::valueBox("Coronavirus in Italy", 
                                                 paste("Most recent update:",
                                                       tail(countryTS$Italy$data,1)),
                                                 icon=icon("history"),
                                                 color = "red", width = NULL),
                        fluidRow(
                          column(6,
                                 
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
                                                                                               height = "510px"),
                                                                  color="#dd4b39"
                                                                )
                                                       ),
                                                       tabPanel("By Region",
                                                                shinycssloaders::withSpinner(
                                                                  highcharter::highchartOutput('map_region',
                                                                                               width = "100%",
                                                                                               height = "510px"
                                                                  ),
                                                                  color="#dd4b39"
                                                                )
                                                       )
                                                     ),
                                                     height=NULL, status="danger"
                                 )
                                 
                          ),
                          column(6,
                                 
                                 
                                 fluidRow(
                                   shinydashboard::valueBox(tail(countryTS$Italy$totale_casi,1), "Total cases", icon = icon("notes-medical"),
                                                            color = "red", width = 6),
                                   shinydashboard::valueBox(tail(countryTS$Italy$terapia_intensiva,1), "Intensive care", icon = icon("procedures"),
                                                            color = "orange", width = 6)
                                 ),
                                 fluidRow(
                                   shinydashboard::valueBox(tail(countryTS$Italy$totale_ospedalizzati,1), "Hospitalised", icon = icon("hospital"),
                                                            color = "yellow", width = 6),
                                   shinydashboard::valueBox(tail(countryTS$Italy$isolamento_domiciliare,1), "Home isolation", icon = icon("home"),
                                                            color = "maroon", width = 6)
                                 ),
                                 
                                 shinydashboardPlus::flipBox(
                                   id = 1,
                                   width = 12,
                                   main_img = "https://cdn1.vectorstock.com/i/1000x1000/68/55/data-analysis-round-vector-7826855.jpg",
                                   header_img = "https://cdn.mos.cms.futurecdn.net/JtVH5Khvihib7dBDFY9ZDR.jpg",
                                   front_title = "Covid-19 Hack",
                                   back_title = "About us",
                                   HTML("We are a team of data science students from Universita' degli Studi di Milano. 
                            This project is aimed at tracking and modelling the Covid-19 spread in Italy.
                             The data is synchronised with the civil protection database. Each time the app is run it checks for
                            updates in the civil protection database <br><br><br><hr>"),
                                   br(),
                                   back_content = tagList(
                                     
                                     
                                     fluidRow(
                                       column(6,
                                              shinydashboardPlus::productList(
                                                shinydashboardPlus::productListItem(
                                                  
                                                  src = "https://avatars1.githubusercontent.com/u/36515398?s=400&u=152624d5b1720f1e66ffd3fbd43c6e13704c3e42&v=4", 
                                                  productTitle = HTML('<b><a href="https://ierardiandrea.com/">Andrea Ierardi</a></b><br>
                                                       <a href="https://www.linkedin.com/in/andreaierardi/" rel="nofollow noreferrer">
                                                       <img src="https://i.stack.imgur.com/gVE0j.png" alt="linkedin"> LinkedIn</a> &nbsp; <br>
                                                       <a href="https://github.com/Andreaierardi" rel="nofollow noreferrer">
                                                      <img src="https://i.stack.imgur.com/tskMh.png" alt="github"> Github</a> &nbsp; <br>
                                                      <a href="https://ierardiandrea.com/" rel="nofollow noreferrer">
                                                      <i class="fas fa-cloud"></i> Website  </a>'), 
                                                  productPrice = NULL
                                                ),
                                                shinydashboardPlus::productListItem(
                                                  src = "https://avatars2.githubusercontent.com/u/60004596?s=460&u=aa1d8abbfca8d2fcf57bc9ff4688f817ebd3e5ad&v=4", 
                                                  productTitle = HTML('<b><a href="https://www.linkedin.com/in/fabio-caironi-8361091a2/">Fabio Caironi</a></b><br>
                                                      <a href="https://www.linkedin.com/in/fabio-caironi-8361091a2/" rel="nofollow noreferrer"> 
                                                      <img src="https://i.stack.imgur.com/gVE0j.png" alt="linkedin"> LinkedIn</a>  &nbsp; <br>
                                                      <a href="https://github.com/fabio130497" rel="nofollow noreferrer"> 
                                                      <img src="https://i.stack.imgur.com/tskMh.png" alt="github"> Github </a> &nbsp; '),
                                                  productPrice = NULL
                                                ),
                                                shinydashboardPlus::productListItem(
                                                  src = "https://avatars0.githubusercontent.com/u/59998291?s=460&v=4", 
                                                  productTitle = HTML('<b><a href="https://github.com/De-Rham-Cohomology">Federico Matteucci</a></b><br>
                                                       <a href="https://github.com/De-Rham-Cohomology" rel="nofollow noreferrer"> 
                                                       <img src="https://i.stack.imgur.com/tskMh.png" alt="github"> Github </a> &nbsp;
                                                      '), 
                                                  
                                                  productPrice = NULL
                                                )
                                              )
                                       ),
                                       column(6,
                                              shinydashboardPlus::productList(
                                                shinydashboardPlus::productListItem(
                                                  src = "https://avatars3.githubusercontent.com/u/59971032?s=400&u=38395af942e20f0c9a395b2b30b12763a39ca8ac&v=4", 
                                                  productTitle = HTML('<b><a href="https://www.linkedin.com/in/greg-saporito/">Gregorio Saporito</a></b><br>
                                                       <a href="https://www.linkedin.com/in/greg-saporito/" rel="nofollow noreferrer">
                                                       <img src="https://i.stack.imgur.com/gVE0j.png" alt="linkedin"> LinkedIn</a>  &nbsp;<br>
                                                       <a href="https://github.com/gregorio-saporito" rel="nofollow noreferrer"> 
                                                       <img src="https://i.stack.imgur.com/tskMh.png" alt="github"> Github </a> &nbsp; 
                                                      '), 
                                                  productPrice = NULL
                                                ),
                                                shinydashboardPlus::productListItem(
                                                  src = "https://avatars3.githubusercontent.com/u/60003802?s=460&u=6463f4db28ebb1eaf463f117093a803af1b9cabc&v=4", 
                                                  productTitle = HTML('<b><a href="https://www.linkedin.com/in/marzio-de-corato-2351a44b/">Marzio De Corato</a></b><br>
                                  <a href="https://www.linkedin.com/in/marzio-de-corato-2351a44b/" rel="nofollow noreferrer">
                                  <img src="https://i.stack.imgur.com/gVE0j.png" alt="linkedin"> LinkedIn </a>  &nbsp; <br>
                                  <a href="https://github.com/marzione00" rel="nofollow noreferrer"> 
                                  <img src="https://i.stack.imgur.com/tskMh.png" alt="github"> Github </a> &nbsp; 
                                                      '), 
                                                  productPrice = NULL
                                                )
                                              )
                                       )
                                     )
                                     
                                     
                                   )
                                 )
                                 
                                 
                                 
                          )
                          
                        )
                        
)
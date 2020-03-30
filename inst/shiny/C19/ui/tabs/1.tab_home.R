shinydashboard::tabItem(tabName = "tab_1",
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
                                                                         choices = c("absolute", "percentage", "density")),
                                                             
                                                             #   shinyWidgets::pickerInput(inputId = "map_value",
                                                             #          label = NULL,
                                                             #          choices = c("absolute", "percentage", "density"),
                                                             #          choicesOpt = list(content = c(
                                                             #            sprintf("<img src='https://www.color-hex.com/palettes/4699.png' width=30px><div class='jhr'>%s</div></img>", factor("absolute",levels=c("absolute","percentage","density")) ),
                                                             #            sprintf("<img src='https://www.color-hex.com/palettes/12521.png' width=30px><div class='jhr'>%s</div></img>", factor("percentage",levels=c("absolute","percentage","density")) ),
                                                             #            sprintf("<img src='https://www.color-hex.com/palettes/30573.png' width=30px><div class='jhr'>%s</div></img>", factor("density",levels=c("absolute","percentage","density")) )
                                                             #          )))
                                                             
                                                         ),
                                                         div(style="display: inline-block;vertical-align:top;",
                                                             
                                                             # shinyWidgets::circleButton("show", icon=icon("search-plus"),size="sm")
                                                             
                                                             actionButton("show", icon=icon("search-plus"),label="show")
                                                             
                                                         )
                                                       ),
                                                       # The id lets us use input$tabset1 on the server to find the current tab
                                                       id = "tabset1",
                                                       tabPanel("By Province",
                                                                shinycssloaders::withSpinner(
                                                                  highcharter::highchartOutput('map_province',
                                                                                               width = "100%",
                                                                                               height = "475px"),
                                                                  color="#dd4b39"
                                                                )
                                                       ),
                                                       tabPanel("By Region",
                                                                shinycssloaders::withSpinner(
                                                                  highcharter::highchartOutput('map_region',
                                                                                               width = "100%",
                                                                                               height = "475px"
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
                                                       <img src="https://i.stack.imgur.com/gVE0j.png" alt="linkedin"> LinkedIn</a> &nbsp; 
                                                       <a href="https://github.com/Andreaierardi" rel="nofollow noreferrer">
                                                      <img src="https://i.stack.imgur.com/tskMh.png" alt="github"> Github</a> &nbsp; 
                                                      <a href="https://ierardiandrea.com/" rel="nofollow noreferrer">
                                                      <i class="fas fa-cloud"></i> Website  </a>'), 
                                                  productPrice = NULL
                                                ),
                                                shinydashboardPlus::productListItem(
                                                  src = "https://media-exp1.licdn.com/dms/image/C4D03AQFNxDX9vdxEmQ/profile-displayphoto-shrink_800_800/0?e=1590019200&v=beta&t=ftXpX3Wg-dB2t8sBoSYspTKC3z5cK2ehYhWk5obIBh4", 
                                                  productTitle = HTML('<b><a href="https://www.linkedin.com/in/fabio-caironi-8361091a2/">Fabio Caironi</a></b><br>
                                                      <a href="https://www.linkedin.com/in/fabio-caironi-8361091a2/" rel="nofollow noreferrer">
                                                      <img src="https://i.stack.imgur.com/gVE0j.png" alt="linkedin"> LinkedIn</a>  &nbsp;
                                                      <a href="https://github.com/fabio130497" rel="nofollow noreferrer"> 
                                                      <img src="https://i.stack.imgur.com/tskMh.png" alt="github"> Github </a> &nbsp; '),
                                                  productPrice = NULL
                                                ),
                                                shinydashboardPlus::productListItem(
                                                  src = "data:image/png;base64,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", 
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
                                                       <img src="https://i.stack.imgur.com/gVE0j.png" alt="linkedin"> LinkedIn</a>  &nbsp;
                                                       <a href="https://github.com/gregorio-saporito" rel="nofollow noreferrer"> 
                                                       <img src="https://i.stack.imgur.com/tskMh.png" alt="github"> Github </a> &nbsp; 
                                                      '), 
                                                  productPrice = NULL
                                                ),
                                                shinydashboardPlus::productListItem(
                                                  src = "https://media-exp1.licdn.com/dms/image/C5603AQG869ZMIPrdag/profile-displayphoto-shrink_800_800/0?e=1590019200&v=beta&t=hiWKi79i8C8R_m7c-tHu9AWcF_bv3WJPd6B9N7Wk2XM", 
                                                  productTitle = HTML('<b><a href="https://www.linkedin.com/in/marzio-de-corato-2351a44b/">Marzio De Corato</a></b><br>
                                  <a href="https://www.linkedin.com/in/marzio-de-corato-2351a44b/" rel="nofollow noreferrer">
                                  <img src="https://i.stack.imgur.com/gVE0j.png" alt="linkedin"> LinkedIn </a>  &nbsp;
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
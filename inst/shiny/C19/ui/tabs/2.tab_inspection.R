shinydashboard::tabItem(tabName = "tab_2",
                        
                        shinydashboard::valueBox("Data Inspection", "Descriptive analysis",
                                                 icon=icon("search"),
                                                 color = "red", width = NULL),
                        
                        
                        
                        shinydashboard::valueBox("Introduction", "Total cases, total deaths, total recovered, total hospitalised",
                                                 icon=icon("chart-line"),
                                                 color = "navy", width = NULL),
                        
                        
                        shinydashboard::box(title="General info", solidHeader = T,
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
                                            
                                            shinydashboard::tabBox(width = 12,
                                                                   title = NULL,
                                                                   tabPanel(h2("Plot"),
                                                                            
                                                                            
                                                                            shiny::fluidRow(
                                                                              shiny::column(2,
                                                                                            shiny::selectInput(
                                                                                              inputId = "countrytab2", label = "Country",
                                                                                              choices = countryNames, selected = "Italy"),
                                                                                            
                                                                                            shiny::selectInput(
                                                                                              inputId = "regiontab2", label = "Region",
                                                                                              choices = c("--- ALL ---" = "default", regNames), selected = NULL),
                                                                                            
                                                                                               shiny::selectInput(
                                                                                               inputId = "provincetab2", label = "Province",
                                                                                               choices = c("--- ALL ---" = "default"
                                                                                                           , provNames
                                                                                                           ), selected = NULL),
                                                                                            
                                                                                            radioButtons("difference", label = "Select cumulative or difference plot",
                                                                                                         choices = list("Cumulative" = 1, "Difference" = 2), 
                                                                                                         selected = 1),
                                                                                            
                                                                                            hr(),
                                                                                            p("For province, only total case data are available")
                                                                              ),
                                                                              shiny::column(10,
                                                                                            highcharter::highchartOutput("general_infos_plot") %>% shinycssloaders::withSpinner( color="#dd4b39")
                                                                                            
                                                                              )
                                                                            )
                                                                            
                                                                   ),
                                                                   
                                                                   tabPanel(h2("Raw data"),
                                                                            shiny::uiOutput("rawData_input"),
                                                                            DT::dataTableOutput("rawData_table")
                                                                   )
                                            )
                        ),
                        
                        
                        
                        br(),
                        br(),
                        shinydashboard::valueBox("Deeper inspection", "hospital occupancy, growth monitoring and test tracking",
                                                 icon=icon("chart-line"),
                                                 color = "navy", width = NULL),
                        
                        fluidRow(
                          shinydashboard::box(title="Intensive care information", solidHeader = T,
                                              width = NULL,
                                              color = "red",
                                              status = "danger",
                          column(2,
                               
                                                     selectInput("occupancy_date",
                                                                 label = "Select date",
                                                                 choices = seq(init_date,by=1,fin_date),
                                                                 selected = fin_date),
                                                     
                                                     
                                 
                                 
                                 
                                 ),
                          column(10,
                                                     
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
                                                     
                                                     
                                                     shinydashboard::tabBox(width = 12,
                                                                            title = NULL,
                                                                            selected = "tab1",
                                                                            # The id lets us use input$tabset1 on the server to find the current tab
                                                                            id = "tabs",
                                                                            tabPanel(value = "tab1",
                                                                                     title = "% occupation/capacity",
                                                                                     plotly::plotlyOutput("intensivecare_cap_perc",
                                                                                                          width = "100%",
                                                                                                          height = "415px"
                                                                                     ) %>% 
                                                                                       shinycssloaders::withSpinner( color="#dd4b39")
                                                                            ),
                                                                            tabPanel(value = "tab2",
                                                                                     title = "capacity vs. occupation ",
                                                                                     plotly::plotlyOutput("intensivecare_cap",
                                                                                                          width = "100%",
                                                                                                          height = "415px"
                                                                                     ) %>%
                                                                                       shinycssloaders::withSpinner( color="#dd4b39")
                                                                            )
                                                     ),
                                                     
                                                     

                                 
                                 
                                 
                                 
                                 
                                 
                                 
                          ))),
                        hr(),
                        fluidRow(
                          column(6,
                                 
                                 
                                 
                                 shinydashboard::box(title="Growth Monitoring", solidHeader = T,
                                                     width = NULL,
                                                     color = "red",
                                                     
                                                     
                                                     shinydashboard::box(    
                                                       title=NULL,
                                                       solidHeader = T,
                                                       width = NULL,
                                                       color = "red",
                                                       
                                                       
                                                       footer = fluidRow(
                                                         column(
                                                           width = 6,
                                                           shinydashboardPlus::descriptionBlock(
                                                             number = paste0(tail(country_growth$growth,1),"%"),
                                                             number_color = ifelse(tail(country_growth$growth,1)>0,"red","green"), 
                                                             number_icon = ifelse(tail(country_growth$growth,1)>0,"fa fa-caret-up","fa fa-caret-down"),
                                                             header = "CASES GROWTH", 
                                                             text = NULL, 
                                                             right_border = TRUE,
                                                             margin_bottom = FALSE
                                                           )
                                                         ),
                                                         column(
                                                           width = 6,
                                                           shinydashboardPlus::descriptionBlock(
                                                             number = paste0(tail(country_growth$growth_change,1),"%"),
                                                             number_color = ifelse(tail(country_growth$growth_change,1)>0,"red","green"), 
                                                             number_icon = ifelse(tail(country_growth$growth_change,1)>0,"fa fa-caret-up","fa fa-caret-down"),
                                                             header = HTML("CASES GROWTH &Delta;"), 
                                                             text = NULL, 
                                                             right_border = FALSE,
                                                             margin_bottom = FALSE
                                                           )
                                                         )
                                                       )
                                                     ),
                                                     
                                                     
                                                     highcharter::highchartOutput("plot_test", width = "100%",
                                                                                  height = "400px")%>% shinycssloaders::withSpinner( color="#dd4b39"),
                                                     height=NULL, status="danger")
                                 
                                 
                                 
                          ),
                          
                          column(6,
                                 shinydashboard::box(title="Tests Tracking", status="danger", 
                                                     solidHeader = TRUE, 
                                                     width=12,
                                                     highcharter::highchartOutput("tamp_plot")%>%shinycssloaders::withSpinner( color="#dd4b39")
                                 )
                          )
                        )
                        
)
shinydashboard::tabItem(tabName = "tab_2",
                        
                        shinydashboard::valueBox("Data Inspection", "Descriptive analysis",
                                                 icon=icon("search"),
                                                 color = "red", width = NULL),
                        
                        
                        
                        shinydashboard::valueBox("Introduction", "Total cases, total deaths, total recovered, total hospitalised",
                                                 icon=icon("chart-line"),
                                                 color = "navy", width = NULL),
                        
                        shinydashboard::box(title = "Decrees timeline", status = "danger", solidHeader = TRUE,
                                            width = NULL,
                                            highcharter::highchartOutput("decree_tl"))%>%shinycssloaders::withSpinner( color="#dd4b39"),
                        
                        
                        shinydashboard::box(title="General info", status = "danger", solidHeader = T,
                                            width = NULL,
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
                                            
                                            fluidRow(
                                              column(4,
                                                     shiny::selectInput(
                                                       inputId = "geninfo_coun", label = "Country",
                                                       choices = countryNames, selected = "Italy")
                                                     ),
                                              column(4,
                                                     shiny::selectInput(
                                                       inputId = "geninfo_reg", label = "Region",
                                                       choices = c("--- ALL ---" = "default", regNames), selected = NULL)
                                                     ),
                                              column(4,
                                                     shiny::selectInput(
                                                       inputId = "geninfo_prov", label = "Province",
                                                       choices = c("--- ALL ---" = "default", provNames), selected = NULL)
                                                     )
                                            ),
                                            
                                            fluidRow(
                                              column(5),
                                              column(4,
                                                     shiny::radioButtons(
                                                       inputId = "geninfo_type", 
                                                       label = "Data type:",
                                                       choiceNames = list(HTML("<p><strong><span style='background-color: rgb(0, 0, 0); color: rgb(255, 255, 255);'>Total</span></strong> (cumulative)</p>"),
                                                                          HTML("<p><span style='background-color: rgb(184, 49, 47); color: rgb(255, 255, 255);'><strong>New</strong></span> (daily)</p>"),
                                                                          HTML("<p><span style='background-color: rgb(255, 204, 0); color: rgb(255, 255, 255);'><strong>Current</strong></span></p>")
                                                       ),
                                                       choiceValues = list("tot", "new", "cur"),
                                                       selected = "tot",
                                                       inline = FALSE)
                                                     ),
                                              column(3)
                                            ),
                                            
                                            helpText("Total cases is the only available data for provinces"),
                                            
                                            hr(),
                                            
                                            shinydashboard::tabBox(width = 12,
                                                                   title = NULL,
                                                                   tabPanel(h4("Plot"),
                                                                            highcharter::highchartOutput("geninfo_plot") %>% shinycssloaders::withSpinner( color="#dd4b39")
                                                                   ),
                                                                   tabPanel(h4("Table"),
                                                                            DT::dataTableOutput("geninfo_table") %>% shinycssloaders::withSpinner( color="#dd4b39")
                                                                   )
                                            )
                        ),
                        
                        # age distribution
                        shinydashboard::box(
                          title="Infected Age Distribution", status = "danger", solidHeader = T,
                          width = NULL,
                          tags$head(tags$style(HTML('
                                                     /* background */
                                                     
                                                     .nav-tabs-custom > .nav-tabs > li.active {
                                                     border-top-color: red !important;
                                                     }
                                                     
                                                     .btn-default {
                                                     background-color: #dd4b39 !important;
                                                     color: white !important;
                                                     border-color: #dd4b39 !important;
                                                     }
                                                     '))),
                          
                          shiny::fluidRow(
                            shiny::column(2,
                                          shiny::selectInput(
                                            inputId = "countrytab3", label = "Country",
                                            choices = countryNames, selected = "Italy"),
                                          
                                          shiny::selectInput(
                                            inputId = "regiontab3", label = "Region",
                                            choices = unique(age_df_final$region), selected = "--- ALL ---")
                            ),
                            shiny::column(10,
                                          highcharter::highchartOutput("age_plot")%>%shinycssloaders::withSpinner( color="#dd4b39")
                                          
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
                                                                 selected = fin_date)
                                                     
                                                     
                                 
                                 
                                 
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
                                                     )
                                                     
                                                     

                                 
                                 
                                 
                                 
                                 
                                 
                                 
                          ))),
                        hr(),
                        fluidRow(
                                 
                                 
                                 shinydashboard::box(title="Growth Monitoring", solidHeader = T,
                                                     width = NULL,
                                                     color = "red",
                                                     
                                                     column(2,
                                                            
                                                            
                                                            shiny::selectInput(
                                                              inputId = "growth_country", label = "Country",
                                                              choices = countryNames, selected = "Italy"),
                                                            
                                                            shiny::selectInput(
                                                              inputId = "growth_region", label = "Region",
                                                              choices = c(names(regionTS), "--- ALL ---"), selected = "--- ALL ---"),
                                                            
                                                            shiny::uiOutput("regprov_dfout"),
                                                            shiny::uiOutput("growth_NAlog")
                                                            
                                                            
                                                            ),
                                                     
                                                     column(10,
                                                     
                                                     shinydashboard::box(    
                                                       title=NULL,
                                                       solidHeader = T,
                                                       width = NULL,
                                                       color = "red",
                                                       
                                                       
                                                       footer = fluidRow(
                                                         column(
                                                           width = 6,
                                                           uiOutput("summary_box_growth")
                                                         ),
                                                         column(
                                                           width = 6,
                                                           uiOutput("summary_box_growth_change")
                                                         )
                                                       )
                                                     ),
                                                     
                                                     
                                                     highcharter::highchartOutput("plot_test", width = "100%",
                                                                                  height = "400px")%>% shinycssloaders::withSpinner( color="#dd4b39")
                                                     ),
                                                     height=NULL, status="danger")
                                 
                                 
                        ),
                          
                          fluidRow(
                                 shinydashboard::box(title="Tests Tracking", status="danger", 
                                                     solidHeader = TRUE, 
                                                     width=12,
                                                     
                                                       column(2,
                                                              shiny::selectInput(
                                                                inputId = "test_country", label = "Country",
                                                                choices = countryNames, selected = "Italy"),
                                                              
                                                              shiny::selectInput(
                                                                inputId = "test_region", label = "Region",
                                                                choices = c(names(regionTS), "--- ALL ---"), selected = "--- ALL ---"),
                                                              
                                                              shiny::checkboxInput(
                                                                inputId = "test_aggr", label = "Aggregate by week",
                                                                value = FALSE
                                                              ),
                                                              shiny::uiOutput("test_avg"),
                                                              shiny::uiOutput("test_NAlog")
                                                              ),
                                                       column(10,
                                                              highcharter::highchartOutput("tamp_plot")%>%shinycssloaders::withSpinner( color="#dd4b39")
                                                              )
                                                     
                                 )
                          ),
                        
                        fluidRow(
                          shinydashboard::box(title = "Spreading delay", status = "danger", solidHeader = TRUE, width=12,
                                column(12,
                                       shiny::radioButtons("rank_type", "Rank by:",
                                                           choices = c("Start of outbreak" = "start", 
                                                                       "Peak of outbreak" = "peak",
                                                                       "End of outbreak" = "end"),
                                                           selected = "start"),
                                       highcharter::highchartOutput('map_rank', width = "100%", height = "510px")
                                       )
                        )
                        )
                        
                        
)

tabItem(tabName = "tab_3",
        
        valueBox("Data Analysis", "Analysis",
                 icon=icon("chart-bar"),
                 color = "red", width = NULL),
       
        
        fluidRow(
          column(12,
                 
                 
                 tabBox( width = 12,
                         title = "Analisys",
                         id = "tabset1",
                         height = NULL,
                         
                         #---------- TAB COUNTRY -----------
                         tabPanel(title = h4("Country"), 
                                  fluidRow(
                                          
                                          column(4,
                                                 shinydashboard::box(
                                                         width = 12,
                                                         status = "danger", 
                                                         solidHeader = TRUE,
                                                         title = "Input", 
                                                         shiny::uiOutput("countryInput")
                                                 )
                                          ),
                                          column(8,
                                                 shinydashboard::box(
                                                         color = "red", 
                                                         status ="danger",
                                                         title = "Charts", 
                                                         plotly::plotlyOutput("coolplot_country"),
                                                         width = 12),
                                          )
                                  ),
                                  
                                  # ----- summary row
                                  fluidRow(
                                          
                                          shinydashboard::tabBox(
                                                  width=6,
                                                  title = "Technical data", id = "tech_tab",
                                                  shiny::tabPanel("Fitting output", 
                                                                  box(
                                                                          title = "Fitting ouput", width = NULL, status = "danger",
                                                                          "TESTOO"
                                                                          #verbatimTextOutput("fit_smry")
                                                                          )),
                                                  
                                                  shiny::tabPanel("Chi-squared test", 
                                                                  box(
                                                                          title = "Chi-squared test", width = NULL, status = "danger",
                                                                          "TESTO"#htmlOutput("chisq_smry")
                                                                          )                                                      )
                                          )
                                          
                                          
                                          
                                  )
                                  
                                  
                                  
                                  
                         
                         
                         ),
                         #---------- TAB REGION -----------
                         tabPanel(title = h4("Region"),
                                  
                                  # ---- selector + plot row
                                  fluidRow(
                                    
                                    column(4,
                                           shinydashboard::box(
                                             width = 12,
                                             status = "danger", 
                                             solidHeader = TRUE,
                                             title = "Input", 
                                             shiny::uiOutput("regionInput")
                                           )
                                    ),
                                    column(8,
                                           shinydashboard::box(
                                             color = "red", 
                                             status ="danger",
                                             title = "Charts", 
                                             plotly::plotlyOutput("coolplot_region"),
                                             width = 12),
                                           )
                                    ),
                                  
                                  # ----- summary row
                                  fluidRow(
                                    
                                    shinydashboard::tabBox(
                                      width=6,
                                      title = "Technical data", id = "tech_tab",
                                      shiny::tabPanel("Fitting output", 
                                                      box(
                                                              title = "Fitting ouput", width = NULL, status = "danger",
                                                              verbatimTextOutput("fit_smry"))),

                                      shiny::tabPanel("Chi-squared test", 
                                                      box(
                                                           title = "Chi-squared test", width = NULL, status = "danger",
                                                           htmlOutput("chisq_smry"))                                                      )
                                    )
                                    
                                    
                                    
                                  )
                                  
                                  
                         ),
                         
                         #---------- TAB PROVINCE -----------
                         
                         shiny::tabPanel(title = h4("Province"), shiny::uiOutput("provPanel"))
                 )
                 
          )
          
        )
)


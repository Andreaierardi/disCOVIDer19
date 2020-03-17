tabItem(tabName = "tab_3",
        
        valueBox("Data Analysis", "Analysis",
                 icon=icon("chart-bar"),
                 color = "red", width = NULL),
        
        #  fluidRow(
        #    
        #    tabBox(
        #     # width = 12,
        #      title = "First tabBox",
        #      # The id lets us use input$tabset1 on the server to find the current tab
        #       height = "250px",
        #      tabPanel(title = "Country", shiny::uiOutput("countryPanel")),
        #      tabPanel("Tab2", "Tab content 2"),
        #      tabPanel(title = "Region",
        #               
        #               
        #              # waiter::use_waiter(),
        #               plotly::plotlyOutput("coolplot_region"),
        #             #  shinydashboard::box(color = "red",title = "Input", 
        #             #                      shiny::uiOutput("regionInput"),
        #             #                      width = 6),
        #               
        #            #   shinydashboard::box("Qualcosa", "Qua metteremo qualcosa", width = NULL),
        #               
        #            #   shinydashboard::box(color = "red", title = "Charts", plotly::plotlyOutput("coolplot_region"),
        #            #                       width = 6),
        #            #  shinydashboard::tabBox(
        #            #    title = "Technical data", id = "tech_tab", width = NULL,
        #            #    shiny::tabPanel("Fitting output", shiny::verbatimTextOutput("fit_smry")),
        #            #    shiny::tabPanel("Chi-squared test", shiny::verbatimTextOutput("chisq_smry"))
        #            #  )
        #      ),
        #      shiny::tabPanel(title = "Province", shiny::uiOutput("provPanel"))
        #      
        #    ),
        #    
        #    
        #  )
        
        fluidRow(
          column(12,
                 
                 
                 tabBox( width = 12,
                         title = "Analisys",
                         id = "tabset1",
                         height = NULL,
                         
                         #---------- TAB COUNTRY -----------
                         tabPanel(title = h4("Country"), shiny::uiOutput("countryPanel")),
                         
                         
                         
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
                                      shiny::tabPanel("Fitting output", shiny::verbatimTextOutput("fit_smry")),
                                      shiny::tabPanel("Chi-squared test", shiny::verbatimTextOutput("chisq_smry"))
                                    )
                                    
                                    
                                    
                                  )
                                  
                                  
                         ),
                         
                         #---------- TAB PROVINCE -----------
                         
                         shiny::tabPanel(title = h4("Province"), shiny::uiOutput("provPanel"))
                 )
                 
          )
          
        )
)


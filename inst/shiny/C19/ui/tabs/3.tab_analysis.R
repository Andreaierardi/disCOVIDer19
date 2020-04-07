shinydashboard::tabItem(
  tabName = "tab_3",
  
  shinydashboard::valueBox(
    "Data Analysis",
    "Analysis",
    icon = icon("chart-bar"),
    color = "red",
    width = NULL
  ),
  
  
  fluidRow(
    shinydashboard::box(width = 12,
                        status= "danger",
                        solidHeader = FALSE,
                        title = "Territory selection",
                        shiny::fluidPage(
                          shiny::fluidRow(
                            shiny::column(4,
                                          shiny::selectizeInput(
                                            inputId = "country", label = "Country",
                                            choices = countryNames, selected = "Italy")
                            ),
                            shiny::column(4,
                                          shiny::selectizeInput(
                                            inputId = "region", label = "Region",
                                            choices = c("--- ALL ---" = "", regNames), selected = NULL)
                            ),
                            shiny::column(4,
                                          shiny::selectizeInput(
                                            inputId = "province", label = "Province",
                                            choices = c("--- ALL ---" = "", provNames), selected = NULL)
                            )
                          )
                         
                        )
    )
  ),
  
  fluidRow(
    shiny::textOutput("log")
  ),
  
  shinydashboard::valueBox(
    "Logistic model",
    "Curve fitting on confirmed cases of infection's time series",
    icon = icon("analytics"),
    color = "navy",
    width = NULL
  ),
  
  shinydashboard::box(
    width = 12,
    status = "danger",
    solidHeader = TRUE,
    shiny::htmlOutput("selected_info1")
  ),
  
  fluidRow(
    column(
      4,
      shinydashboard::box(
        width = 12,
        status = "danger",
        solidHeader = TRUE,
        title = "Input",
        fluidRow(
          column(12,
                 
                 shiny::sliderInput(inputId = "fitInterval", label = "Choose fitting interval",
                                    min = init_date, max = fin_date, timeFormat = "%d %b",
                                    step = 1, value = c(init_date, fin_date)),
                 shiny::checkboxInput(inputId = "swab_std", label = "Standardise positive cases by total swabs"),
                 shiny::checkboxGroupInput(inputId = "plot_type", label = "Plot type",
                                           choices = list("Cumulative cases" = 1, "New cases" = 2),
                                           selected = 1),
                 hr(),
                 h3("Residuals"),
                 shiny::selectInput(inputId = "plot_res_type", "Residuals plot type",
                                    choices =  c("Residuals" = "Residuals",
                                                 "Standardised residuals" =  "Residuals_standardized",
                                                 "Autocorrelation" = "Autocorrelation",
                                                 "Square root of absolute residuals" = "Sqrt of abs of res vs fitted"),
                                    selected = "Residuals")
                 
          )
        )
      )
    ),
    column(
      8,
      shinydashboard::box(
        color = "red",
        status = "danger",
        title = "Plot",
        h4(shiny::htmlOutput("dates_sugg")),
        hr(),
        plotly::plotlyOutput("coolplot1") %>% shinycssloaders::withSpinner(color =
                                                                             "#dd4b39"),
        width = 12
      )
    )
  ),
  
  # ----- summary row
  fluidRow(
    column(
      5,
      
      shinydashboard::tabBox(
        width = 12,
        title = "Output summary",
        id = "tech_tab",
        shiny::tabPanel(
          "Fitting output",
          status = "danger",
          verbatimTextOutput("fit_smry")
        ),
        
        shiny::tabPanel("Tests",
                        status = "danger",
                        verbatimTextOutput("resid_smry"))
      )
    ),
    column(
      7,
      shinydashboard::box(
        width = 12,
        status = "danger",
        title = "Residuals",
        plotly::plotlyOutput("plot_residual") %>% shinycssloaders::withSpinner(color =
                                                                                 "#dd4b39")
        
      )
      
    )
  ),
  
  hr(),
  
  
  # --------  ARIMA ------
  
  
  
  shinydashboard::valueBox(
    "ARIMA model",
    "ARIMA(p,i,q) on log of confirmed cases of infection's time series",
    icon = icon("analytics"),
    color = "navy",
    width = NULL
  ),
  
  
  shinydashboard::box(
    width = 12,
    status = "danger",
    solidHeader = TRUE,
    shiny::htmlOutput("selected_info2")
  ),
  
  
  fluidRow(
    column(
      4,
      shinydashboard::box(
        width = 12,
        status = "danger",
        solidHeader = TRUE,
        title = "Input",
        shiny::sliderInput(inputId = "arima_interval", label = "Choose fitting interval",
                           min = init_date, max = fin_date, timeFormat = "%d %b",
                           step = 1, value = c(init_date,fin_date)),
        
        fluidRow(
          column(12,
                 shiny::sliderInput(inputId = "forecast", label = "Choose forecast lags",
                                    min = 1,  max = 40, value = 10),
                 
                 hr(),
                 
                 shiny::sliderInput(inputId = "ARIMA_p", label = "Choose p",
                                    min = 0, max = 10,step = 1,value=0),
                 shiny::sliderInput(inputId = "ARIMA_I", label = "Choose i",
                                    min = 0, max = 3,step = 1,value=0),
                 shiny::sliderInput(inputId = "ARIMA_q", label = "Choose q",
                                    min = 0, max = 10,step = 1,value=0)
                 
          )
        )
      )),
    column(
      8,
      
      shinydashboard::box(
        color = "red",
        status = "danger",
        
        title = "ARIMA forecast",
        h3(shiny::htmlOutput("parameters_sugg")),
        hr(),
        
        plotly::plotlyOutput("arima_coolplot1") %>% shinycssloaders::withSpinner(color =
                                                                                   "#dd4b39"),
        width = 12
      )
    )
  ),
  
  
  fluidRow(
    column(
      3,
      shinydashboard::box(
        color = "red",
        status = "danger",
        title = "Autocorrelations",
        plotly::plotlyOutput("arima_coolplot2") %>% shinycssloaders::withSpinner(color =
                                                                                   "#dd4b39"),
        width = 12
      )
    ),
    column(
      3,
      shinydashboard::box(
        color = "red",
        status = "danger",
        title = "Partial autocorrelations",
        plotly::plotlyOutput("arima_coolplot3") %>% shinycssloaders::withSpinner(color =
                                                                                   "#dd4b39"),
        width = 12
      )
    ),
    column(
      6,
      shinydashboard::box(
        color = "red",
        status = "danger",
        title = "Arima Check residuals",
        shiny::plotOutput("arima_coolplot4") %>% shinycssloaders::withSpinner(color =
                                                                                "#dd4b39"),
        width = 12
      )
    )
  ),
  
  
  fluidRow(
   
    column(
      6,
      shinydashboard::box(
        color = "red",
        status = "danger",
        title = "Arima Data Output",
        shiny::verbatimTextOutput("arima_shell_output") %>% shinycssloaders::withSpinner(color =
                                                                                           "#dd4b39"),
        width = 12
      )
    ),
    
    #background-color: #f5f5f5; */

    column(
      6,
      shinydashboard::box(
        color = "red",
        status = "danger",
        title = "Arima residuals output",
        tags$head(tags$style(HTML('
        pre
                                  {
                                  background-color: #ffffff;
                                  }
                                  '))),
        shiny::verbatimTextOutput("arima_shell_resid") %>% shinycssloaders::withSpinner(color =
                                                                                           "#dd4b39"),
        width = 12
      )
    )
  ),
  
  #====== SEIR ======
  
  shinydashboard::valueBox(
    "SEIR model",
    "Compartmental model based on confirmed cases of infection and recovery",
    icon = icon("analytics"),
    color = "navy",
    width = NULL
  ),
  
  
  shinydashboard::box(
    width = 12,
    status = "danger",
    solidHeader = TRUE,
    shiny::htmlOutput("selected_info3")
  ),
  
  shinydashboard::box(
     color = "red",
     status = "danger",
     solidHeader = TRUE,
     title = "Input",
     width = 12,
     fluidRow(
       column(4,
              h5("Incubation time"),
              hr(),
              shiny::sliderInput("IT_mean", "Mean", min = 2, max = 10, value = 6),
              shiny::sliderInput("IT_std", "St. deviation", min = 0.5, max = 1.5, value = 1)
              ),
       column(4
              ),
       column(4
              )
     )
  )
)

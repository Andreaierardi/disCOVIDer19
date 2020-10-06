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
                        solidHeader = TRUE,
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
  
  shinydashboard::box(width = 12,
                      status= "danger",
                      solidHeader = FALSE,
                      title = "Data cleaning",
                      shiny::fluidRow(
                        shiny::column(6, 
                                      shiny::radioButtons("direction_fill", label = "Direction", 
                                                          choices = list("Forward" = "forward", "Backward" = "backward"),
                                                          selected = "forward")
                                      ),
                        shiny::column(6, 
                                      shiny::radioButtons("method_fill", label = "Method", 
                                                          choices = list("Last Observation Carried Forward" = "locf", "Linear" = "linear"),
                                                          selected = "locf")
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
        plotly::plotlyOutput("coolplot1") %>% shinycssloaders::withSpinner(color = "#dd4b39"),
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
  
  #====== FFT ======
  
  shinydashboard::valueBox(
    "Fourier Analysis",
    "Periodic behaviour analysis",
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
  
  
  fluidRow(
    
    column(
      2,
      shinydashboard::box(
        width = 12,
        status = "danger",
        solidHeader = TRUE,
        title = "Input",
        shiny::sliderInput(inputId = "FFT_interval", label = "Choose fitting interval",
                           min = init_date, max = fin_date, timeFormat = "%d %b",
                           step = 1, value = c(init_date,fin_date))
      )),
    
    column(
      5,
      shinydashboard::box(
        color = "red",
        status = "danger",
        title = "FFT of daily cases",
        shiny::plotOutput("FFT_day_cases") %>% shinycssloaders::withSpinner(color = "#dd4b39"),
        width = 12
      )
    ),
    column(
      5,
      shinydashboard::box(
        color = "red",
        status = "danger",
        title = "FFT of the derivate of the daily cases",
        shiny::plotOutput("FFT_day_cases_diff") %>% shinycssloaders::withSpinner(color = "#dd4b39"),
        width = 12
      )
    )
    
    #background-color: #f5f5f5; */
  ),
  
  #====== R0 ======
  
  shinydashboard::valueBox(
    "Reproduction number",
    "R(t) estimation",
    icon = icon("analytics"),
    color = "navy",
    width = NULL
  ),
  
#  shinydashboard::box(
#    width = 12,
#    status = "danger",
#    solidHeader = TRUE,
#    shiny::htmlOutput("selected_info4")
#  ),
  
#  
  fluidRow(
#    
   column(
      3,
#      shinydashboard::box(
#        width = 12,
#        status = "danger",
#        solidHeader = TRUE,
#        title = "Input",
#        shiny::sliderInput(inputId = "Gamma_1", label = "Shape parameter",
#                           min = 0, max = 5 ,step = 0.5,value=1.40),
#        shiny::sliderInput(inputId = "Gamma_2", label = "Rate parameter",
#                           min = 0, max = 5,step = 0.5,value=0.75)
#     )
),
    column(
      9,
#      shinydashboard::box(
#        color = "red",
#        status = "danger",
#        title = "R(t)",
#        shiny::plotOutput("R_t_evaluation") %>% shinycssloaders::withSpinner(color = "#dd4b39"),
#        width = 12
#      )
   )
 ),

#  fluidRow(
#    column(
#      6,
#      shinydashboard::box(
#        color = "red",
#        status = "danger",
#        title = "R(t)",
#        shiny::plotOutput("R_t_goodness_of_fit") %>% shinycssloaders::withSpinner(color = "#dd4b39"),
#        width = 12
#      )
#    ),
#    
#    #background-color: #f5f5f5; */
#  
#    
#    column(
#      6,
#      shinydashboard::box(
#        color = "red",
#        status = "danger",
#        title = "FFT of R(t)",
#        shiny::plotOutput("R_t_evaluation_FFT") %>% shinycssloaders::withSpinner(color = "#dd4b39"),
#        width = 12
#      )
#    )
#  ),
    #background-color: #f5f5f5; */

  
  #====== SEIR ======
  
  shinydashboard::valueBox(
    "SEIR model",
    "Compartmental model based on confirmed cases of infection and recovery",
    icon = icon("analytics"),
    color = "navy",
    width = NULL
  ),

##------------
## DA ELIINARE !!!!  
fluidRow(
  column(12,
 shinydashboard::box(
    background = "black",
    "Working in progress..."
  )
  )
)
##------------


  
  #shinydashboard::box(
  #  width = 12,
  #  status = "danger",
  #  solidHeader = TRUE,
  # shiny::htmlOutput("selected_info5")
  #),
  
  
  # fluidRow(
  #   
  #  column(
  #     4,
  #     shinydashboard::box(
  #      width = 12,
  #       status = "danger",
  #       solidHeader = TRUE,
  #       title = "Input",
  #       shiny::sliderInput(inputId = "rate_IT", label = "Mean incubation time",
  #                          min = 0, max = 10, step = 0.1, value = 5.2),
  #       shiny::sliderInput(inputId = "rate_SRT", label = "Mean timespan from symptoms to recovery",
  #                          min = 0, max = 10, step = 0.1, value=round(log(5)/2) ,1),
  #       shiny::actionButton(inputId = "est_R0", "If epidemic continued as in initial stages"), 
  #       shiny::actionButton(inputId = "est_Rt", "all times Rt. Refer to previous tab for Rt parameters choice"),	
  #       shiny::sliderInput(inputId = "R0_exp_est_end", label = "If estimating initial R0, number of days to estimate",
  #                          min = 1, max = 20, step = 1, value = 5),
  #       shiny::sliderInput(inputId = "future", label = "Forecast lags",
  #                          min = 0, max = 100, step = 1, value = 0),
  #       shiny::checkboxInput(inputId = "plot_data", label = "Show true data points", value = TRUE)
  #     ),
  #     
  #     shinydashboard::box(
  #       width = 12,
  #       status = "danger",
  #       solidHeader = TRUE,
  #       title = "R0",
  #       shiny::verbatimTextOutput("SEIR_R0")
  #    )
  #     
  #   ),
  #   
  #   column(
  #     8,
  #     shinydashboard::box(
  #       color = "red",
  #       status = "danger",
  #       title = "SEIR plot",
  #       highcharter::highchartOutput("SEIR_plot") %>% shinycssloaders::withSpinner(color = "#dd4b39"),
  #       width = 12
  #     )
  #   )
  #   
  # )
  
  
  
  # fluidRow(
  #   column(12,
  # shinydashboard::box(
  #    color = "red",
  #    status = "danger",
  #    solidHeader = TRUE,
  #    title = "Input",
  #    width = 12,
  #   
  #             helpText("Under construction...")
  #             #h5("Incubation time"),
  #             #hr(),
  #             #shiny::sliderInput("IT_mean", "Mean", min = 2, max = 10, value = 6),
  #             #shiny::sliderInput("IT_std", "St. deviation", min = 0.5, max = 1.5, value = 1)
  #             )
  # 
  # ),
  #      column(4
  #             )
  #    )
  
)

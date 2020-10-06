## REACTIVES OF THIS CODE
reac_general <- shiny::reactiveValues()
reac_logistic <- shiny::reactiveValues()
reac_ARIMA <- shiny::reactiveValues(arimaOK = FALSE)
reac_FFT <- shiny::reactiveValues()
reac_R <- shiny::reactiveValues()
reac_SEIR <- shiny::reactiveValues()
    
    # THIS IS THE REACTIVE CONTAINER OF TERRITORY SELECTION VARIABLES.
t <- shiny::reactiveValues()
    
    ## Reactive values for global storage 




# Use this function waitLoading() to validate the content of t$r and prevent errors
# (just use it at the beginning of each chunk of code)
waitLoading <- shiny::reactive({
  shiny::validate(
    shiny::need(is_ready(t$r), "Wait...")
  )
  return(t$r)
})

waitInput <- shiny::reactive({
  shiny::validate(
    shiny::need(is_ready(input$region), "Wait...")
  )
  return(input$region)
})

# DEPENDS ON REACTIVE t
suggest_dates <- function()
{

  index = covid19::const_trim(eval(t$data)[[t$name]]$totale_casi,1)
  sugStart = eval(t$data)[[t$name]]$data[index]
  #sugStart = reac_general$sample_date[index]
  
  return(c(sugStart, fin_date))
}

# DEPENDS ON REACTIVES t AND reac_ARIMA! (but not on reac_ARIMA$arima)
suggest_lags <- function()
{
  checkExp({
    sugg <- toString(forecast::auto.arima(log(reac_ARIMA$sample_cases_trim)))
    matches <- regmatches(sugg, gregexpr("[[:digit:]]+", sugg))
    return(as.numeric(unlist(matches)))
  }, "There is no suitable ARIMA model")
}


# Province input updater
shiny::observe({
  wait <- waitInput()
  if(input$region != "") {
    ch <- c("--- ALL ---" = "", regAndProv[regAndProv$region == input$region, "province"])
  } else {
    ch <- c("--- ALL ---" = "", provNames)
  }
  shiny::updateSelectizeInput(session, inputId = "province", choices = ch, selected = NULL)
})




# Assignment of territory variables when pressing action button
shiny::observe( {
  if(input$region == "" && input$province == "") {
    t$name <- input$country
    t$data <- expression(countryTS)
    t$c <- TRUE
    t$r <- FALSE
    t$p <- FALSE
  } else if(input$province != "") {
    t$name <- input$province
    t$data <- expression(provTS)
    t$c <- FALSE
    t$r <- FALSE
    t$p <- TRUE
  } else {
    t$name <- input$region
    t$data <- expression(regionTS)
    t$c <- FALSE
    t$r <- TRUE
    t$p <- FALSE
  }
  
  reac_general$sugg_dates = suggest_dates()
  
  shiny::updateSliderInput(session,"arima_interval",min = init_date, max = fin_date, timeFormat = "%d %b",
                           step = 1, value = c(reac_general$sugg_dates[1], reac_general$sugg_dates[2]))
   shiny::updateSliderInput(session, "fitInterval",min = init_date, max = fin_date, timeFormat = "%d %b",
                            step = 1, value = c(reac_general$sugg_dates[1],reac_general$sugg_dates[2]))
   shiny::updateSliderInput(session,"FFT_interval",min = init_date, max = fin_date, timeFormat = "%d %b",
                            step = 1, value = c(reac_general$sugg_dates[1], reac_general$sugg_dates[2]))
  
})



## REGION plot (currently date against total cases) ##

output$dates_sugg <- shiny::renderUI({
  
  wait <- waitLoading()
  if( is_ready(reac_general$sugg_dates[1]) ) {
    h4(paste("Suggested initial and final date: ", reac_general$sugg_dates[1],"  -  ", reac_general$sugg_dates[2]))
  }
})


shiny::observe({
  
  wait <- waitLoading()
  
  reac_general$sample_date <- eval(t$data)[[t$name]]$data
  reac_general$sample_cases <- covid19:::level_and_fill(eval(t$data)[[t$name]]$totale_casi, direction = input$direction_fill, method = input$method_fill)
})


output$coolplot1 <- plotly::renderPlotly({
  
  wait <- waitLoading()
  #waiter::waiter_show(id = "coolplot1", html = waiter::spin_loaders(id = 1, color = "#ff471a"), color = "white")
  # Data trim and curve fitting #
  
  if(is_ready(reac_general$sample_cases)) {
  n <- nrow(eval(t$data)[[t$name]])
  logic_interval <- reac_general$sample_date >= input$fitInterval[1] &
    reac_general$sample_date <= input$fitInterval[2]
  
  sample_serial_date <- eval(t$data)[[t$name]]$data_seriale
  
  sample_cases <- reac_general$sample_cases
  sample_diff <-  c(NA,diff(sample_cases))
  
  if( !t$p && input$swab_std ) {
    swabs <- covid19:::level_and_fill(eval(t$data)[[t$name]]$tamponi, direction = input$direction_fill, method = input$method_fill)
    sample_cases <- sample_cases / swabs
    sample_diff <-  c(NA,sample_diff[-1] / diff(swabs))
  }
  
  
  sample_serial_date_trim <- sample_serial_date[logic_interval]
  sample_cases_trim <- sample_cases[logic_interval]
  sample_diff_trim <- sample_diff[logic_interval]
  
  sample_serial_date_rem <- sample_serial_date[!logic_interval]
  sample_cases_rem <- sample_cases[!logic_interval]
  sample_diff_rem <- sample_diff[!logic_interval]
  
  fit_data <- covid19:::exe_fit(sample_cases = sample_cases_trim,
                      sample_date = sample_serial_date_trim,
                      days = days)
  
  reac_logistic$model <- fit_data$out_fit$model
  reac_logistic$resid <- fit_data$out_resid
  reac_logistic$vals <- fit_data$out_fit$vals
  
  conf <- nlstools::confint2(level = 0.95, object = reac_logistic$model)
  
  yConf_up <- (conf["n0",2]*conf["k",2])/(conf["n0",2] + (conf["k",2]-conf["n0",2]) * exp(-conf["r",2]*(sample_serial_date_trim-sample_serial_date_trim[1]))) + sample_cases_trim[1]
  yConf_down <- (conf["n0",1]*conf["k",1])/(conf["n0",1] + (conf["k",1]-conf["n0",1]) * exp(-conf["r",1]*(sample_serial_date_trim-sample_serial_date_trim[1]))) + sample_cases_trim[1]
  
  
  
  # Conversion to real date and creation of fitted points #
  points_trim <- data.frame("sample_serial_date_trim" = reac_general$sample_date[logic_interval],
                            sample_cases_trim)
  points_rem <- data.frame("sample_serial_date_rem" = reac_general$sample_date[!logic_interval],
                           sample_cases_rem)
  points_diff_trim <- data.frame("sample_serial_date_trim" = reac_general$sample_date[logic_interval],
                                 sample_diff_trim)
  points_diff_rem <- data.frame("sample_serial_date_rem" = reac_general$sample_date[!logic_interval],
                                sample_diff_rem)
  
  fittedPoints <- fit_data$fittedPoints
  fittedPoints_der <- fit_data$fittedPoints_der
  seq_dates <- seq(from = init_date, by = 1, length.out = length(days))
  fittedPoints$days <- seq_dates
  fittedPoints_der$days <- seq_dates
  
  confPoints_up <- data.frame("sample_serial_date_trim" = reac_general$sample_date[logic_interval],
                              yConf_up)
  confPoints_down <- data.frame("sample_serial_date_trim" = reac_general$sample_date[logic_interval],
                                yConf_down)
  
  # PLOT with plotly #
  fig = plotly::plot_ly( name = "Cases", type= "scatter")
  
  # funtions for the two different plots
  plot1  = function(fig)
  {
    
    fig <- fig %>% plotly::add_trace(data = confPoints_down, x = ~sample_serial_date_trim, y = ~yConf_down, mode='none',hoverinfo='skip',fill = 'tozeroy', name="IGNORED_LEGEND", fillcolor="rgba(0,0,0,0)",showlegend = FALSE)
    
    fig <- fig %>% plotly::add_trace(data = confPoints_up, x = ~sample_serial_date_trim, y = ~yConf_up, mode='none', fill = 'tonexty' ,name="Confidence interval 95%", fillcolor="rgb(255,250,205)")
    
    hovlabels <- c("")
    for(i in c(1:n)) {
      hovlabels[i] <- paste(format(reac_general$sample_date[i], "%d %b"),
                            ", Tot cases = ", sample_cases[i], sep ="")
      if( !t$p && input$swab_std )
        hovlabels[i] <- paste(hovlabels[i], ", Tot swabs = ", swabs[i], sep = "")
    }
    
    fig <- fig %>% plotly::add_trace(data =  points_rem, x =~sample_serial_date_rem, y =~sample_cases_rem ,marker = list(color = "red"), mode = 'markers', name = "Total cases (excluded)",
                                     text = hovlabels[!logic_interval], hoverinfo = 'text')
    fig <- fig %>% plotly::add_trace(data = points_trim, x =~sample_serial_date_trim, y =~sample_cases_trim ,marker = list(color = "green"), mode = 'markers', name = "Total cases (fitting)",
                                     text = hovlabels[logic_interval], hoverinfo = 'text')
    fig <- fig %>% plotly::add_trace(data = fittedPoints, x = ~days, y = ~yFitted, line = list(color ='rgb(0,0,139)',width=2.5), mode='lines', name = "Fitted logistic curve" )
    
    return(fig)
  }
  
  plot2 = function (fig)
  {
    hovlabels <- c("")
    for(i in c(2:n)) {
      hovlabels[i] <- paste(format(reac_general$sample_date[i], "%d %b"),
                            ", Cases = ", 
                            sample_cases[i] - sample_cases[i-1], 
                            sep ="")
      if( !t$p && input$swab_std )
        hovlabels[i] <- paste(hovlabels[i], ", Swabs = ", swabs[i]-swabs[i-1], sep = "")
    }
    
    fig <- fig %>% plotly::add_bars(data =  points_diff_rem, x =~sample_serial_date_rem, y =~sample_diff_rem, marker = list(color = "red"), name = "New cases (excluded)",
                                    text = hovlabels[!logic_interval], hoverinfo = 'text')
    fig <- fig %>% plotly::add_bars(data =  points_diff_trim, x =~sample_serial_date_trim, y =~sample_diff_trim, marker = list(color = "green"), name = "New cases (fitting)",
                                    text = hovlabels[logic_interval], hoverinfo = 'text')
    fig <- fig %>% plotly::add_trace(data = fittedPoints_der, x = ~days, y = ~yFitted_der, line = list(color ='rgb(255,117,20)',width=2.5), mode='lines', name= "Fitted logistic distribution")
    
    
    return(fig)
  }
  
  #Plot based on the checkbox
  if( 1 %in% input$plot_type && !(2 %in% input$plot_type ) )
  {
    fig = plot1(fig)
  } else if( 2 %in% input$plot_type && !(1 %in% input$plot_type ) )
  {
    fig = plot2(fig)
  } else if( 1 %in% input$plot_type && (2 %in% input$plot_type ) )
  {
    fig = plot1(fig)
    fig = plot2(fig)
  }
  
  # labels and plot
  fig <- fig %>%plotly::layout(xaxis = list(title = "day"), yaxis = list(title = "Infected"))
  if( reac_logistic$vals$k > 1e7 )
    fig <- fig %>%plotly::layout(title = "Warning: unrealistic model estimated", font = list(color = 'red'),dtick= 5 )
  fig
  
  }
})

#-- Summary of regions ---
output$fit_smry <- shiny::renderPrint({
  wait <- waitLoading()
  summary(reac_logistic$model)
})

output$selected_terr <- shiny::renderPrint({
})

selected_info_func <- function() {
  if(is_ready(t$name))
  {
    div(h2(strong(paste("Selected territory:", t$name))), align = "center", style = "color:red")
  }
}

output$selected_info1 <- shiny::renderUI({
  selected_info_func()
})

output$selected_info2 <- shiny::renderUI({
  selected_info_func()
})

output$selected_info3 <- shiny::renderUI({
  selected_info_func()
})

output$selected_info4 <- shiny::renderUI({
  selected_info_func()
})

output$selected_info5 <- shiny::renderUI({
  if(is_ready(reac_SEIR$name) && is_ready(reac_SEIR$notAvail))
  {
    if(reac_SEIR$notAvail) {
      fluidPage(
        div(h2(strong(paste("Selected territory:", reac_SEIR$name))), align = "center", style = "color:red"),
        div(h5(em(paste("Data for SEIR not available at province level"))), align = "center", style = "color:red")
      )
    } else {
      div(h2(strong(paste("Selected territory:", reac_SEIR$name))), align = "center", style = "color:red")
    }
  }
})

output$resid_smry <- shiny::renderPrint({
  wait <- waitLoading()
  print("Data: residuals from nls regression")
  nlstools::test.nlsResiduals(reac_logistic$resid)
})


#-- Residuals ---

output$plot_residual <- plotly::renderPlotly({
  wait <- waitLoading()
  
  Res_DF_1<-as.data.frame(reac_logistic$resid$resi1)
  Res_DF_2<-as.data.frame(reac_logistic$resid$resi2)
  Res_DF_3<-as.data.frame(reac_logistic$resid$resi4)
  Res_DF_4<-as.data.frame(reac_logistic$resid$resi3)
  
  p = plotly::plot_ly(type = 'scatter')
  
  p <- p %>% plotly::layout(
    xaxis = list(
      showline = FALSE,
      dtick = 2000,
      zeroline = FALSE
      
    ),
    
    yaxis = list(
      showline = FALSE,
      zeroline = FALSE
      
    )
  )
  
  if( is_ready(input$plot_res_type) ) {
    if(input$plot_res_type=="Residuals"){
      colnames(Res_DF_1)=c("fitted1","res")
      
      p <- p %>% plotly::layout(
        title ="Residuals",
        xaxis = list(title="Fitted values",zeroline = FALSE),
        yaxis = list(title="Residuals")
      )
      p= p %>%plotly::add_trace(name = "residual",showlegend=FALSE,data=Res_DF_1,x=~Res_DF_1$fitted1,y=~Res_DF_1$res,marker = list(size = 15,
                                                                                                                  color = 'rgba(255, 182, 193, .9)',
                                                                                                                  line = list(color = 'rgba(152, 0, 0, .8)',
                                                                                                                              width = 2)))
      p <- p %>%plotly::add_trace(data=Res_DF_2,x=~Res_DF_1$fitted1,y = 0, name = "liney0", line = list(color = 'rgb(0,0,0)', width = 1, dash = 'dot'),showlegend = FALSE, mode = 'lines')
      
      p
      #grafico1
      
    }
    
    else if(input$plot_res_type=="Residuals_standardized"){
      colnames(Res_DF_2)=c("fitted2","res_stand")
      p <- p %>% plotly::layout(
        title ="Residuals standardized",
        xaxis = list(title="Fitted values"),
        yaxis = list(title="Standardized residuals")
      )
      p <- p %>%plotly::add_trace(name="Standardised residuals",showlegend=FALSE,data=Res_DF_2,x=~Res_DF_2$fitted2,y=~Res_DF_2$res_stand,marker = list(size = 15,
                                                                                                                                      color = 'rgba(255, 182, 193, .9)',
                                                                                                                                      line = list(color = 'rgba(152, 0, 0, .8)',
                                                                                                                                                  width = 2)))
      p <- p %>%plotly::add_trace(data=Res_DF_2,x=~Res_DF_2$fitted2,y = 0, name = "liney0", line = list(color = 'rgb(0,0,0)', width = 1, dash = 'dot'),showlegend = FALSE, mode = 'lines')
      p <- p %>%plotly::add_trace(data=Res_DF_2,x=~Res_DF_2$fitted2,y = 2, name = 'liney2', line = list(color = 'rgb(0,0,0)', width = 1),showlegend = FALSE ,mode = 'lines')
      
      
      p
    }
    
    else if(input$plot_res_type=="Autocorrelation"){
      colnames(Res_DF_3)=c("fitted3","resiplus1")
      p <- p %>% plotly::layout(
        xaxis = list(title="Residuals i"),
        yaxis = list(title="Residuals i+1"),
        title ="Autocorrelation")
      p = p %>%plotly::add_trace(name = "Autocorrelation", showlegend=FALSE,data=Res_DF_3,x=~Res_DF_3$fitted3,y=~Res_DF_3$resiplus1,marker = list(size = 15,
                                                                                                                                 color = 'rgba(255, 182, 193, .9)',
                                                                                                                                 line = list(color = 'rgba(152, 0, 0, .8)',
                                                                                                                                             width = 2)))
      p <- p %>%plotly::add_trace(data=Res_DF_3,x=~Res_DF_3$fitted3,y = 0, name = "liney0", line = list(color = 'rgb(0,0,0)', width = 1, dash = 'dot'),showlegend = FALSE, mode="lines")
      
      p
      #grafico1
      
    }
    
    else if(input$plot_res_type=="Sqrt of abs of res vs fitted"){
      p <- p %>% plotly::layout(
        title ="Sqrt of abs of residual",
        xaxis = list(title="Fitted"),
        yaxis = list(title="Residuals")
      )
      colnames(Res_DF_4)=c("fitted4","qq")
      p = p %>%plotly::add_trace(name="Sqrt of abs of res vs fitted",showlegend=FALSE,data=Res_DF_4,x=~Res_DF_4$fitted4,y=~Res_DF_4$qq,marker = list(size = 15,
                                                                                                                                    color = 'rgba(255, 182, 193, .9)',
                                                                                                                                    line = list(color = 'rgba(152, 0, 0, .8)',
                                                                                                                                                width = 2)))
      p
      #grafico1
    }
  }
})



##===================================== ARIMA SECTION =============================================##

  

## HERE GOES ALL ARIMA IMPLEMENTATION COMMON TO ALL GRAPHS
shiny::observe({
  wait <- waitLoading()
  
  if(is_ready(input$arima_interval[1]) && is_ready(reac_general$sample_cases)) {
    reac_ARIMA$logic_interval <- reac_general$sample_date >=  input$arima_interval[1]  &
      reac_general$sample_date <= input$arima_interval[2] 
    
    reac_ARIMA$sample_date_trim <- reac_general$sample_date[reac_ARIMA$logic_interval]
    reac_ARIMA$sample_cases_trim <- reac_general$sample_cases[reac_ARIMA$logic_interval]+1
    
    reac_ARIMA$sugg_lags <- suggest_lags()
    updateSliderInput(session,"ARIMA_p", value=  reac_ARIMA$sugg_lags[1])
    updateSliderInput(session,"ARIMA_I", value =  reac_ARIMA$sugg_lags[2])
    updateSliderInput(session,"ARIMA_q", value =  reac_ARIMA$sugg_lags[3])
  }
  
})

shiny::observe({
  wait <- waitLoading()
  
  if(is_ready(input$ARIMA_p)) {
    
    reac_ARIMA$arima <- checkExp(  stats::arima(log(reac_ARIMA$sample_cases_trim),order=c(input$ARIMA_p,input$ARIMA_I,input$ARIMA_q)) , "There is not a suitable ARIMA model")
    reac_ARIMA$arimaOK <- TRUE
  }
  
})


#Ln x = Log10 x / Log10 e


## Plot of ARIMA Time Series and FORECAST
output$arima_coolplot1 <- plotly::renderPlotly({
  
  wait <- waitLoading()
  #acf(log(sample_cases_trim))
  #pacf(log(sample_cases_trim))
  if( reac_ARIMA$arimaOK ) {
    
    
    fore = checkExp(forecast::forecast(reac_ARIMA$arima,input$forecast) , "There is not a forecast for the ARIMA model")
    
    sdt <- reac_ARIMA$sample_date_trim
    
    fore.dates <- seq(from = sdt[length(sdt)], by = 1, len = input$forecast)
    
    p <-plotly::plot_ly() %>%
      plotly::add_ribbons(x = fore.dates,
                          ymin = exp(fore$mean),
                          ymax = exp(fore$upper[, 2]),
                          color = I("#17becf"),
                          name = "95% confidence") %>%
      plotly::add_ribbons(p,
                          x = fore.dates,
                          ymin = exp(fore$mean),
                          ymax = exp(fore$upper[, 1]),
                          color = I("#ed9dac"), name = "80% confidence")%>%
      plotly::add_lines(x = sdt, y = reac_ARIMA$sample_cases_trim,
                        color = I("#037d50"),
                        name = "observed",
                        mode="lines")%>%
      plotly::add_lines(x = fore.dates, 
                        y = exp(fore$mean),
                        color = I("#ee1147"), 
                        name = "prediction")
    
    p <- p %>% plotly::layout(
      title = paste0("ARIMA Forecast (",input$ARIMA_p,",",input$ARIMA_I,",",input$ARIMA_q,")"),
      xaxis = list(title="Days"),
      yaxis = list(title="Total cases", type = "log")
    )
    
    p
  }
})


## Plot of autocorrelation function
output$arima_coolplot2 <- plotly::renderPlotly({
  
  wait <- waitLoading()
  if(is_ready(reac_ARIMA$sample_cases_trim)) {
    
    p = checkExp(  forecast::autoplot(acf(log(reac_ARIMA$sample_cases_trim))) , "There is not a forecast for the ARIMA model")
    
    
    p = plotly::ggplotly(p)
    
    p <- p %>%plotly::layout(xaxis = list(title = "LAG"), yaxis = list(title = "ACF"), title="Autocorrelation", showlegend = TRUE, 
                             plot_bgcolor = "rgb(255, 255, 255)")
      
    
  }
  
})

## Plot of partial autocorrelation function
output$arima_coolplot3 <- plotly::renderPlotly({
  
  wait <- waitLoading()
  if(is_ready(reac_ARIMA$sample_cases_trim)) {
    
    
    p = checkExp( forecast::autoplot(pacf(log(reac_ARIMA$sample_cases_trim)) ) , "There is not a forecast for the ARIMA model")
    p = plotly::ggplotly(p)
    
    p <- p %>%plotly::layout(xaxis = list(title = "LAG"), yaxis = list(title = "PACF"), title="Partial Autocorrelation", showlegend = TRUE, 
                             plot_bgcolor = "rgb(255, 255, 255)")
 
  }
  
})


## Plot of ARIMA residuals
output$arima_coolplot4 <- shiny::renderPlot({
  
  wait <- waitLoading()
  if(reac_ARIMA$arimaOK) {
    checkExp(forecast::checkresiduals(reac_ARIMA$arima) , "There is not a suitable ARIMA model")
  }
  
})


# --- Summary ARIMA

## Print of suggested parameters
output$parameters_sugg <- shiny::renderUI({
  
  wait <- waitLoading()
  if( is_ready(reac_ARIMA$sugg_lags[1]) ) {
    fluidPage(
      fluidRow(
        h3( paste("Suggested Parameters: ARIMA(", paste(reac_ARIMA$sugg_lags, collapse = ","), ")") )
      ),
      fluidRow(
        h4(paste("Suggested initial and final date: ", reac_general$sugg_dates[1]," - ", reac_general$sugg_dates[2]))
      )
    )
  }
})

# toString(reac_ARIMA$arima$coef)
# suggested fit toString(forecast::auto.arima(log(sample_cases_trim)))
#reac_ARIMA$arima$coef
# reac_ARIMA$arima$sigma2

output$arima_shell_output <- shiny::renderPrint({
  
  wait <- waitLoading()
  if(reac_ARIMA$arimaOK) {
    reac_ARIMA$arima
  }
  
})

output$arima_shell_resid <- shiny::renderPrint({
  
  wait <- waitLoading()
  if(reac_ARIMA$arimaOK) {
   
   checkExp(forecast::checkresiduals(reac_ARIMA$arima,plot=FALSE), "There is not a suitable ARIMA model")
    
  }
  
})



#============ FFT ======================================

shiny::observe({
  wait <- waitLoading()
  
  if(is_ready(reac_general$sample_cases)) {
    reac_FFT$logic_interval <- reac_general$sample_date >=  input$FFT_interval[1]  &
      reac_general$sample_date <= input$FFT_interval[2] 
    
    reac_FFT$sample_date_trim <- reac_general$sample_date[reac_FFT$logic_interval]
    reac_FFT$sample_cases_trim <- reac_general$sample_cases[reac_FFT$logic_interval]+1
  }
})


output$FFT_day_cases<- shiny::renderPlot({
  
  if(is_ready(reac_FFT$sample_cases_trim)) {
    FFTX<-spectral::spec.fft(diff(reac_FFT$sample_cases_trim))
    plot(FFTX,type = "l",ylab = "Amplitude",xlab = "Frequency",lwd = 2)
  }
})

output$FFT_day_cases_diff<- shiny::renderPlot({
  
  if(is_ready(reac_FFT$sample_cases_trim)) {
    FFTX<-spectral::spec.fft(diff(diff(reac_FFT$sample_cases_trim)))
    plot(FFTX,type = "l",ylab = "Amplitude",xlab = "Frequency",lwd = 2)
  }
})

#======================= R(T) ==================================

#DEFAULT 1.4, 0.8
#
#
#shiny::observe({
#  
#  if(is_ready(reac_general$sample_cases) && is_ready(input$"Gamma_1")) {
#    
#    GT.chld.hsld2<-R0::generation.time("gamma", c(input$"Gamma_1", input$"Gamma_2"))
#    time_R <- as.numeric(length(reac_general$sample_cases))-2
#    
#    tryCatch(
#      {
#        reac_R$R0_data <- R0::est.R0.TD(diff(reac_general$sample_cases),GT.chld.hsld2, begin=1, end=time_R)
#      },
#      error = function(e)
#      {
#        reac_R$R0_data <- FALSE
#      }
#    )
#  }
#})
#
#R0_data <- shiny::reactive({
#
#  shiny::validate(
#    shiny::need(is_ready(reac_R$R0_data), "Wait...") %then%
#    shiny::need(!isFALSE(reac_R$R0_data), "The estimates cannot be calculated")
#  )
#  return(reac_R$R0_data)
#})
#
#
#
#output$R_t_evaluation<- shiny::renderPlot({
#
#    plot( R0_data())
#  
#})
#
#output$R_t_goodness_of_fit<- shiny::renderPlot({
#
#    R0::plotfit(R0_data())
# 
#})
#
#output$R_t_evaluation_FFT<- shiny::renderPlot({
#
#    R0_data_raw_FFT <- spectral::spec.fft(R0_data()[["R"]])
#    plot(R0_data_raw_FFT,type = "l",ylab = "Amplitude",xlab = "Frequency",lwd = 2)
#
#})



#======================= SEIR MODEL ==================================
# 
# 
# #---- data retrieval, common to both
# 
# distr_IT <- 'exp'
# distr_SRT <- 'exp'
# distr_IBST <- 'none'
# 
# shiny::observe({
#   
#   wait <- waitLoading()
# 
#   # territory selection for SEIR
#   if(t$p) {
#     reac_SEIR$data <- expression(regionTS)
#     reac_SEIR$notAvail <- TRUE
#     reac_SEIR$name <- regAndProv[ regAndProv$province == t$name, "region"]
#   } else {
#     reac_SEIR$data <- t$data
#     reac_SEIR$notAvail <- FALSE
#     reac_SEIR$name <- t$name
#   }
#   
#   # N =  population of area
#   if(t$c) {
#     reac_SEIR$N <- italy_pop$country[1,"valore"]
#   } else {
#     reac_SEIR$N <- italy_pop$region[italy_pop$region$territorio == reac_SEIR$name, "valore"]
#   }
#   
#   ## Time series
#   # Infected Time Series
#   reac_SEIR$P <- level_and_fill(eval(reac_SEIR$data)[[reac_SEIR$name]]$totale_casi, direction = input$direction_fill, method = input$method_fill)
#   
#   # Removed Time Series (recovered + dead)
#   reac_SEIR$R <- level_and_fill(eval(reac_SEIR$data)[[reac_SEIR$name]]$dimessi_guariti, direction = input$direction_fill, method = input$method_fill) +
#     level_and_fill(eval(reac_SEIR$data)[[reac_SEIR$name]]$deceduti, direction = input$direction_fill, method = input$method_fill)
#   
#   
#   reac_SEIR$par_IT <- list('rate'=1/input$rate_IT)
#   reac_SEIR$par_SRT <- list('rate'=1/input$rate_SRT)
#   reac_SEIR$par_IBST <- NULL
#   
#   reac_SEIR$IT <- covid19::generate(distr_IT, reac_SEIR$par_IT)
#   reac_SEIR$SRT <- covid19::generate(distr_SRT, reac_SEIR$par_SRT)
#   reac_SEIR$IBST <- covid19::generate(distr_IBST, reac_SEIR$par_IBST)
#   
#   reac_SEIR$m <- max(length(reac_SEIR$IT), length(reac_SEIR$SRT), length(reac_SEIR$IBST))
#   reac_SEIR$end <- length(reac_SEIR$P) #Rt goes from day 1 to day n_obs-m BUT also the SEIR data series will go from day 1 to that day after refinement
#   reac_SEIR$len <- reac_SEIR$end - reac_SEIR$m
# })
# 
# 
# #---- R0 part
#
# shiny::observeEvent(input$est_R0, {
# 
#   out <- SEIR_factotum(P = reac_SEIR$P, R = reac_SEIR$R, N = reac_SEIR$N,
#                        end=reac_SEIR$end, future=input$future,
#                        distr_IT=distr_IT, distr_SRT=distr_SRT, distr_IBST=distr_IBST,
#                        par_IT=reac_SEIR$par_IT, par_SRT=reac_SEIR$par_SRT, par_IBST=reac_SEIR$par_IBST,
#                        R0_exp_est_end=input$R0_exp_est_end,
#                        plot_data=input$plot_data)
# 
#   reac_SEIR$R0 <- out$R0
# 
#   S_ <- reac_SEIR$N*out$S_ 
#   E_ <- reac_SEIR$N*out$E_ 
#   I_ <- reac_SEIR$N*out$I_ 
#   R_ <- reac_SEIR$N*out$R_
#   S <- reac_SEIR$N*out$S 
#   E <- reac_SEIR$N*out$E 
#   I <- reac_SEIR$N*out$I
#   R <- reac_SEIR$N*out$R
# 
#   reac_SEIR$U <- data.frame(date = seq(from = init_date, by = 1, length.out = reac_SEIR$len), 'S'=S, 'E'=E, 'I'=I, 'R'=R)
#   reac_SEIR$U_ <- data.frame(date = seq(from = init_date, by = 1, length.out = reac_SEIR$len), 'S_'=S_, 'E_'=E_, 'I_'=I_, 'R_'=R_)
# 
#   reac_SEIR$current <- "R0"
# 
# })
# 
# 
# shiny::observeEvent(input$est_Rt, {
# 
# 
#   # REFERS TO INPUT IN PRECEDENT TAB
# 
#   GT<-R0::generation.time("gamma", c(input$"Gamma_1", input$"Gamma_2"))
#   R0_out <- R0::est.R0.TD(diff(reac_SEIR$P),GT,begin=1, end=as.numeric(reac_SEIR$len))
#   Rt <- R0_out$R
#   R0_stages <- (1:(length(Rt)-1))
# 
#   out <- SEIR_factotum(P = reac_SEIR$P, R = reac_SEIR$R, N = reac_SEIR$N,
#                        end=reac_SEIR$end, future=input$future,
#                        distr_IT=distr_IT, distr_SRT=distr_SRT, distr_IBST=distr_IBST,
#                        par_IT=reac_SEIR$par_IT, par_SRT=reac_SEIR$par_SRT, par_IBST=reac_SEIR$par_IBST,
#                        R0_msp=Rt, R0_stages=R0_stages,
#                        plot_data=input$plot_data)
# 
#   S_ <- reac_SEIR$N*out$S_ 
#   E_ <- reac_SEIR$N*out$E_ 
#   I_ <- reac_SEIR$N*out$I_ 
#   R_ <- reac_SEIR$N*out$R_
#   S <- reac_SEIR$N*out$S 
#   E <- reac_SEIR$N*out$E 
#   I <- reac_SEIR$N*out$I
#   R <- reac_SEIR$N*out$R
# 
#   reac_SEIR$U <- data.frame(date = seq(from = init_date, by = 1, length.out = reac_SEIR$len), 'S'=S, 'E'=E, 'I'=I, 'R'=R)
#   reac_SEIR$U_ <- data.frame(date = seq(from = init_date, by = 1, length.out = reac_SEIR$len), 'S_'=S_, 'E_'=E_, 'I_'=I_, 'R_'=R_)
# 
#   reac_SEIR$current <- "R(t)"
# 
# })
# 
# 
# shiny::observe({
#   if(is_ready(reac_SEIR$U_) ) {
#     reac_SEIR$SEIR_plot <- highcharter::hchart(tidyr::gather((reac_SEIR$U_), key="key", value="value", -date), 
#                                                highcharter::hcaes(x = date, y = value, group = key), 
#                                                type = "line",
#                                                color = c("#bf40bf", "#e60000", "#00b300", "#fec501"),
#                                                name = c("Exposed", "Infectious", "Recovered", "Susceptible"),
#                                                marker = list(enabled = FALSE),
#                                                legendIndex = c(2,3,4,1),
#                                                tooltip = list(valueDecimals = 0)
#     ) %>%
#       highcharter::hc_add_series(tidyr::gather((reac_SEIR$U), key="key", value="value", -date), 
#                                  highcharter::hcaes(x = date, y = value, group = key), 
#                                  type = "scatter",
#                                  name = c("Exposed (true)", "Infectious (true)", "Recovered (true)", "Susceptible (true)"),
#                                  color = c("#bf40bf", "#e60000", "#00b300", "#fec501"),
#                                  legendIndex = c(2,3,4,1),
#                                  tooltip = list(valueDecimals = 0, 
#                                                 pointFormat = '<span style="color:{point.color}">■</span> {series.name}: <b>{point.y}</b><br/>',
#                                                 headerFormat = '<span style="font-size: 10px">{point.key}</span><br/>')
#       ) %>%
#       highcharter::hc_title(text = paste("SEIR based on", reac_SEIR$current))
#   }
# })
# 
# 
# output$SEIR_R0 <- renderPrint({
#   if(is_ready(reac_SEIR$R0)) {
#     print(reac_SEIR$R0)
#   }
# })
# 
# output$SEIR_plot <- highcharter::renderHighchart(
#   reac_SEIR$SEIR_plot
# )
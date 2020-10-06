# ====== GENERAL INFO ==== 
#Dataset and plot reactive
reac_dataset <- shiny::reactiveValues()
reac_delay <- shiny::reactiveValues()
reac_test <- shiny::reactiveValues()

disc_NAfind <- function(v) {
  n <- length(v)
  if(n > 0) {
    i <- 1
    while(is.na(v[i]) && i <= n) {
      i <- i+1
    }
    while(i <= n) {
      if(is.na(v[i]))
        return(TRUE)
      else
        i <- i+1
    }
  }
  return(FALSE)
}

shiny::observe({
  if(input$geninfo_reg != "default") {
    ch <- c("--- ALL ---" = "default", regAndProv[regAndProv$region == input$geninfo_reg, "province"])
  } else {
    ch <- c("--- ALL ---" = "default", provNames)
  }
  shiny::updateSelectizeInput(session, inputId = "geninfo_prov", choices = ch, selected = NULL)
})




output$decree_tl <- highcharter::renderHighchart(
  highcharter::highchart() %>%
    highcharter::hc_xAxis(type = "datetime") %>%
    highcharter::hc_add_series(data = decrees, type = "timeline", showInLegend = FALSE,
                               dataLabels = list(allowOverlap = FALSE,
                                                 format = '<span style="color:{point.color}">* </span><span style="font-weight: bold;" > {point.x:%d %b %Y}</span><br/>{point.label}'),
                               marker = list(symbol = "circle"),
                               allowPointSelect = TRUE,
                               useHTML = TRUE
    ) %>%
    highcharter::hc_chart(zoomType = "x") %>%
    highcharter::hc_yAxis(gridLineWidth = 1, title = NULL, labels = list(enabled = FALSE), visible = FALSE) %>%
    highcharter::hc_legend(enabled = FALSE) %>%
    highcharter::hc_title(text = "Timeline of Ministerial Decrees concerning COVID-19") %>%
    highcharter::hc_subtitle(text = "Click on events to show official documents") %>%
    highcharter::hc_tooltip(style = list(width = 300)) %>%
    highcharter::hc_plotOptions(series = list(cursor = "pointer", 
                                              point = list(
                                                events = list(click = highcharter::JS("function () {
                                                                window.open(this.options.link,'_blank');
                                                                                        win.focus();
                                                                                      }"
                                                )))))
)



# General info reactive dataset
shiny::observe({

  shiny::validate(
    shiny::need(is_ready(input$geninfo_reg), "Wait...")
  )
  
  # UPDATE RADIO BUTTONS if province or region/country
  if(input$geninfo_prov != "default" ) {
    
    inpt = input$geninfo_type
    if(inpt == "cur")
    {
      inpt = "tot"
    }
    updateRadioButtons(session, inputId = "geninfo_type",selected =inpt, choiceValues = c("tot","new"),   choiceNames = list(HTML("<p><strong><span style='background-color: rgb(0, 0, 0); color: rgb(255, 255, 255);'>Total</span></strong> (cumulative)</p>"),
                                                                                                                               HTML("<p><span style='background-color: rgb(184, 49, 47); color: rgb(255, 255, 255);'><strong>New</strong></span> (daily)</p>")))
  }
  
  else if (input$geninfo_prov == "default" )
  {
    updateRadioButtons(session, inputId = "geninfo_type",choiceValues = c("tot","new","cur"), choiceNames = list(HTML("<p><strong><span style='background-color: rgb(0, 0, 0); color: rgb(255, 255, 255);'>Total</span></strong> (cumulative)</p>"),
                                                                                                                 HTML("<p><span style='background-color: rgb(184, 49, 47); color: rgb(255, 255, 255);'><strong>New</strong></span> (daily)</p>"),
                                                                                                                 HTML("<p><span style='background-color: rgb(255, 204, 0); color: rgb(255, 255, 255);'><strong>Current</strong></span></p>")
    ), selected = input$geninfo_type)
                                                                                                                               
  }
  

  # Switch over territory input
  if(input$geninfo_reg == "default" && input$geninfo_prov == "default") {
    reac_dataset$name <- input$geninfo_coun
    reac_dataset$data <- expression(countryTS)
  } else if(input$geninfo_reg != "default" &&  input$geninfo_prov == "default") {
    reac_dataset$name <-  input$geninfo_reg
    reac_dataset$data <- expression(regionTS)
  } else {
    reac_dataset$name <- input$geninfo_prov
    reac_dataset$data <- expression(provTS)
  }
    
  
  #Switch over data type
  if(input$geninfo_type == "tot") {
    reac_dataset$plot_type = "spline"
    reac_dataset$plotOptions_column = list()
    reac_dataset$yAxis = 1
    reac_dataset$headerCol <- DT::JS("function(settings, json) {", "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});", "}")
    
    if(input$geninfo_prov == "default") {
      reac_dataset$table_plot <- eval(reac_dataset$data)[[reac_dataset$name]] %>%
        dplyr::select("Date" = data, "Tot. cases" = totale_casi, "Tot. deaths" = deceduti, "Tot. recoveries" = dimessi_guariti)
      reac_dataset$colors <- c("blue", "black", "green")
      # maxima labels
      reac_dataset$annotations_labels <- list(
        list(point = list(x = UTSdate(reac_dataset$table_plot[ which.max(c(NA,diff(reac_dataset$table_plot[,"Tot. cases"]))) , "Date" ]),
                          y = reac_dataset$table_plot[ which.max(c(NA,diff(reac_dataset$table_plot[,"Tot. cases"]))) , "Tot. cases" ], xAxis = 0, yAxis = reac_dataset$yAxis),
             text = 'Inflection: <strong>{y}</strong><br/>{x:%d %b %Y}',
             backgroundColor = 'rgba(63, 63, 191, 0.4)'),
        list(point = list(x = UTSdate(reac_dataset$table_plot[ which.max(c(NA,diff(reac_dataset$table_plot[,"Tot. deaths"]))) , "Date" ]),
                          y = reac_dataset$table_plot[ which.max(c(NA,diff(reac_dataset$table_plot[,"Tot. deaths"]))) , "Tot. deaths" ], xAxis = 0, yAxis = reac_dataset$yAxis),
             text = 'Inflection: <strong>{y}</strong><br/>{x:%d %b %Y}',
             backgroundColor = 'rgba(0, 0, 0, 0.4)'),
        list(point = list(x = UTSdate(reac_dataset$table_plot[ which.max(c(NA,diff(reac_dataset$table_plot[,"Tot. recoveries"]))) , "Date" ]),
                          y = reac_dataset$table_plot[ which.max(c(NA,diff(reac_dataset$table_plot[,"Tot. recoveries"]))) , "Tot. recoveries" ], xAxis = 0, yAxis = reac_dataset$yAxis),
             text = 'Inflection: <strong>{y}</strong><br/>{x:%d %b %Y}',
             backgroundColor = 'rgba(27, 150, 27, 0.4)')
      )
    } else {
      reac_dataset$table_plot <- eval(reac_dataset$data)[[reac_dataset$name]] %>%
        dplyr::select("Date" = data, "Tot. cases" = totale_casi)
      reac_dataset$colors <- c("blue")
      reac_dataset$annotations_labels <- list(
        list(point = list(x = UTSdate(reac_dataset$table_plot[ which.max(c(NA,diff(reac_dataset$table_plot[,"Tot. cases"]))) , "Date" ]),
                          y = reac_dataset$table_plot[ which.max(c(NA,diff(reac_dataset$table_plot[,"Tot. cases"]))) , "Tot. cases" ], xAxis = 0, yAxis = reac_dataset$yAxis),
             text = 'Inflection: <strong>{y}</strong><br/>{x:%d %b %Y}',
             backgroundColor = 'rgba(63, 63, 191, 0.4)')
      )
    }
    
    
  } else if(input$geninfo_type == "new") {
    reac_dataset$plot_type = "column"
    reac_dataset$plotOptions_column <- list(groupPadding = 0.1, pointPadding = 0)
    reac_dataset$yAxis = 0
    reac_dataset$headerCol <- DT::JS("function(settings, json) {", "$(this.api().table().header()).css({'background-color': '#e62e00', 'color': '#fff'});", "}")
    
    if(input$geninfo_prov == "default") {
      reac_dataset$table_plot <- eval(reac_dataset$data)[[reac_dataset$name]] %>%
        dplyr::mutate("New deaths" = c(NA,diff(deceduti)), "New recoveries" = c(NA,diff(dimessi_guariti)), "New cases" = c(NA,diff(totale_casi))) %>%
        dplyr::select("Date" = data, "New cases", "New deaths", "New recoveries")
      reac_dataset$colors <- c("blue", "black", "green")
      # maxima labels
      reac_dataset$annotations_labels <- list(
        list(point = list(x = UTSdate(reac_dataset$table_plot[ which.max(reac_dataset$table_plot[,"New cases"]) , "Date" ]),
                          y = max(reac_dataset$table_plot[,"New cases"], na.rm = T), xAxis = 0, yAxis = reac_dataset$yAxis),
             text = 'Peak: <strong>{y}</strong><br/>{x:%d %b %Y}',
             backgroundColor = 'rgba(63, 63, 191, 0.4)'),
        list(point = list(x = UTSdate(reac_dataset$table_plot[ which.max(reac_dataset$table_plot[,"New deaths"]) , "Date" ]),
                          y = max(reac_dataset$table_plot[,"New deaths"], na.rm = T), xAxis = 0, yAxis = reac_dataset$yAxis),
             text = 'Peak: <strong>{y}</strong><br/>{x:%d %b %Y}',
             backgroundColor = 'rgba(0, 0, 0, 0.4)'),
        list(point = list(x = UTSdate(reac_dataset$table_plot[ which.max(reac_dataset$table_plot[,"New recoveries"]) , "Date" ]),
                          y = max(reac_dataset$table_plot[,"New recoveries"], na.rm = T), xAxis = 0, yAxis = reac_dataset$yAxis),
             text = 'Peak: <strong>{y}</strong><br/>{x:%d %b %Y}',
             backgroundColor = 'rgba(27, 150, 27, 0.4)')
      )
      reac_dataset$yAxis_max <- max(reac_dataset$table_plot[,"New cases"], na.rm = T)*125/100
      
    } else {
      reac_dataset$table_plot <- eval(reac_dataset$data)[[reac_dataset$name]] %>%
        dplyr::mutate("New cases" = c(NA,diff(totale_casi))) %>%
        dplyr::select("Date" = data, "New cases")
      reac_dataset$colors <- c("blue")
      reac_dataset$annotations_labels <- list(
        list(point = list(x = UTSdate(reac_dataset$table_plot[ which.max(reac_dataset$table_plot[,"New cases"]) , "Date" ]),
                          y = max(reac_dataset$table_plot[,"New cases"], na.rm = T), xAxis = 0, yAxis = reac_dataset$yAxis),
             text = 'Peak: <strong>{y}</strong><br/>{x:%d %b %Y}',
             backgroundColor = 'rgba(63, 63, 191, 0.4)')
      )
    }
    
    
  } else if(input$geninfo_prov == "default" && input$geninfo_type == "cur") {
    reac_dataset$plot_type = "spline"
    reac_dataset$plotOptions_column = list()
    reac_dataset$yAxis = 1
    reac_dataset$headerCol <- DT::JS("function(settings, json) {", "$(this.api().table().header()).css({'background-color': '#ffcc00', 'color': '#fff'});", "}")
    
    reac_dataset$table_plot <- eval(reac_dataset$data)[[reac_dataset$name]] %>%
      dplyr::select("Date" = data, "Current pos. cases" = totale_positivi, "Current hospitalised" = totale_ospedalizzati, "Current intensive care" = terapia_intensiva, "Current home isol." = isolamento_domiciliare)
    reac_dataset$colors <- c("#00bfff", "#00e673", "#ff3300", "#cc66ff")
    reac_dataset$annotations_labels <- list(
      list(point = list(x = UTSdate(reac_dataset$table_plot[ which.max(reac_dataset$table_plot[,"Current pos. cases"]) , "Date" ]),
                        y = max(reac_dataset$table_plot[,"Current pos. cases"], na.rm = T), xAxis = 0, yAxis = reac_dataset$yAxis),
           text = 'Peak: <strong>{y}</strong><br/>{x:%d %b %Y}',
           backgroundColor = 'rgba(204, 102, 255, 0.4)'),
      list(point = list(x = UTSdate(reac_dataset$table_plot[ which.max(reac_dataset$table_plot[,"Current hospitalised"]) , "Date" ]),
                        y = max(reac_dataset$table_plot[,"Current hospitalised"], na.rm = T), xAxis = 0, yAxis = reac_dataset$yAxis),
           text = 'Peak: <strong>{y}</strong><br/>{x:%d %b %Y}',
           backgroundColor = 'rgba(0, 230, 115, 0.4)'),
      list(point = list(x = UTSdate(reac_dataset$table_plot[ which.max(reac_dataset$table_plot[,"Current intensive care"]) , "Date" ]),
                        y = max(reac_dataset$table_plot[,"Current intensive care"], na.rm = T), xAxis = 0, yAxis = reac_dataset$yAxis),
           text = 'Peak: <strong>{y}</strong><br/>{x:%d %b %Y}',
           backgroundColor = 'rgba(255, 51, 0, 0.4)'),
      list(point = list(x = UTSdate(reac_dataset$table_plot[ which.max(reac_dataset$table_plot[,"Current home isol."]) , "Date" ]),
                        y = max(reac_dataset$table_plot[,"Current home isol."], na.rm = T), xAxis = 0, yAxis = reac_dataset$yAxis),
           text = 'Peak: <strong>{y}</strong><br/>{x:%d %b %Y}',
           backgroundColor = 'rgba(0, 191, 255, 0.4)')
    )
  }
    
  
  
  reac_dataset$plot = highcharter::hchart(tidyr::gather((reac_dataset$table_plot), key="key", value="value", -Date),
                                          type = reac_dataset$plot_type, title= "General info",
                                          highcharter::hcaes(x = Date, y = value, group = key),
                                          color=reac_dataset$colors,
                                          yAxis = reac_dataset$yAxis,
                                          showInLegend=TRUE) %>%
    highcharter::hc_xAxis(
      plotBands = list(list(color = "#ffe6e6", from = UTSdate(as.Date("2020-03-09")), to = UTSdate(as.Date("2020-05-04")),
                            label = list(text = "First stage", style = list(color = "#cc0000"))),
                       list(color = "#ffebcc", from = UTSdate(as.Date("2020-05-04")), to = UTSdate(as.Date("2020-06-11")),
                            label = list(text = "Second stage", style = list(color = "#cc7a00"))),
                       list(color = "#ccffcc", from = UTSdate(as.Date("2020-06-11")), to = UTSdate(fin_date),
                            label = list(text = "Third stage", style = list(color = "#009900")))
      ),
      plotLines = list(list(color = "#e60000", value = UTSdate(as.Date("2020-03-09")), width = 4,
                            label = list(text = "Decree of March 9th")),
                       list(color = "#e67300", value = UTSdate(as.Date("2020-05-04")), width = 4,
                            label = list(text = "Decree of April 26th")),
                       list(color = "#00e600", value = UTSdate(as.Date("2020-06-11")), width = 4,
                            label = list(text = "Decree of June 11th"))
      )
    ) %>%
    highcharter::hc_yAxis(
      max = reac_dataset$yAxis_max,
      min = 1
    ) %>%
    highcharter::hc_annotations(list(
      labels = reac_dataset$annotations_labels,
      labelOptions = list(useHTML = T, distance = 15))
      ) %>%
    highcharter::hc_plotOptions(column = reac_dataset$plotOptions_column) %>%
    highcharter::hc_chart(zoomType = "xy") %>%
    highcharter::hc_yAxis_multiples(
        list(lineWidth = 3, title = list(text  =  '')),
        list(showLastLabel = TRUE, opposite = TRUE, title = list(text  =  ''))
      )  %>%
    highcharter::hc_legend(align = "top", verticalAlign = "top",
                           layout = "vertical", x = 30, y = 100, enabled=TRUE) %>%
    highcharter::hc_title(text = paste0("General info for: ",reac_dataset$name),
                            margin = 20, align = "left",
                            style = list(useHTML = TRUE))

})


# General info reactive plot
output$geninfo_plot <- highcharter::renderHighchart(
  reac_dataset$plot
)

output$log_geninfo <- renderPrint(reac_dataset$annotations_labels)


#======= TABLE ====== 

# General info table

output$geninfo_table <- DT::renderDataTable({

  if(is_ready(reac_dataset$table_plot)) {
    newnam <- paste(stringr::str_to_title(input$geninfo_type), "swabs")
    newcol <- switch(input$geninfo_type,
                        "tot" = eval(reac_dataset$data)[[reac_dataset$name]]$tamponi,
                        "new" = c(NA,diff(eval(reac_dataset$data)[[reac_dataset$name]]$tamponi)),
                        "cur" = NULL)
    dt <- reac_dataset$table_plot
    dt[,newnam] <- newcol
    DT::datatable(
      dt,
      caption = paste0("General info for: ",reac_dataset$name),
      options = list(
        searching = FALSE,
        pageLength = 6, lengthMenu = c(6,10,14), scrollX = T,
        initComplete = reac_dataset$headerCol)
    )
  }

})



# age distribution plot ---------------------------------------------------

output$age_plot <- highcharter::renderHighchart(
  highcharter::highchart() %>% 
    # Data
    highcharter::hc_add_series(dplyr::filter(age_df_final,region==input$regiontab3), "column",
                               highcharter::hcaes(x = age_int, y = cases), name = "cases") %>%
    highcharter::hc_add_series(dplyr::filter(age_df_final,region==input$regiontab3), "pie", 
                               highcharter::hcaes(name = age_int, y = perc_cases), name = "% cases") %>%
    # Optiosn for each type of series
    highcharter::hc_plotOptions(
      series = list(
        showInLegend = FALSE,
        pointFormat = "{point.y}%"
      ),
      column = list(
        colorByPoint = TRUE
      ),
      pie = list(
        colorByPoint = TRUE, center = c('15%', '20%'),
        size = 150, dataLabels = list(enabled = FALSE)
      )) %>%
    # Axis
    highcharter::hc_yAxis(
      title = list(text = "cases")
    ) %>%
    highcharter::hc_xAxis(categories = dplyr::filter(age_df_final,region==input$regiontab3)$age_int)
)


# =============== INTENSIVE CARE PLOTS


reac_intensive <- reactive({
  
  reac_intensive = intensivecare_capacity[intensivecare_capacity$data == input$occupancy_date,]
  if(input$tabs== "tab1")
  {
    reac_intensive = reac_intensive[order(reac_intensive$perc,decreasing = TRUE),]
    return(reac_intensive)
    
  }
  else
  {
    reac_intensive = reac_intensive[order(reac_intensive$occupancy,decreasing = TRUE),]
    return(reac_intensive)
    
  }
  
})


# plots
output$intensivecare_cap_perc <- plotly::renderPlotly({
  
  fig <-plotly::plot_ly(type = 'bar', marker = list(color = reac_intensive()$perc, width=3,line = list(color = 'rgb(8,48,107)', width = 1.5)))
  fig <- fig %>%plotly::add_bars(data = reac_intensive(), x =~region , y=~perc, name="percentage",
                                 text = ~perc, textposition = 'auto' )
  fig <- fig %>%plotly::layout(
    title=paste0("Day ",input$occupancy_date," - Percentage Occupancy vs initial intensive care capacity at the start of the pandemic"),
    xaxis = list(title = "Region"),
    yaxis = list(title = "Percentage occupancy/capacity"),
    legend = list(x = 0.1, y = 0.9))
  
  fig
})



output$intensivecare_cap <- plotly::renderPlotly({
  
  
  fig  =plotly::plot_ly(type="bar")
  fig <- fig %>%plotly::add_trace(data = reac_intensive(), name = "capacity",x = ~region, y = ~capacity, type = 'bar',
                                  text = ~capacity, textposition = 'auto',
                                  marker = list(color = 'rgb(255,228,181)',
                                                line = list(color = 'rgb(8,48,107)', width = 1.5)))
  
  fig <- fig %>%plotly::add_trace(data = reac_intensive(),name = "occupancy",x = ~region, y=~occupancy, type = 'bar',
                                  text = ~occupancy, textposition = 'auto',
                                  marker = list(color = 'rgb(220,20,60)',
                                                line = list(color = 'rgb(8,48,107)', width = 1.5)))
  
  
  fig <- fig %>%plotly::layout(title = paste0("Occupancy vs initial capacity - day: ",input$occupancy_date),
                               barmode = 'group',
                               xaxis = list(title = "Region"),
                               yaxis = list(title = "Occupancy vs Capacity"),
                               legend = list(x = 0.1, y = 0.9))
  
  fig
  
  
  
})



# =========== plot growth monitoring --------------------------------------------------------------------
reac_growth <- shiny::reactiveValues()
  
shiny::observe({
  if(is_ready(input$growth_province)){
    if(input$growth_province != "--- ALL ---" & input$growth_region == "--- ALL ---") {
      reac_growth$out_growth <- country_growth %>%
        dplyr::filter(province==input$growth_province)
    } else {
      reac_growth$out_growth <- country_growth %>%
        dplyr::filter(region==input$growth_region,province==input$growth_province)
    }
    
    reac_growth$growth <- data.frame(date=reac_growth$out_growth$data, growth=reac_growth$out_growth$growth)
    
    reac_growth$growth_xts <- xts::xts(reac_growth$growth[,-1], order.by=reac_growth$growth[,1])
    
    reac_growth$growth_change <- data.frame(date=reac_growth$out_growth$data, growth=reac_growth$out_growth$growth_change)
    
    reac_growth$growth_change_xts <- xts::xts(reac_growth$growth_change[,-1], order.by=reac_growth$growth_change[,1])
    
    reac_growth$table_growth <- data.frame(date=reac_growth$out_growth$data, growth=reac_growth$out_growth$growth, growth_change = reac_growth$out_growth$growth_change)
  }
 
})

# boxes with arrows and growth in growth monitoring
output$summary_box_growth <- renderUI({
  
  shinydashboardPlus::descriptionBlock(
    number = paste0(tail(reac_growth$out_growth$growth,1),"%"),
    numberColor = ifelse(tail(reac_growth$out_growth$growth,1)>0,"red","green"), 
    numberIcon = ifelse(tail(reac_growth$out_growth$growth,1)>0,"fas fa-caret-up","fas fa-caret-down"),
    header = "CASES GROWTH", 
    text = NULL, 
    rightBorder = TRUE,
    marginBottom = FALSE
  )
  
})


output$summary_box_growth_change <- renderUI({
  
  shinydashboardPlus::descriptionBlock(
    number = paste0(tail(reac_growth$out_growth$growth_change,1),"%"),
    numberColor = ifelse(tail(reac_growth$out_growth$growth_change,1)>0,"red","green"), 
    numberIcon = ifelse(tail(reac_growth$out_growth$growth_change,1)>0,"fas fa-caret-up","fas fa-caret-down"),
    header = HTML("&Delta; CASES GROWTH"), 
    text = NULL, 
    rightBorder = FALSE,
    marginBottom = FALSE
  )
  
})

output$plot_test <- highcharter::renderHighchart(
  if(is_ready(reac_growth$growth_xts)){
highcharter::highchart(type = "stock") %>% 
  highcharter::hc_chart(zoomType = "xy") %>%
  highcharter::hc_rangeSelector(buttons = list(list(type="week", count=1, text="1wk"), list(type="week", count=2, text="2wks"), 
                                               list(type="week", count=3, text="3wks"), list(type="week", count=4, text="4wks"),
                                               list(type="week", count=5, text="5wks"), list(type="week", count=6, text="6wks"),
                                               list(type="all", count=1, text="All")), 
                                selected = 7 ) %>%
  highcharter::hc_title(text = "% growth and growth change of total cases") %>%
  # highcharter::hc_add_series(reac_growth$growth_xts, name="growth", color = "red", type = "spline", yAxis = 0,
  #                            tooltip = list(
  #                              pointFormat = '<span style="color:{point.color}">-</span> Growth: <b>{point.y}</b><br>Growth change: <b>prova</b>',
  #                              valueSuffix = '%')) %>% 
  highcharter::hc_add_series(reac_growth$table_growth, name="growth", 
                             highcharter::hcaes(x = date, y = growth, yd = growth_change),
                             color = "red", type = "spline", yAxis = 0,
                              tooltip = list(
                               pointFormat = '<span style="color:{point.color}">-</span> Growth: <b>{point.y}</b><br>Growth change: <b>{point.yd}</b>',
                               valueSuffix = '%')) %>% 
  # highcharter::hc_add_series(reac_growth$growth_change_xts, name="growth_change", color = "orange", type = "spline", yAxis = 1) %>%
  highcharter::hc_yAxis(
    plotLines = list(list(color = "black", value = 0, width = 3, dashStyle = "ShortDash"))
  )
  #   %>%
  # highcharter::hc_yAxis_multiples(
  #   list(lineWidth = 3, title = list(text  =  ''), plotLines = list(list(color = "#e60000", value = 1, width = 4, dashStyle = "ShortDash"))),
  #   list(showLastLabel = FALSE, opposite = TRUE, title = list(text  =  ''))
  # )
}

)

# Tests tracking -----------------------------------------------------------

shiny::observe({
  if(input$test_aggr) {
    if(is_ready(input$test_avgbut)) {
      switch(input$test_avgbut,
             "abs" = {
               reac_test$tamp_creg <- tamp_creg_wly
               reac_test$tamp_creg_1 <- tamp_creg_1_wly
             }, 
             "avg" = {
               reac_test$tamp_creg <- tamp_creg_avg_wly
               reac_test$tamp_creg_1 <- tamp_creg_1_avg_wly
             })
    }
  } else {
    reac_test$tamp_creg <- tamp_creg
    reac_test$tamp_creg_1 <- tamp_creg_1
  }
  
})


output$tamp_plot <- highcharter::renderHighchart(
  highcharter::hchart(dplyr::filter(reac_test$tamp_creg_1,region==input$test_region), "column", 
                      highcharter::hcaes(x = Date, y = value, group = key), color=c("red","#888888")) %>% 
    # BUGGED
    #highcharter::hc_chart(zoomType = "xy", scrollablePlotArea = list(minWidth = 1000, scrollPositionX = 1)) %>%
    highcharter::hc_chart(zoomType = "xy") %>%
    highcharter::hc_yAxis_multiples(
      list(lineWidth = 3, title = list(text  =  '')),
      list(showLastLabel = FALSE, opposite = TRUE, title = list(text  =  ''))
    ) %>%
    highcharter::hc_add_series(data = dplyr::filter(reac_test$tamp_creg,region==input$test_region), 
                               type = "spline", yAxis = 1, highcharter::hcaes(x = Date, y = share_infected_discovered),
                               name="Share of infected discovered", color="#383838")
)



# SPREADING DELAY ---------------------------------------------------------

# shiny::observe({
# 
#   
#   reac_delay$data
# })

dfita4 <- dfita3 %>%
  dplyr::mutate(
    start_num = scales::rescale(as.numeric(start)),
    end_num = scales::rescale(as.numeric(end)),
    peak_num = scales::rescale(as.numeric(peak)))

shiny::observe({
  
  switch(input$rank_type,
         "start" = {
           reac_delay$pointFormat = "region: {point.name} <br> <strong>start: {point.start}</strong> <br> end: {point.end} <br> peak: {point.peak}"
           reac_delay$color_stops = highcharter::color_stops(4,c("#dfbf9f", "#996633", "#ecec13", "#ff944d"))
         },
         "peak" = {
           reac_delay$pointFormat = "region: {point.name} <br> start: {point.start} <br> end: {point.end} <br> <strong>peak: {point.peak}</strong>"
           reac_delay$color_stops = highcharter::color_stops(4,c("#dfbf9f", "#996633", "#ecec13", "#ff944d"))
          },
         "end" = {
           reac_delay$pointFormat = "region: {point.name} <br> start: {point.start} <br> <strong>end: {point.end}</strong> <br> peak: {point.peak}"
           reac_delay$color_stops = highcharter::color_stops(4,c("#dfbf9f", "#996633", "#ecec13", "#ff944d"))
         })
  
  reac_delay$map_rank <- highcharter::highchart(type = "map") %>% 
    highcharter::hc_chart(zoomType = "xy") %>%
    highcharter::hc_add_series_map(map = ita, df = dfita4, 
                                   joinBy = "hasc", value = paste0(input$rank_type, "_num"),
                                   name = "") %>%
    highcharter::hc_tooltip(pointFormat = reac_delay$pointFormat) %>% 
    highcharter::hc_colorAxis(
      stops = reac_delay$color_stops
    )
})

output$map_rank <- highcharter::renderHighchart({
  reac_delay$map_rank
})






# dynamic tabs ------------------------------------------------------------

regprov_df <- purrr::map_df(names(provTS), function(x){
  provTS[[x]] %>%
    dplyr::select(denominazione_regione, denominazione_provincia) %>%
    dplyr::rename(region=denominazione_regione, province=denominazione_provincia) %>%
    unique()
}) %>%
  dplyr::bind_rows(
    dplyr::tibble(region=names(regionTS),province="--- ALL ---")
  ) %>%
  dplyr::bind_rows(
    dplyr::tibble(region="--- ALL ---",province=names(provTS))
  ) %>%
  dplyr::bind_rows(
    dplyr::tibble(region="--- ALL ---",province="--- ALL ---")
  )

# tab for privinces selection in growth monitoring
output$regprov_dfout <- renderUI({

  shiny::selectInput(
    inputId = "growth_province", label = "Province",
    choices = dplyr::pull(dplyr::filter(regprov_df, region==input$growth_region), province),
    selected = "--- ALL ---")
  
})



output$growth_NAlog <- renderUI({

  if(is_ready(reac_growth$growth) && disc_NAfind(reac_growth$growth$growth)) {
    fluidRow(
      hr(),
      helpText(em("Warning: NA introduced"))
    )
  }

})


output$test_NAlog <- renderUI({

  if( is_ready(input$test_region) && disc_NAfind(dplyr::filter(reac_test$tamp_creg,region==input$test_region)$share_infected_discovered) ) {
    fluidRow(
      hr(),
      helpText(em("Warning: NA introduced"))
    )
  }
})

output$test_avg <- renderUI({
  
  if( is_ready(input$test_aggr) && input$test_aggr) {
    shiny::fluidRow(
      shiny::radioButtons("test_avgbut", label=NULL,
                          choices=list("Absolute"="abs", "Average"="avg"),
                          inline = TRUE)
    )
  }
})


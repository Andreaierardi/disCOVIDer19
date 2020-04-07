# ====== GENERAL INFO ==== 
#Dataset and plot reactive
reac_dataset <- shiny::reactiveValues()

shiny::observe({
  if(input$geninfo_reg != "default") {
    ch <- c("--- ALL ---" = "default", regAndProv[regAndProv$region == input$geninfo_reg, "province"])
  } else {
    ch <- c("--- ALL ---" = "default", provNames)
  }
  shiny::updateSelectizeInput(session, inputId = "geninfo_prov", choices = ch, selected = NULL)
})



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
    reac_dataset$pointWidth = 0
    reac_dataset$yAxis = 1
    reac_dataset$headerCol <- DT::JS("function(settings, json) {", "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});", "}")
    
    if(input$geninfo_prov == "default") {
      reac_dataset$table_plot <- eval(reac_dataset$data)[[reac_dataset$name]] %>%
        dplyr::select("Date" = data, "Tot. cases" = totale_casi, "Tot. deaths" = deceduti, "Tot. recoveries" = dimessi_guariti)
      reac_dataset$colors <- c("blue", "black", "green")
    } else {
      reac_dataset$table_plot <- eval(reac_dataset$data)[[reac_dataset$name]] %>%
        dplyr::select("Date" = data, "Tot. cases" = totale_casi)
      reac_dataset$colors <- c("blue")
    }
    
    
  } else if(input$geninfo_type == "new") {
    reac_dataset$plot_type = "column"
    reac_dataset$pointWidth = 15
    reac_dataset$yAxis = 0
    reac_dataset$headerCol <- DT::JS("function(settings, json) {", "$(this.api().table().header()).css({'background-color': '#e62e00', 'color': '#fff'});", "}")
    
    if(input$geninfo_prov == "default") {
      reac_dataset$table_plot <- eval(reac_dataset$data)[[reac_dataset$name]] %>%
        dplyr::mutate("New deaths" = c(NA,diff(deceduti)), "New recoveries" = c(NA,diff(dimessi_guariti)), "New cases" = c(NA,diff(totale_casi))) %>%
        dplyr::select("Date" = data, "New cases", "New deaths", "New recoveries")
      reac_dataset$colors <- c("blue", "black", "green")
    } else {
      reac_dataset$table_plot <- eval(reac_dataset$data)[[reac_dataset$name]] %>%
        dplyr::mutate("New cases" = c(NA,diff(totale_casi))) %>%
        dplyr::select("Date" = data, "New cases")
      reac_dataset$colors <- c("blue")
    }
    
    
  } else if(input$geninfo_prov == "default" && input$geninfo_type == "cur") {
    reac_dataset$plot_type = "spline"
    reac_dataset$pointWidth = 0
    reac_dataset$yAxis = 1
    reac_dataset$headerCol <- DT::JS("function(settings, json) {", "$(this.api().table().header()).css({'background-color': '#ffcc00', 'color': '#fff'});", "}")
    
    reac_dataset$table_plot <- eval(reac_dataset$data)[[reac_dataset$name]] %>%
      dplyr::select("Date" = data, "Current pos. cases" = totale_positivi, "Current hospitalised" = totale_ospedalizzati, "Current intensive care" = terapia_intensiva, "Current home isol." = isolamento_domiciliare)
    # reac_dataset$colors <- c("darkorchid", "darkseagreen3", "firebrick2", "cyan2")
    reac_dataset$colors <- c("#cc66ff", "#00e673", "#ff3300", "#00bfff")
  }
    
  
  
  reac_dataset$plot = highcharter::hchart(tidyr::gather((reac_dataset$table_plot), key="key", value="value", -Date),
                                          type = reac_dataset$plot_type, title= "General info",
                                          highcharter::hcaes(x = Date, y = value, group = key),
                                          color=reac_dataset$colors,
                                          yAxis = reac_dataset$yAxis,pointWidth= reac_dataset$pointWidth ,showInLegend=TRUE) %>%
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

hc <- highcharter::highchart(type = "stock") %>% 
  highcharter::hc_chart(zoomType = "xy") %>%
  highcharter::hc_rangeSelector(buttons = list(list(type="week", count=1, text="1wk"), list(type="week", count=2, text="2wks"), 
                                               list(type="week", count=3, text="3wks"), list(type="week", count=4, text="4wks"),
                                               list(type="week", count=5, text="5wks"), list(type="week", count=6, text="6wks"),
                                               list(type="all", count=1, text="All")), 
                                selected = 7 ) %>%
  highcharter::hc_title(text = "% growth and growth change of total cases") %>%
  highcharter::hc_add_series(growth_xts, name="growth", color = "red", type = "spline") %>% 
  highcharter::hc_add_series(growth_change_xts, name="growth_change", color = "orange", type = "spline")


output$plot_test <- highcharter::renderHighchart(
  hc
)

# tamponi graph -----------------------------------------------------------


output$tamp_plot <- highcharter::renderHighchart(
  highcharter::hchart(tamp_data_1, "column", highcharter::hcaes(x = date, y = value, group = key), color=c("red","#888888")) %>% 
    highcharter::hc_chart(zoomType = "xy") %>%
    
    highcharter::hc_yAxis_multiples(
      list(lineWidth = 3, title = list(text  =  '')),
      list(showLastLabel = FALSE, opposite = TRUE, title = list(text  =  ''))
    ) %>%
    highcharter::hc_add_series(data = tamp_data, type = "spline", 
                               yAxis = 1, highcharter::hcaes(x = date, y = share_infected_discovered),
                               name="share_infected_discovered", color="#383838")
)


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


# ====== GENERAL INFO ==== 
#Dataset and plot reactive
reac_dataset <- shiny::reactiveValues()

shiny::observe({
  if(input$regiontab2 != "default") {
    ch <- c("--- ALL ---" = "default", regAndProv[regAndProv$region == input$regiontab2, "province"])
  } else {
    ch <- c("--- ALL ---" = "default", provNames)
  }
  shiny::updateSelectizeInput(session, inputId = "provincetab2", choices = ch, selected = NULL)
})



# General info reactive dataset
shiny::observe({

  if(input$difference ==1)
  {
    reac_dataset$plot_type = "spline"
    reac_dataset$pointWidth = 0
    reac_dataset$yAxis = 1
  }
  else 
  {
    reac_dataset$plot_type = "column"
    reac_dataset$pointWidth = 15
    reac_dataset$yAxis = 0
  }
  
  if(input$regiontab2 == "default" && input$provincetab2 == "default") {
    
    if(input$difference == 1)
    {
      reac_dataset$name <- paste0(input$countrytab2, ", cumulative")
      reac_dataset$dataset <- countryTS$Italy 
    }
    else
    {
      reac_dataset$name <- paste0(input$countrytab2, ", daily")
      
      reac_dataset$dataset$totale_casi = diff(c(NA,  countryTS$Italy$totale_casi))
    #  reac_dataset$dataset$terapia_intensiva = diff( c(NA, countryTS$Italy$terapia_intensiva))
     # reac_dataset$dataset$totale_ospedalizzati = diff(c(NA,  countryTS$Italy$totale_ospedalizzati))
      reac_dataset$dataset$deceduti = diff(c(NA,  countryTS$Italy$deceduti))
      reac_dataset$dataset$dimessi_guariti = diff(c(NA,  countryTS$Italy$dimessi_guariti))
    }
    
    
  }
  
  
  else if(input$regiontab2 != "default" &&  input$provincetab2 == "default") {
    
    if(input$difference == 1)
    {
      reac_dataset$name <-  paste0(input$regiontab2, ", cumulative")
      
      reac_dataset$dataset <- regionTS[[input$regiontab2]]
    }
    
    else
    {
      reac_dataset$name <- paste0(input$regiontab2, ", daily")
      
      reac_dataset$dataset$totale_casi = diff(c(NA, regionTS[[input$regiontab2]]$totale_casi))
     # reac_dataset$dataset$terapia_intensiva = diff( c(NA,regionTS[[input$regiontab2]]$terapia_intensiva))
     # reac_dataset$dataset$totale_ospedalizzati = diff(c(NA, regionTS[[input$regiontab2]]$totale_ospedalizzati))
      reac_dataset$dataset$deceduti = diff(c(NA, regionTS[[input$regiontab2]]$deceduti))
      reac_dataset$dataset$dimessi_guariti = diff(c(NA, regionTS[[input$regiontab2]]$dimessi_guariti))
    }
  }
  
  if(input$provincetab2 == "default")
  {
    
    
    reac_dataset$plot = highcharter::hchart(reac_dataset$dataset,type =reac_dataset$plot_type,title= "General info",highcharter::hcaes(x=data,y = totale_casi),  name="Cases", color="blue", yAxis = reac_dataset$yAxis,pointWidth= reac_dataset$pointWidth ,showInLegend=TRUE) %>% 
      highcharter::hc_chart(zoomType = "xy") %>%
      highcharter::hc_yAxis_multiples(
        list(lineWidth = 3, title = list(text  =  '')),
        list(showLastLabel = TRUE, opposite = TRUE, title = list(text  =  ''))
      )  %>%
      # highcharter::hc_add_series(data =reac_dataset$dataset, type = reac_dataset$plot_type, 
      #                           yAxis = reac_dataset$yAxis,pointWidth= reac_dataset$pointWidth,  highcharter::hcaes(x = data, y = totale_ospedalizzati),
      #                            name="Symptomatic", color="orange",showInLegend=TRUE)   %>%
    
      highcharter::hc_add_series(data =reac_dataset$dataset, type =reac_dataset$plot_type, 
                                 yAxis = reac_dataset$yAxis,pointWidth= reac_dataset$pointWidth,  highcharter::hcaes(x = data, y = dimessi_guariti),
                                 name="Recovered", color="green",showInLegend=TRUE)  %>%
      highcharter::hc_add_series(data =reac_dataset$dataset, type = reac_dataset$plot_type, 
                                 yAxis = reac_dataset$yAxis,pointWidth= reac_dataset$pointWidth, highcharter::hcaes(x = data, y = deceduti),
                                 name="Deaths", color="black",showInLegend=TRUE)  %>%
     #highcharter::hc_add_series(data = reac_dataset$dataset, type =reac_dataset$plot_type, 
     #                           yAxis = reac_dataset$yAxis,pointWidth= reac_dataset$pointWidth, highcharter::hcaes(x = data, y = terapia_intensiva),
     #                           name="Intesive care", color="red",showInLegend=TRUE) %>%
      
      highcharter::hc_legend(align = "top", verticalAlign = "top",
                             layout = "vertical", x = 30, y = 100, enabled=TRUE) %>%
      highcharter::hc_title(text = paste0("General info for: ",reac_dataset$name),
                            margin = 20, align = "left",
                            style = list(useHTML = TRUE))
  }
  else if(input$provincetab2 != "default"){
    
    
    if(input$difference==1)
    {
      reac_dataset$dataset <- provTS[[input$provincetab2]]
      reac_dataset$name <- paste0(input$provincetab2, ", daily")
      
    }
    
    else      
    {
      reac_dataset$dataset$totale_casi = diff(c(NA, provTS[[input$provincetab2]]$totale_casi))
      reac_dataset$name <- paste0(input$provincetab2, ", cumulative")
    }    
    
    
    reac_dataset$plot = highcharter::hchart(reac_dataset$dataset,type = reac_dataset$plot_type,title= "General info",highcharter::hcaes(x=data,y = totale_casi),  name="Total cases", color="blue",    yAxis = reac_dataset$yAxis,pointWidth= reac_dataset$pointWidth,showInLegend=TRUE) %>% 
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
    
  }
  else
  {
    reac_dataset$dataset <- need(FALSE, "Wrong inputs")
  }
}

)


# General info reactive plot
output$general_infos_plot <- highcharter::renderHighchart(
  reac_dataset$plot
)



#======= RAW DATA ====== 

# General info raw data

output$rawData_input <- shiny::renderUI({
  shiny::fluidPage(
    shiny::fluidRow(
      shiny::column(3,
                    shiny::radioButtons(
                      inputId = "rawData_terr",
                      label = NULL,
                      choices = list("National" = 1, "By region" = 2, "By province" = 3),
                      selected = 2
                    )
      ),
      shiny::column(4,
                    shiny::uiOutput("rawData_sel_input")
      ),
      shiny::column(5,
                    shiny::radioButtons(
                      inputId = "rawData_type", 
                      label = "Data type:",
                      choiceNames = list(HTML("<p><strong><span style='background-color: rgb(0, 0, 0); color: rgb(255, 255, 255);'>Total</span></strong> (cumulative)</p>"),
                                     HTML("<p><span style='background-color: rgb(184, 49, 47); color: rgb(255, 255, 255);'><strong>New</strong></span> (daily)</p>"),
                                     HTML("<p><span style='background-color: rgb(255, 204, 0); color: rgb(255, 255, 255);'><strong>Current</strong></span></p>")
                                     ),
                      choiceValues = list("tot", "new", "cur"),
                      selected = "tot",
                      inline = TRUE)
      )
    )
    
  )
  
})

output$rawData_sel_input <- shiny::renderUI({
  
  if(is_ready(input$rawData_terr))
  {
    
    if(input$rawData_terr != 1) {
      if(input$rawData_terr == 2)
        shiny::selectInput(inputId = "rawData_reg_sel", label = NULL,
                           choices = regNames, selected = "Lombardia")
      else if(input$rawData_terr == 3)
        shiny::selectInput(inputId = "rawData_prov_sel", label = NULL,
                           choices = provNames, selected = "Milano")
    }
  }
})




output$rawData_table <- DT::renderDataTable({
  
  if( is_ready(input$rawData_terr) && input$rawData_terr == 1 | (input$rawData_terr == 2 && is_ready(input$rawData_reg_sel)) | (input$rawData_terr == 3 && is_ready(input$rawData_prov_sel)) & is_ready(input$rawData_type) ) {
    
    headerCol <- switch(input$rawData_type,
                        "tot" = DT::JS("function(settings, json) {", "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});", "}"),
                        "new" = DT::JS("function(settings, json) {", "$(this.api().table().header()).css({'background-color': '#e62e00', 'color': '#fff'});", "}"),
                        "cur" = DT::JS("function(settings, json) {", "$(this.api().table().header()).css({'background-color': '#ffcc00', 'color': '#fff'});", "}")
                        )
    
    DT::datatable( 
      switch(input$rawData_terr,
             "1" = (switch(input$rawData_type,
                      "tot" = countryTS$Italy %>% 
                                dplyr::select("Date" = data, "Tot. cases" = totale_casi, "Tot. deaths" = deceduti, "Tot. recoveries" = dimessi_guariti, "Tot. swabs" = tamponi),
                      "new" = countryTS$Italy %>%
                                dplyr::mutate("New deaths" = dplyr::lag(deceduti), "New recoveries" = dplyr::lag(dimessi_guariti), "New swabs" = dplyr::lag(tamponi)) %>%
                                dplyr::select("Date" = data, "New cases" = nuovi_positivi, "New deaths", "New recoveries", "New swabs"),
                      "cur" = countryTS$Italy %>%
                                dplyr::select("Date" = data, "Current pos. cases" = totale_positivi, "Current hospitalised" = totale_ospedalizzati, "Current intensive care" = terapia_intensiva, "Current home isol." = isolamento_domiciliare)
                      )
                    ),
               
             "2" = (switch(input$rawData_type,
                      "tot" = regionTS[[input$rawData_reg_sel]] %>% 
                                dplyr::select("Date" = data, "Tot. cases" = totale_casi, "Tot. deaths" = deceduti, "Tot. recoveries" = dimessi_guariti, "Tot. swabs" = tamponi),
                      "new" = regionTS[[input$rawData_reg_sel]] %>% 
                                dplyr::mutate("New deaths" = dplyr::lag(deceduti), "New recoveries" = dplyr::lag(dimessi_guariti), "New swabs" = dplyr::lag(tamponi)) %>%
                                dplyr::select("Date" = data, "New cases" = nuovi_positivi, "New deaths", "New recoveries", "New swabs"),
                      "cur" = regionTS[[input$rawData_reg_sel]] %>% 
                                dplyr::select("Date" = data, "Current pos. cases" = totale_positivi, "Current hospitalised" = totale_ospedalizzati, "Current intensive care" = terapia_intensiva, "Current home isol." = isolamento_domiciliare)
                      )
                    ),
               
             "3" = provTS[[input$rawData_prov_sel]] %>%
                        dplyr::select("Date" = data, "Tot. cases" = totale_casi)        
      ), options = list(
        searching = FALSE,
        pageLength = 6, lengthMenu = c(6,10,14), scrollX = T,
        initComplete = headerCol)
    )
  }
  
})



# tabbox selection
output$tabset2Selected <- renderText({
  #input$tabset2
  paste(input$rawData_go)
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


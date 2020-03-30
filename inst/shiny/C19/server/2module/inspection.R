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
  
  if(input$regiontab2 == "default" && input$provincetab2 == "default") {
    reac_dataset$name <- input$countrytab2
    reac_dataset$dataset <- countryTS$Italy
    
  }
  
  
  else if(input$regiontab2 != "default" &&  input$provincetab2 == "default") {
    reac_dataset$name <- input$regiontab2
    reac_dataset$dataset <- regionTS[[input$regiontab2]]
  }
  
  if(input$provincetab2 == "default")
  {
    reac_dataset$plot = highcharter::hchart(reac_dataset$dataset,"spline",title= "General info",highcharter::hcaes(x=data,y = totale_casi),  name="Total cases", color="blue", yAxis = 1,showInLegend=TRUE) %>% 
      highcharter::hc_chart(zoomType = "xy") %>%
      highcharter::hc_yAxis_multiples(
        list(lineWidth = 3, title = list(text  =  '')),
        list(showLastLabel = TRUE, opposite = TRUE, title = list(text  =  ''))
      )  %>%
      highcharter::hc_add_series(data = reac_dataset$dataset, type = "spline", 
                                 yAxis = 1, highcharter::hcaes(x = data, y = terapia_intensiva),
                                 name="Total Intesive care", color="red",showInLegend=TRUE) %>%
      highcharter::hc_add_series(data =reac_dataset$dataset, type = "spline", 
                                 yAxis = 1, highcharter::hcaes(x = data, y = ricoverati_con_sintomi),
                                 name="Total Hospitalized", color="orange",showInLegend=TRUE)   %>%
      highcharter::hc_add_series(data =reac_dataset$dataset, type = "spline", 
                                 yAxis = 1, highcharter::hcaes(x = data, y = deceduti),
                                 name="Total Deaths", color="black",showInLegend=TRUE)  %>%
      highcharter::hc_add_series(data =reac_dataset$dataset, type = "spline", 
                                 yAxis = 1, highcharter::hcaes(x = data, y = dimessi_guariti),
                                 name="Total recovered", color="green",showInLegend=TRUE)  %>%
      highcharter::hc_legend(align = "top", verticalAlign = "top",
                             layout = "vertical", x = 0, y = 100, enabled=TRUE) %>%
      highcharter::hc_title(text = paste0("General info for: ",reac_dataset$name),
                            margin = 20, align = "left",
                            style = list(useHTML = TRUE))
  }
  else if(input$provincetab2 != "default"){
    reac_dataset$name <- input$provincetab2
    reac_dataset$dataset <- provTS[[input$provincetab2]]
    reac_dataset$plot = highcharter::hchart(reac_dataset$dataset,"spline",title= "General info",highcharter::hcaes(x=data,y = totale_casi),  name="Total cases", color="blue", yAxis = 1,showInLegend=TRUE) %>% 
      highcharter::hc_chart(zoomType = "xy") %>%
      highcharter::hc_yAxis_multiples(
        list(lineWidth = 3, title = list(text  =  '')),
        list(showLastLabel = TRUE, opposite = TRUE, title = list(text  =  ''))
      )  %>%
      highcharter::hc_legend(align = "top", verticalAlign = "top",
                             layout = "vertical", x = 0, y = 100, enabled=TRUE) %>%  highcharter::hc_title(text = paste0("General info for: ",reac_dataset$name),
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
      shiny::column(5,
                    shiny::dateRangeInput(
                      inputId = "rawData_date",
                      label = "Select dates",
                      start = countryTS$Italy$data[1],
                      end = countryTS$Italy$data[nrow(countryTS$Italy)],
                      min = countryTS$Italy$data[1], 
                      max = countryTS$Italy$data[nrow(countryTS$Italy)]
                    )
      ),
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
    
  if( is_ready(input$rawData_terr) && input$rawData_terr == 1 | (input$rawData_terr == 2 && is_ready(input$rawData_reg_sel)) | (input$rawData_terr == 3 && is_ready(input$rawData_prov_sel)) ) {
    DT::datatable( 
        switch(input$rawData_terr,
               "1" = countryTS$Italy %>% 
                 dplyr::select(-stato, -data_seriale) %>%
                 dplyr::filter(data >= input$rawData_date[1] &  data <= input$rawData_date[2]),
               "2" = regionTS[[input$rawData_reg_sel]] %>%
                 dplyr::select(-stato,-lat,-long,-denominazione_regione,-codice_regione,-data_seriale) %>%
                 dplyr::filter(data >= input$rawData_date[1] &  data <= input$rawData_date[2]),
               "3" = provTS[[input$rawData_prov_sel]] %>%
                 dplyr::select(-stato,-codice_provincia,-denominazione_provincia,-sigla_provincia,
                               -lat,-long,-denominazione_regione,-codice_regione,-data_seriale) %>%
                 dplyr::filter(data >= input$rawData_date[1] &  data <= input$rawData_date[2])         
        ), options = list(
          searching = FALSE,
          pageLength = 6, lengthMenu = c(6,10,14), scrollX = T)
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
    title=paste0("Day ",input$occupancy_date," - Percentage Occupancy vs. intensive care capacity at the start of the pandemic"),
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

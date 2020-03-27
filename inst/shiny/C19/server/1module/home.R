# map ---------------------------------------------------------------------
  

output$map_region <- output$map_region_modal <- highcharter::renderHighchart(
      if(input$map_value=="absolute") {
        highcharter::highchart(type = "map") %>% 
          highcharter::hc_chart(zoomType = "xy") %>%
          highcharter::hc_add_series_map(map = map, df = dfita1,
                                         joinBy = "id", value = input$map_value, name="absolute (total cases)") %>%
        highcharter::hc_colorAxis(
          stops = highcharter::color_stops(4,c("#FFE4B5","#FFA500","#FF4500","#cc0000")))
      } else if(input$map_value=="percentage") {
        highcharter::highchart(type = "map") %>% 
          highcharter::hc_chart(zoomType = "xy") %>%
          
          highcharter::hc_add_series_map(map = map, df = dfita1,
                                         joinBy = "id", value = input$map_value, name="percentage (cases/pop * 100)")
      } else {
        highcharter::highchart(type = "map") %>% 
          highcharter::hc_chart(zoomType = "xy") %>%
          
          highcharter::hc_add_series_map(map = map, df = dfita1,
                                         joinBy = "id", value = input$map_value, name="density (cases/km^2 * 1000)") %>%
          highcharter::hc_colorAxis(
            stops = highcharter::color_stops(4,c("#d8ebb5","#639a67","#2b580c","#003000")))
      }
  )

  

# map by province ---------------------------------------------------------

  



  
output$map_province <- output$map_province_modal <- highcharter::renderHighchart(
  if(input$map_value=="absolute") {
    highcharter::highchart(type = "map") %>% 
      highcharter::hc_chart(zoomType = "xy") %>%
      highcharter::hc_add_series_map(map = ita, df = dfita2, 
                                     joinBy = "hasc", value = input$map_value, name="absolute (total cases)") %>%
      highcharter::hc_colorAxis(
        stops = highcharter::color_stops(4,c("#FFE4B5","#FFA500","#FF4500","#cc0000")))
  } else if(input$map_value=="percentage") {
    highcharter::highchart(type = "map") %>% 
      highcharter::hc_chart(zoomType = "xy") %>%
      highcharter::hc_add_series_map(map = ita, df = dfita2, 
                                     joinBy = "hasc", value = input$map_value, name="percentage (cases/pop * 100)")
  } else {
    highcharter::highchart(type = "map") %>% 
      highcharter::hc_chart(zoomType = "xy") %>%
      
      highcharter::hc_add_series_map(map = ita, df = dfita2, 
                                     joinBy = "hasc", value = input$map_value, name="density (cases/km^2 * 1000)") %>%
      highcharter::hc_colorAxis(
        stops = highcharter::color_stops(4,c("#d8ebb5","#639a67","#2b580c","#003000")))
  }
  
  
)


# tabbox ------------------------------------------------------------------

  output$tabset1Selected <- renderText({
    input$tabset1
  })


# modal dialog ------------------------------------------------------------

observeEvent(input$show, {
  showModal(modalDialog(
    title = NULL, easyClose = TRUE, size = "l",
    
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
        
    shinydashboard::tabBox(
          width = 12,
          # height = "250px",
          title = NULL,
          # The id lets us use input$tabset1 on the server to find the current tab
          id = "tabset1",
          tabPanel("By Province",
                   shinycssloaders::withSpinner(
                   highcharter::highchartOutput('map_province_modal',
                                                width = "100%",
                                                height = "800px"
                   ),
                   color="#dd4b39"
                   )
          ),
          tabPanel("By Region", 
                   shinycssloaders::withSpinner(
                   highcharter::highchartOutput('map_region_modal',
                                                width = "100%",
                                                height = "800px"
                   ),
                   color="#dd4b39"
                   )
          )
        )
    
  ))
})
  
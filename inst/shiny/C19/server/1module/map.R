# map ---------------------------------------------------------------------
reac_map <- shiny::reactiveValues()

waitLoading_map <- shiny::reactive({
  shiny::validate(
    shiny::need(is_ready(input$map_value), "Wait...")
  )
  return(input$map_value)
})


shiny::observe({
  wait <- waitLoading_map()
  
  if(input$map_value=="absolute"){
    reac_map$name <- "<strong>absolute</strong> (total cases)"
    reac_map$colors <- c("#FFE4B5","#FFA500","#FF4500","#cc0000")
    reac_map$valueDecimals = 0
    reac_map$valueSuffix = ""
    
  } else if(input$map_value=="proportion") {
    reac_map$name <- "<strong>proportion</strong> (cases/pop * 100)"
    reac_map$colors <- c("#D4E6F1", "#7FB3D5", "#2980B9", "#1A5276")
    reac_map$valueDecimals = 4
    reac_map$valueSuffix = "%"
    
  } else if(input$map_value=="density") {
    reac_map$name <-"<strong>density</strong> (cases/area)"
    reac_map$colors <- c("#d8ebb5","#639a67","#2b580c","#003000")
    reac_map$valueDecimals = 4
    reac_map$valueSuffix = " / km<sup>2</sup>"
    
  } else {
    reac_map$name <- "<strong>growth<strong> (cases<sub>t</sub>/cases<sub>t-1</sub> - 1) * 100"
    reac_map$colors <- c("#E6E6FA","#D8BFD8","#BA55D3","#800080")
    reac_map$valueDecimals = 3
    reac_map$valueSuffix = "%"
  }
  
  
  ## REGION MAP ##
  
  reac_map$df <- dfita1 %>%
    dplyr::filter(type==input$map_value) %>%
    dplyr::select(-type)
  
  reac_map$my_ds <- reac_map$df %>%
    dplyr::group_by(id) %>% 
    dplyr::do(item = list(
      id = dplyr::first(.$id),
      sequence = .$value,
      value = dplyr::first(.$value))) %>% 
    .$item
  
  reac_map$map_region <- highcharter::highchart(type = "map") %>% 
    highcharter::hc_chart(zoomType = "xy") %>% 
    highcharter::hc_add_series(data = reac_map$my_ds,
                               mapData = map,
                               joinBy = "id",
                               name=reac_map$name) %>% 
    highcharter::hc_colorAxis(stops = highcharter::color_stops(4,reac_map$colors)) %>% 
    highcharter::hc_tooltip(useHTML = TRUE, valueDecimals = reac_map$valueDecimals, valueSuffix = reac_map$valueSuffix) %>%
    highcharter::hc_legend(floating=TRUE,verticalAlign = "top", align= "right") %>%
    highcharter::hc_motion(
      enabled = TRUE,
      axisLabel = "year",
      startIndex = length(unique(as.character(reac_map$df$date))),
      labels = unique(as.character(reac_map$df$date)),
      series = 0,
      updateIterval = 50,
      magnet = list(
        round = "floor",
        step = 0.1
      )
    )
  
  
  ## PROVINCE MAP ##

  reac_map$df_prov <- dfita2 %>%
      dplyr::filter(type==input$map_value) %>%
      dplyr::select(-type)
  
  reac_map$my_ds_prov <- reac_map$df_prov %>%
      dplyr::group_by(hasc) %>% 
      dplyr::do(item = list(
        hasc = dplyr::first(.$hasc),
        sequence = .$value,
        value = dplyr::first(.$value))) %>% 
      .$item
  
  
  
 
  reac_map$map_province <- highcharter::highchart(type = "map") %>% 
      highcharter::hc_chart(zoomType = "xy") %>% 
      highcharter::hc_add_series(data = reac_map$my_ds_prov,
                                 mapData = ita,
                                 joinBy = "hasc",
                                 name=reac_map$name) %>% 
      highcharter::hc_colorAxis(stops = highcharter::color_stops(4,reac_map$colors)) %>% 
      highcharter::hc_tooltip(useHTML = TRUE, valueDecimals = reac_map$valueDecimals, valueSuffix = reac_map$valueSuffix) %>%
      highcharter::hc_legend(floating=TRUE,verticalAlign = "top", align= "right") %>%
      highcharter::hc_motion(
        enabled = TRUE,
        axisLabel = "year",
        startIndex = length(unique(as.character(reac_map$df_prov$date))),
        labels = unique(as.character(reac_map$df_prov$date)),
        series = 0,
        updateIterval = 50,
        magnet = list(
          round = "floor",
          step = 0.1
        )
      )
    
})


# map by region -----------------------------------------------------------

output$map_region <- highcharter::renderHighchart(
  reac_map$map_region
)



# map by province ---------------------------------------------------------



output$map_province <- highcharter::renderHighchart(
  reac_map$map_province
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
  
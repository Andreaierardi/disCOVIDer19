 
# map section -------------------------------------------------------------
  regions <- get_regionTS()
  
  data <- map_df(names(regions), function(x) {
    casi <- regions[[x]] %>% select(totale_casi) %>% tail(1) %>% pull()
    
    data_frame(region=x,cases=casi)
  })
  
  data <- data %>%
    mutate(region=ifelse(region%in%c("P.A. Trento", "P.A. Bolzano"), "Trentino-Alto Adige", region)) %>%
    group_by(region) %>%
    summarise(cases = sum(cases)) %>%
    ungroup() %>%
    mutate(region=ifelse(region=="Emilia Romagna", "Emilia-Romagna", region)) %>% 
    mutate(region=ifelse(region=="Friuli Venezia Giulia", "Friuli-Venezia Giulia", region))
  

# map ---------------------------------------------------------------------
  
  map <- "https://raw.githubusercontent.com/stefanocudini/leaflet-geojson-selector/master/examples/italy-regions.json" %>% 
    GET() %>% 
    content() %>% 
    jsonlite::fromJSON(simplifyVector = FALSE)
  
  dfita1 <-  map$features %>% 
    map_df(function(x){
      as_data_frame(x$properties)
    })
  
  pc_data <- get_regionTS()
  
  names(pc_data) <- tolower(names(pc_data))
  
  pc_df <- map_df(names(pc_data), function(x){
    casi <- tail(pc_data[[x]],1)$totale_casi
    data_frame(name=x,cases=casi)
  })
  
  pc_df$name
  
  pc_df <- pc_df %>%
    filter(!name%in%c("friuli v. g. ")) %>%
    mutate(name=ifelse(name%in%c("trento","bolzano","p.a. trento","p.a. bolzano"),
                       "trentino-alto adige/sudtirol",name)) %>%
    group_by(name) %>%
    summarise(cases=sum(cases)) %>%
    mutate(name=ifelse(name=="emilia romagna","emilia-romagna",name))
  
  
  
  a <- pc_df$name
  
  b <- dfita1$name
  
  setdiff(b,a)
  
  dfita1 <- dfita1 %>%
    left_join(pc_df)
  
  output$map_region <- highcharter::renderHighchart(
    highcharter::highchart(type = "map") %>% 
      highcharter::hc_add_series_map(map = map, df = dfita1,
                                     joinBy = "id", value = "cases", name="total cases") %>%
      highcharter::hc_colorAxis(
        stops = highcharter::color_stops(4,c("#FFE4B5","#FFA500","#FF4500","#cc0000")))
  )
  

# map by province ---------------------------------------------------------

  url <- "http://code.highcharts.com/mapdata/countries/it/it-all.geo.json"
  tmpfile <- tempfile(fileext = ".json")
  download.file(url, tmpfile)
  
  ita <- readLines(tmpfile)
  
  ita <- gsub(".* = ", "", ita)
  ita <- jsonlite::fromJSON(ita, simplifyVector = FALSE)
  
  x <- ita$features[[1]]
  x$properties
  
  dfita2 <-  ita$features %>% 
    map_df(function(x){
      data_frame(hasc = x$properties$hasc, name = x$properties$name)
    }) %>%  # extract the keys
    mutate(random = runif(nrow(.))) # create random value
  
  head(dfita2)

# integrating civil protection data
  prov_TS <- get_provTS()
  
clean_prov <- map_df(names(prov_TS), function(x) {
  tail(prov_TS[[x]],1)$totale_casi
  data_frame(
    name=x,
    cases=tail(prov_TS[[x]],1)$totale_casi
  )
})

# make names consistent
clean_prov %>%
  filter(str_detect(name, "\\Aoste"))

clean_prov <- clean_prov %>%
  mutate(name = ifelse(name=="Massa Carrara","Massa-Carrara",name)) %>%
  mutate(name = ifelse(name=="Reggio nell'Emilia","Reggio Emilia",name)) %>% 
  mutate(name = ifelse(name=="Bolzano","Bozen",name)) %>%
  mutate(name = ifelse(name=="Aosta","Aoste",name)) %>% 
  mutate(name = ifelse(name=="Monza e della Brianza","Monza e Brianza",name)) %>%
  mutate(name = ifelse(name=="Reggio di Calabria","Reggio Calabria",name)) %>%
  mutate(name = ifelse(name=="Torino","Turin",name)) %>%
  mutate(name = ifelse(name=="Oristano","Oristrano",name)) %>%
  mutate(name = ifelse(name=="Barletta-Andria-Trani","Barletta-Andria Trani",name))

dfita2 <- dfita2 %>% left_join(clean_prov)
  
output$map_province <- highcharter::renderHighchart(
  highcharter::highchart(type = "map") %>% 
    highcharter::hc_add_series_map(map = ita, df = dfita2, 
                                   joinBy = "hasc", value = "cases", name="total cases") %>%
    highcharter::hc_colorAxis(
      stops = highcharter::color_stops(4,c("#FFE4B5","#FFA500","#FF4500","#cc0000")))
)


# tabbox ------------------------------------------------------------------

  output$tabset1Selected <- renderText({
    input$tabset1
  })
  
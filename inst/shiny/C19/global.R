`%>%` = magrittr::`%>%`
load(file = "italy_pop.rda")
load(file = "italy_ext.rda")
load(file = "intensivecare_cap.rda")

#================================
#====== GENERAL DATA ACQUISITION =====
countryTS = covid19:::get_countryTS()
regionTS = covid19:::get_regionTS()
provTS = covid19:::get_provTS()
country_growth = covid19:::get_country_growth()



readfile = as.data.frame(intensivecare_cap)
colnames(readfile) = c("region","capacity")

#  readfile$region = split(as.character(readfile$region)," ")
readfile = readfile[order(readfile$region),]

sortedreg = regionTS[order(names(regionTS))]

newdf = data.frame()
for(i in 1:length(readfile$region))
{
  reg = readfile$region[i]
  date = sortedreg[[reg]]$data
  intensive = sortedreg[[readfile$region[i]]]$terapia_intensiva
  perc = intensive /readfile$capacity[i] * 100
  perc = round(perc ,digits = 2)
  v = data.frame(date, intensive, readfile$capacity[i],perc,readfile$region[i])
  
  names(v) = c("data","occupancy","capacity","perc","region")
  newdf <- rbind(newdf, v)
}
colnames(newdf) = c("data","occupancy","capacity","perc","region")

intensivecare_capacity = newdf


N <- nrow(countryTS)



#===  Global function to check error 
checkExp <- function(expression, message) {
  
  validate(
    
    need( try(expression), message)
  )
  
  return(expression)
  
}

#=== Function to pass from log e to log 10
toLog10<- function(num)
{
  return(log(num)/log(10))
}

#================================

#================================
#====== MODULE 1 - HOME ====== 

# --- region ---
map <- "https://raw.githubusercontent.com/stefanocudini/leaflet-geojson-selector/master/examples/italy-regions.json" %>% 
  httr::GET() %>% 
  httr::content() %>% 
  jsonlite::fromJSON(simplifyVector = FALSE)

dfita1 <-  map$features %>% 
  purrr::map_df(function(x){
    dplyr::as_data_frame(x$properties)
  })

pc_data <- regionTS

names(pc_data) <- tolower(names(pc_data))

pc_df <- purrr::map_df(names(pc_data), function(x){
  casi <- tail(pc_data[[x]],1)$totale_casi
  dplyr::data_frame(name=x,cases=casi)
})

pc_df$name

# integrate population info
pop_region <- italy_pop$region %>% 
  dplyr::rename(name=territorio,pop=valore) %>%
  dplyr::mutate(name=tolower(name))

territory_region <- italy_ext$region %>%
  dplyr::rename(name=territorio,ext=valore) %>% 
  dplyr::mutate(name=tolower(name))


pc_df <- pc_df %>%
  dplyr::left_join(pop_region) %>% 
  dplyr::left_join(territory_region) %>%
  dplyr::filter(!name%in%c("friuli v. g. ")) %>%
  dplyr::mutate(name=ifelse(name%in%c("trento","bolzano","p.a. trento","p.a. bolzano"),
                            "trentino-alto adige/sudtirol",name)) %>%
  dplyr::group_by(name) %>%
  dplyr::summarise(cases=sum(cases), 
                   pop=sum(pop),
                   ext=sum(ext)) %>%
  dplyr::mutate(name=ifelse(name=="emilia romagna","emilia-romagna",name))



a <- pc_df$name

b <- dfita1$name

setdiff(b,a)

dfita1 <- dfita1 %>%
  dplyr::left_join(pc_df) %>%
  dplyr::ungroup() %>% 
  dplyr::mutate(percentage=(cases/pop)*100) %>%
  dplyr::mutate(density=(cases/ext)*1000) %>%
  dplyr::rename(absolute=cases) %>%
  dplyr::mutate(percentage = round(percentage,2)) %>%
  dplyr::mutate(density = round(density, 2))




# --- province ---

clean_prov <- purrr::map_df(names(provTS), function(x) {
  tail(provTS[[x]],1)$totale_casi
  dplyr::data_frame(
    name=x,
    cases=tail(provTS[[x]],1)$totale_casi
  )
})


url <- "http://code.highcharts.com/mapdata/countries/it/it-all.geo.json"
tmpfile <- tempfile(fileext = ".json")
utils::download.file(url, tmpfile)

ita <- readLines(tmpfile)

ita <- gsub(".* = ", "", ita)
ita <- jsonlite::fromJSON(ita, simplifyVector = FALSE)

x <- ita$features[[1]]
x$properties

dfita2 <-  ita$features %>% 
  purrr::map_df(function(x){
    dplyr::data_frame(hasc = x$properties$hasc, name = x$properties$name)
  }) %>%  # extract the keys
  dplyr::mutate(random = runif(nrow(.))) # create random value

head(dfita2)




# add population
pop_prov <- dplyr::rename(italy_pop$province, name=territorio,pop=valore)

# add territory
territory_prov <- italy_ext$province %>%
  dplyr::rename(name=territorio,ext=valore)


# make names consistent

clean_prov <- clean_prov %>%
  dplyr::left_join(pop_prov) %>% 
  dplyr::left_join(territory_prov) %>%
  dplyr::mutate(name = ifelse(name=="Massa Carrara","Massa-Carrara",name)) %>%
  dplyr::mutate(name = ifelse(name=="Reggio nell'Emilia","Reggio Emilia",name)) %>% 
  dplyr::mutate(name = ifelse(name=="Bolzano","Bozen",name)) %>%
  dplyr::mutate(name = ifelse(name=="Aosta","Aoste",name)) %>% 
  dplyr::mutate(name = ifelse(name=="Monza e della Brianza","Monza e Brianza",name)) %>%
  dplyr::mutate(name = ifelse(name=="Reggio di Calabria","Reggio Calabria",name)) %>%
  dplyr::mutate(name = ifelse(name=="Torino","Turin",name)) %>%
  dplyr::mutate(name = ifelse(name=="Oristano","Oristrano",name)) %>%
  dplyr::mutate(name = ifelse(name=="Barletta-Andria-Trani","Barletta-Andria Trani",name))

dfita2 <- dfita2 %>%
  dplyr::left_join(clean_prov) %>% 
  dplyr::ungroup() %>% 
  dplyr::mutate(percentage=(cases/pop)*100) %>%
  dplyr::mutate(density=(cases/ext)*1000) %>%
  dplyr::rename(absolute=cases)



#================================


#================================
#====== MODULE 2 - INSPECTION ====== 




# plot growth monitoring --------------------------------------------------------------------
out_growth <- country_growth

growth <- data.frame(date=countryTS$Italy$data,
                     growth=out_growth$growth)

growth_xts <- xts::xts(growth[,-1], order.by=growth[,1])

growth_change <- data.frame(date=countryTS$Italy$data,
                            growth=out_growth$growth_change)

growth_change_xts <- xts::xts(growth_change[,-1], order.by=growth_change[,1])

hc <- highcharter::highchart(type = "stock") %>% 
  highcharter::hc_title(text = "% growth and growth change of total cases") %>%
  highcharter::hc_add_series(growth_xts, name="growth", color = "red", type = "spline") %>% 
  highcharter::hc_add_series(growth_change_xts, name="growth_change", color = "orange", type = "spline")


# tamponi graph -----------------------------------------------------------
tamp_data <- tibble::tibble(
  data=countryTS$Italy$data,
  tamponi=countryTS$Italy$tamponi,
  totale_casi=countryTS$Italy$totale_casi
) %>% 
  dplyr::mutate(casi_giornalieri=totale_casi-dplyr::lag(totale_casi)) %>%
  dplyr::mutate(casi_giornalieri=ifelse(data==as.Date("2020-02-24"),totale_casi,casi_giornalieri)) %>% 
  dplyr::mutate(tamponi_giornalieri=tamponi-dplyr::lag(tamponi)) %>%
  dplyr::mutate(tamponi_giornalieri=ifelse(data==as.Date("2020-02-24"),tamponi,tamponi_giornalieri)) %>%
  dplyr::mutate(share_infected_discovered = casi_giornalieri/tamponi_giornalieri) %>%
  dplyr::select(data,casi_giornalieri,tamponi_giornalieri,share_infected_discovered) %>%
  dplyr::rename(daily_cases=casi_giornalieri,daily_tests=tamponi_giornalieri,date=data) %>%
  dplyr::mutate(share_infected_discovered=round(share_infected_discovered,2))

tamp_data_1 <- tamp_data %>% dplyr::select(1:3) %>%
  tidyr::gather(key="key",value="value",-date)

#================================




#================================
#====== MODULE 3 - ANALYSIS ====== 

# Inital and final dates of samples
init_date <- min(countryTS$Italy$data)

init_date_arima = init_date

fin_date <- max(countryTS$Italy$data)

# Total population sizes in 2020 winter
country_tot_pop <- 6.048e+07
region_tot_pop <- NULL

countryNames <- names(countryTS)
regNames <- as.character(sort(names(regionTS)))
provNames <- as.character(sort(names(provTS)))

# Time horizon of all graphs
if(nrow(countryTS$Italy) > 30) {
  days <- c(1:(nrow(countryTS$Italy)+20) )
} else {
  days <- c(1:50)
}

# Association of provinces to regions
regAndProv <- data.frame("province" = provNames, "region" = NA, stringsAsFactors = FALSE)
for(prov in provNames) {
  regAndProv[regAndProv$province == prov, "region"] <- as.character(provTS[[prov]]$denominazione_regione[1])
}

#================================

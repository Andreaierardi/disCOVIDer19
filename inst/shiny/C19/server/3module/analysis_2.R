ent_df <- data.frame()
for (i in names(regionTS)) {
  ent_df <- regionTS[[i]] %>%
    dplyr::select(denominazione_regione, data, totale_positivi) %>% 
    dplyr::rename(name = denominazione_regione, positivi=totale_positivi) %>%
    dplyr::bind_rows(ent_df)
}

Vettore_dati <- ent_df %>%
  dplyr::mutate(name=tolower(name)) %>% 
  dplyr::group_by(name, year = lubridate::year(data), week = lubridate::week(data)) %>% 
  dplyr::summarise_if(is.numeric, mean) %>% 
  dplyr::left_join(pop_region) %>%
  dplyr::mutate(week = ifelse(week %in% c(1:9), paste0(0,week), week)) %>%
  dplyr::mutate(date = paste0('X_', year, '_',week)) %>%
  # solve the problem of the logarithm with 0.001 instead of 0
  dplyr::mutate(positivi = ifelse(positivi==0,0.001,positivi)) %>% 
  dplyr::ungroup() %>%
  dplyr::select(-year,-week) %>%
  tidyr::spread(date,positivi) %>%
  dplyr::rename(region=name)



# 13 in the other code (ncol - 1)
n_col <- ncol(Vettore_dati) - 2

# 21 like in the other code (because number of regions)
n_row <- nrow(Vettore_dati)

# 11 max_col
max_col <- ncol(Vettore_dati) - 2


H_R<-data.frame(Vettore_dati[0,3:n_col])
H_R_C<-data.frame(Vettore_dati[0,3:n_col])
H<-data.frame(matrix(0, ncol = 2, nrow = n_col))
H_C<-data.frame(matrix(0, ncol = 2, nrow = n_col))
for (j in 1:max_col) {
  for (i in 1:n_row) {
    H_R[i,j]<-log(Vettore_dati[i,j+2]/Vettore_dati[i,2])*(-Vettore_dati[i,j+2]/Vettore_dati[i,2])
    H_R_C[i,j]<-log(Vettore_dati[i,j+2]/Vettore_dati[i,2])*(-Vettore_dati[i,j+2]/Vettore_dati[i,2])*(Vettore_dati[i,2]/sum(Vettore_dati[,2]))
  }
  H[j,2]<-sum(H_R[,j])
  H_C[j,2]<-sum(H_R_C[,j])
  H[j,1]<-j
  H_C[j,1]<-j
  #print(H)
}
colnames(H)<-c("Week","Entropy")
colnames(H_C)<-c("Week","C.Entropy")

output$c_entropy_plot <- highcharter::renderHighchart(
  highcharter::hchart(H_C, "line",
    highcharter::hcaes(x = countryTS$Italy$data[seq(1,N,7)], y = C.Entropy)) %>% 
    highcharter::hc_title(
      text = "Calculation of the <i>entropy index</i> since <b>Feb 2020</b> by week"
    ) %>% 
    highcharter::hc_xAxis(title = list(text = "Week"))
)

output$entropy_plot <- highcharter::renderHighchart(
  highcharter::hchart(H, "line", color = 'red',
                      highcharter::hcaes(x = countryTS$Italy$data[seq(1,N,7)], y = Entropy)) %>% 
    highcharter::hc_title(
      text = "Calculation of the <i>entropy index</i> since <b>Feb 2020</b> by week"
    ) %>%
    highcharter::hc_xAxis(title = list(text = "Week"))
)

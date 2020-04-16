#' Data manipulation
#'
#' @export
get_country_growth <- function() {

  country_g <- countryTS$Italy %>%
    dplyr::select(data, totale_casi) %>%
    dplyr::mutate(region="--- ALL ---", province="--- ALL ---") %>%
    dplyr::mutate(totale_casi=as.numeric(totale_casi))

  region_g <- purrr::map_df(names(regionTS), function(x){
    regionTS[[x]] %>%
      dplyr::select(data, totale_casi) %>%
      dplyr::mutate(region=x, province="--- ALL ---") %>%
      dplyr::mutate(totale_casi=as.numeric(totale_casi))
  })

  province_g <- purrr::map_df(names(provTS), function(x) {
    provTS[[x]] %>%
      dplyr::select(data, totale_casi, denominazione_regione) %>%
      dplyr::rename(region=denominazione_regione) %>%
      dplyr::mutate(province=x) %>%
      dplyr::mutate(totale_casi=as.numeric(totale_casi))
  })

  country_g %>%
    dplyr::bind_rows(region_g) %>%
    dplyr::bind_rows(province_g) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(region, province) %>%
    dplyr::mutate(growth=round(((totale_casi-dplyr::lag(totale_casi))/dplyr::lag(totale_casi))*100,2) ) %>%
    dplyr::mutate(growth_change=round(growth-dplyr::lag(growth),2) ) %>%
    dplyr::mutate(growth=ifelse(growth %in% c("NaN","Inf","-Inf"), NA, growth)) %>%
    dplyr::mutate(growth_change=ifelse(growth_change %in% c("NaN","Inf","-Inf"), NA, growth_change))

}

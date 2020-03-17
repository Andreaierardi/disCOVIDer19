library(plotly)
library(shinydashboard)
library(shinydashboardPlus)

source("get_provTS.R")
source("get_regionTS.R")
source("get_countryTS.R")
source("get_intesivecare_cap.R")
source("exe_fit.R")

## ui.R ##
ui <- dashboardPagePlus(skin = "red", title = "Covid-19",
                        
                        dashboardHeader(title = img(src = "coronavirus_white.png")),
                        
                        dashboardSidebar(collapsed = T,
                                         sidebarMenuOutput("menu")
                        ),
                        
               
                        
                        dashboardBody(
                          
                          #js
                          shinyjs::useShinyjs(),
                          
                          #css
                          source(file.path("ui/global", "css.R"),  local = TRUE)$value,
                          
                          #waiter
                          waiter::use_waiter(),
                          waiter::waiter_show_on_load(html = waiter::spin_rotating_plane()), # will show on load
                          
                          
                          # tabs --------------------------------------------------------------------
                          tabItems(
                            
                            # tab 1 -------------------------------------------------------------------
                            source(file.path("ui/tabs", "1.tab_home.R"),  local = TRUE)$value,
                            
                            
                            # tab 2 -------------------------------------------------------------------
                            source(file.path("ui/tabs", "2.tab_inspection.R"),  local = TRUE)$value,
                            
                            
                            # tab 3 -------------------------------------------------------------------
                            source(file.path("ui/tabs", "3.tab_analysis.R"),  local = TRUE)$value,
                            
                            # tab 4 -------------------------------------------------------------------
                            source(file.path("ui/tabs", "4.tab_conclusion.R"),  local = TRUE)$value
                            
                            
                          )
                        )
)


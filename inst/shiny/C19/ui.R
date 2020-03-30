
## ui.R ##


ui <-
  # fluidPage(
  
  #  HTML('<meta name="viewport" content="width=1024">'),
  shinydashboardPlus::dashboardPagePlus( skin = "red", title = "DisCOVIDer19",
                                         
                                         shinydashboard::dashboardHeader(title = img(src = "coronavirus_white.png","DisCOVIDer19")),
                                         
                                         
                                         shinydashboard::dashboardSidebar(collapsed = T,
                                                                          shinydashboard::sidebarMenuOutput("menu")
                                         ),
                                         shinydashboard::dashboardBody(
                                           
                                           tags$head( tags$meta(name = "viewport", content = "content=width=device-width, initial-scale=0.55")),
                                           
                                           #js
                                           shinyjs::useShinyjs(),
                                           
                                           #css
                                           source(file.path("ui/global", "css.R"),  local = TRUE)$value,
                                           
                                           #waiter
                                           waiter::use_waiter(),
                                           waiter::waiter_show_on_load(html = waiter::spin_rotating_plane()), # will show on load
                                           
                                           
                                           
                                           shinyalert::useShinyalert(),  # Set up shinyalert
                                           # tabs --------------------------------------------------------------------
                                           shinydashboard::tabItems(
                                             
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


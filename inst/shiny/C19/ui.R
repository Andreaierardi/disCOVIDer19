
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
                                           tags$head( tags$meta( name="google-site-verification" ,content="uqldthSbvNv8p4RPxzlwihRq2OXixrauM9a_G-OKXB4")),
                                           tags$head(includeHTML(("www/google-analytics.html"))),
                                           tags$head( tags$meta(name = "viewport", content = "content=width=device-width, initial-scale=0.55")),
                                           #tags$head( tags$meta(name = "viewport", content = "content=width=device-width, initial-scale=1")),
                                           
                                           # tags$head(includeScript("google-analytics.js")),
                                           tags$head(HTML(
                                             "<script>
      (function(i,s,o,g,r,a,m){
        i['GoogleAnalyticsObject']=r;i[r]=i[r]||
        function(){
          (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();
          a=s.createElement(o), m=s.getElementsByTagName(o)[0];
          a.async=1;
          a.src=g;m.parentNode.insertBefore(a,m)
        })
      (window, document, 'script',
        '//www.google-analytics.com/analytics.js','ga');
      
        ga('create', 'UA-162966248-1', 'auto');
        ga('send', 'pageview');
      
      </script>"
                                           ),
                                           
                                           ),
                                           
                                           #js
                                           shinyjs::useShinyjs(),
                                           
                                           #css
                                           source(file.path("ui/global", "css.R"),  local = TRUE)$value,
                                           
                                           tags$style(HTML("body
                                                          {
                                                            font-size:150%;
                                                          }
                                                          
                                                          @media only screen and (max-width: 600px) {
                                                             body {
                                                                font-size:200%;
                                                             }
                                                             @media only screen and (min-width: 600px) {
                                                             body
                                                           {
                                                           font-size:200%;
                                                           }
                                                             } 
                                                          ")),
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


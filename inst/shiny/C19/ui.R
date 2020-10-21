
## ui.R ##


ui <-
  # fluidPage(
  
  #  HTML('<meta name="viewport" content="width=1024">'),
  shinydashboardPlus::dashboardPagePlus( skin = "red", title = "DisCOVIDer19",
                                         
                                         shinydashboard::dashboardHeader(title = img(src = "coronavirus_white.png","DisCOVIDer19")),
                                         
                                         
                                         shinydashboard::dashboardSidebar(collapsed = T,
                                                                          shinydashboard::sidebarMenuOutput("menu"),
                                                                          tags$head(tags$style(HTML('.content-wrapper {background-image:url(\'data:image/jpeg;base64,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\');}')))
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
                                             
                                             # tab 0 -------------------------------------------------------------------
                                             source(file.path("ui/tabs", "0.tab_home.R"),  local = TRUE)$value,
                                             
                                             
                                             # tab 1 -------------------------------------------------------------------
                                             source(file.path("ui/tabs", "1.tab_map.R"),  local = TRUE)$value,
                                             
                                             
                                             # tab 2 -------------------------------------------------------------------
                                             source(file.path("ui/tabs", "2.tab_inspection.R"),  local = TRUE)$value,
                                             
                                             
                                             # tab 3 -------------------------------------------------------------------
                                             source(file.path("ui/tabs", "3.tab_analysis.R"),  local = TRUE)$value,
                                             
                                             # tab 3 section 2 ---------------------------------------------------------
                                             source(file.path("ui/tabs", "3.tab_analysis_2.R"),  local = TRUE)$value,
                                             
                                             # tab 4 -------------------------------------------------------------------
                                             source(file.path("ui/tabs", "4.tab_conclusion.R"),  local = TRUE)$value
                                             
                                             
                                           )
                                         )
  )


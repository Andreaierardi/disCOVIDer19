# sidebard ----------------------------------------------------------------
output$menu <-   shinydashboard::renderMenu({
  shinydashboard::sidebarMenu(id="tabs",
                              tags$div(class = "hide", checked = NA,
            shinydashboard::menuItem("", tabName = "home")),
            shinydashboard::menuItem("Home", tabName = "home", icon=icon("home")),
            shinydashboard::menuItem("Inspection", tabName = "inspection", icon=icon("search"),
                                     shinydashboard::menuSubItem("Section 1", tabName = "map"),
                                     shinydashboard::menuSubItem("Secion 2", tabName = "tab_2")
            ),
            shinydashboard::menuItem("Analysis", tabName = "tab_3_all", icon=icon("chart-line"),
                                     shinydashboard::menuSubItem("Section 1", tabName = "tab_3"),
                                     shinydashboard::menuSubItem("Secion 2", tabName = "tab_3_2")
                                     ),
            shinydashboard::menuItem("Documentation", tabName = "tab_4", icon=icon("calendar-check"))
  )
})

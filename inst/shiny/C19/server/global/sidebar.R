# sidebard ----------------------------------------------------------------
output$menu <-   shinydashboard::renderMenu({
  shinydashboard::sidebarMenu(id="tabs",
            shinydashboard::menuItem("Home", tabName = "tab_1", icon=icon("home")),
            shinydashboard::menuItem("Inspection", tabName = "tab_2", icon=icon("search")),
            shinydashboard::menuItem("Analysis", tabName = "tab_3", icon=icon("chart-line")),
            shinydashboard::menuItem("Conclusion", tabName = "tab_4", icon=icon("calendar-check"))
  )
})

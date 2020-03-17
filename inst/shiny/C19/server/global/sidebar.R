# sidebard ----------------------------------------------------------------
  output$menu <- renderMenu({
    sidebarMenu(id="tabs",
                menuItem("Home", tabName = "tab_1", icon=icon("home")),
                menuItem("Inspection", tabName = "tab_2", icon=icon("search")),
                menuItem("Analysis", tabName = "tab_3", icon=icon("chart-line")),
                menuItem("Conclusion", tabName = "tab_4", icon=icon("calendar-check"))
    )
  })
  
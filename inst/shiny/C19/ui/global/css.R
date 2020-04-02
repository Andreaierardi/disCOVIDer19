#js
shinyjs::useShinyjs()

# css
tags$head(
  tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
  tags$link(rel = "shortcut icon",
            href = "coronavirus_black.png"),
  #tags$script(src="https://code.jquery.com/jquery-3.4.1.slim.min.js",integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n", crossorigin="anonymous"),
  tags$script(src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" ,integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo", crossorigin="anonymous" ),
  tags$script(src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js", integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" ,crossorigin="anonymous")
  
)


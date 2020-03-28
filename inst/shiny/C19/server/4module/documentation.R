output$downloadDocument <- downloadHandler(
  filename <- "documentation_29032020.pdf",
  
  
  content <- function(file) {
    file.copy("www/documentation_29032020.pdf", file)
  },
)
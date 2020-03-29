output$downloadDocument <- downloadHandler(
  filename <- "documentation_29032020.pdf",
  
  
  content <- function(file) {
    file.copy("www/documentation_29032020.pdf", file)
  },
)





tags$iframe(style="height:600px; width:100%", src="")

output$pdfview <- renderText({
  return(paste('<iframe style="height:600px; width:100%" src="documentation_29032020.pdf"></iframe>', sep = ""))
})
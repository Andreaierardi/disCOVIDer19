output$downloadDocument <- downloadHandler(
  filename <- "disCOVIDer19_documentation.pdf",
  
  
  content <- function(file) {
    file.copy(paste0("www/",filename), file)
  },
)





tags$iframe(style="height:600px; width:100%", src="")

output$pdfview <- renderText({
  return(paste('<iframe style="height:600px; width:100%" src="',filename,'"></iframe>', sep = ""))
})

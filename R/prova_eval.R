provaa <- function(bool) {
  a <- 40
  b <- expression(a)
  if(TRUE)
    paste("Risultato:", ifelse(bool, eval(b), ""), " ciao")
}

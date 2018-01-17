#' FunPlotBar
#' 
#' The base graphics verion of the `eulerr` plot - was
#' beautiful, but not easy to interpret. I might do a version of it later 
#' to prove a point, but here is the real one: barplot
#' 
#' @df  - output of FunTablePrep
#' 
#' @pal - palate
#' 


FunPlotBar <- function(x, pal){
  par(mar = c(2, 2, 4, 0)+0.2,
      xpd = TRUE)
  # extract the colours we need from the pal
  pal <- pal[as.numeric(rownames(x[[1]]))]
  # plot 
  barplot(x[[1]], col = pal,
          axes = FALSE)
  
  # add gridlines
  for ( l in seq(0, 1, 0.2)){
    abline(h = l, col = "gray", lty = 5)
  }
  
  # plot overlay 
  barplot(x[[1]], col = pal,
          axes = FALSE,
          add = TRUE)
  # title
  mtext( x[[2]], 
         line = 1)
  
  dev.copy2eps(file=paste0("figures/",x[[2]],".eps"), height=4.5, width=6)
}




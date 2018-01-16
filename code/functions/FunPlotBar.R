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
  par(mar = c(2, 2, 2, 0)+0.2)
  # extract the colours we need from the pal
  pal <- pal[as.numeric(rownames(x[[1]]))]
  # plot 
  barplot(x[[1]], col = pal,
          axes = FALSE)
  axis(2, las = 2)
  # title
  mtext( x[[2]], 
        line = 1)
  dev.copy2eps(file=paste0("figures/",x[[2]],".eps"), height=5, width=6)
}




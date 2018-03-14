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
  # extract the colours we need from the pal
  pal <- pal[as.numeric(rownames(x[[1]]))]
  height <- (38.5-1.2)/30*6/(29.2/15)
  postscript(file=paste0("figures/",x[[2]],".eps"),
             horiz=FALSE,onefile=FALSE,width=6,height=height,paper="special") 
  par(mar = c(2, 4, 0, 0)+0.2,
      xpd = TRUE)
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
  rect(-0.2, 0.18, 0.13, 0.82, col = "white", border = "white")
  # title
  mtext( x[[2]], side = 2, 
         line = 1)
  dev.off()
}



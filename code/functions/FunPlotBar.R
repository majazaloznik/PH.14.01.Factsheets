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


x <- readRDS("data/processed/SNIR70DT.rds")

  
  barplot(df, col = rgb(pal$RGB), border = rgb(pal$RGB))
  # title
  mtext(paste(catalog$country[i], catalog$year[i], sep = " - "), 
        line = 2)
}


#' FunPlotBar
#' 
#' A base graphics verion of the `eulerr` plot - because I only 
#' have two circles intersecting I want the axis to remain constant
#' but eulerr has a stochastic element in the algorithm.
#' 
#' @i the row in the catalog for the survey
#' 
#' @col1 the colour for the wives' circle in rgb format with alpha!
#' @col1.b the colour of the wives' circle border
#' 
#' @col2 the colour for the husbands' circle in rgb format with alpha!
#' @col2.b the colour of the husbands' circle border
#' 
#' the circle drawing function from `plotrix` takes care of the aspect ratio 
#' So it changes the y limits depending on the output device




FunPlotBar <- function(i, pal) {
  df <- readRDS(catalog$final.rds[i])
  pt <- prop.table(xtabs(df$weight ~ df$var + df$region), 2)
  barplot(pt[c(1,3,2,4), ], col = rgb(pal$RGB), border = rgb(pal$RGB))
  # title
  mtext(paste(catalog$country[i], catalog$year[i], sep = " - "), 
        line = 2)
}


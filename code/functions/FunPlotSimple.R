#' FunPlotBase
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


FunPlotBase <- function(i, col1, col1.b, col2, col2.b) {
  df <- readRDS(catalog$final.rds[i])
  pt <- prop.table(xtabs(df$weight ~ df$var + df$region), 2)
  fit <-eulerr::euler(c(
        "wife-urban" = pt[1, 1],
        "husband-urban" = pt[2, 1],
        "wife-urban&husband-urban" = pt[3, 1],
        "wife-rural" = pt[1, 2],
        "husband-rural" = pt[2, 2],
        "wife-rural&husband-rural" = pt[3, 2]))
  f <- fit$coefficients
  dist.u <- ((f[1, 1] - f[2, 1]) ^ 2 + (f[1, 2] - f[2, 2]) ^ 2) ^ 0.5
  dist.r <- ((f[3, 1] - f[4, 1]) ^ 2 + (f[3, 2] - f[4, 2]) ^ 2) ^ 0.5
  
  # plot empty plot 
  plot(1, 
    xlim = c(-1.5, 1.5),
    ylim = c(-1, 1),
    type = "n",
    bty = "n",
    ylab = "",
    xlab = "",
    axes = FALSE )
  
  # title
  mtext(paste(catalog$country[i], catalog$year[i], sep = " - "))
  # rural wives
  plotrix::draw.circle(-0.7, 0, f[3, 3], 
              col = col1,
              border = col1.b)
  # rural husbands
  plotrix::draw.circle(-0.7, dist.r, f[4, 3],
              col = col2, 
              border = col2.b)
  # urban wives
  plotrix::draw.circle(0.7, 0, f[1, 3], 
              col = col1, 
              border = col1.b)
  # urban husbands
  plotrix::draw.circle(0.7, dist.u, f[2, 3],
              col = col2,
              border = col2.b)
}


FunPlotBar <- function(i, pal) {
  df <- readRDS(catalog$final.rds[i])
  pt <- prop.table(xtabs(df$weight ~ df$var + df$region), 2)
  barplot(pt[c(1,3,2,4), ], col = rgb(pal$RGB), border = rgb(pal$RGB))
  # title
  mtext(paste(catalog$country[i], catalog$year[i], sep = " - "), 
        line = 2)
}

FunPlotSimple <- function(i){
  df <- readRDS(catalog$final.rds[i])
  pt <- prop.table(xtabs(df$weight ~ df$var + df$region), 2)
  fit1 <- eulerr::euler(c("wife-urban" = pt[1,1], "husband-urban" = pt[2,1], "wife-urban&husband-urban" = pt[3,1],
                  "wife-rural" = pt[1,2], "husband-rural" = pt[2,2], "wife-rural&husband-rural" = pt[3,2]))
  plot(fit1)
}


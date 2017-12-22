###############################################################################
##  PLOTTING      #############################################################
###############################################################################
## 0. Preliminaries  ##########################################################
## 1. Plotting ################################################################
###############################################################################
## 0. Preliminaries  ##########################################################
library(eulerr)
library(plotrix) # for circles
options(stringsAsFactors = FALSE)
catalog <- read.csv("data/processed/catalog.final.csv")
source("code/functions/FunPlotSimple.R")
.oldpar <- par()
## 0.1 clean slate ############################################################


# # plot in base
FunPlotBase <- function(i) {
  col1 <- rgb(121, 177, 216, 100, maxColorValue = 255)
  col1.b <- rgb(121, 177, 216, 255, maxColorValue = 255)
  col2 <- rgb(249, 209, 89, 100, maxColorValue = 255)
  col2.b <- rgb(249, 209, 89, 255, maxColorValue = 255)
  df <- readRDS(catalog$final.rds[i])
  pt <- prop.table(xtabs(df$weight ~ df$var + df$region), 2)
  fit <-
    euler(
      c(
        "wife-urban" = pt[1, 1],
        "husband-urban" = pt[2, 1],
        "wife-urban&husband-urban" = pt[3, 1],
        "wife-rural" = pt[1, 2],
        "husband-rural" = pt[2, 2],
        "wife-rural&husband-rural" = pt[3, 2]
      )
    )
  
  f <- fit$coefficients
  par(mar = c(1, 1, 1, 1))
  dist.u <- ((f[1, 1] - f[2, 1]) ^ 2 + (f[1, 2] - f[2, 2]) ^ 2) ^ 0.5
  dist.r <- ((f[3, 1] - f[4, 1]) ^ 2 + (f[3, 2] - f[4, 2]) ^ 2) ^ 0.5
  plot(
    1,
    xlim = c(-1.5, 1.5),
    ylim = c(-1, 1),
    type = "n",
    bty = "n",
    ylab = "",
    xlab = "",
    axes = FALSE
  )
  mtext(paste(catalog$country[i], catalog$year[i], sep = " - "))
  draw.circle(-0.7, 0, f[3, 3], col = col1,
              border = col1.b)
  draw.circle(
    -0.7,
    dist.r,
    f[4, 3],
    col = col2,
    border = col2.b
  )
  draw.circle(0.7, 0, f[1, 3], 
              col = col1, 
              border = col1.b)
  draw.circle(0.7,
              dist.u,
              f[2, 3],
              col = col2,
              border = col2.b)
}


## 1. Plotting ################################################################

cairo_ps("figures/test2.eps", width = 12, height = 12)
layout(matrix(c(1:12), nrow = 4))
for(i in 1:12){
FunPlotBase(i)
}
dev.off()

cairo_ps("figures/test1.eps")
FunPlotSimple(i)
dev.off()



i = 123

#
# prop.table(table(AFIR70$region, AFIR70$var)[,1:3], 1)
# barplot(t(as.matrix(prop.table(table(AZIR52$region, AZIR52$var)[,1:3], 1))))

###############################################################################
##  PLOTTING      #############################################################
###############################################################################
## 0. Preliminaries  ##########################################################
## 1. Plotting ################################################################
###############################################################################
## 0. Preliminaries  ##########################################################
library(dplyr)
options(stringsAsFactors = FALSE)
catalog <- read.csv("data/processed/catalog.final.csv")
source("code/functions/FunTablePrep.R")
source("code/functions/FunPlotBar.R")
.oldpar <- par()

## 0.1 clean slate ############################################################
# add new columns to catalogue to be updated during plotting

catalog$total.cases <- NA
catalog$valid.cases <- NA
catalog$wave <- NA
catalog$years.new <- NA
catalog$urban.wife <- NA
catalog$urban.husband <- NA
catalog$urban.both <- NA
catalog$urban.other <- NA
catalog$urban.missing <- NA
catalog$rural.wife <- NA
catalog$rural.husband <- NA
catalog$rural.both <- NA
catalog$rural.other <- NA
catalog$rural.missing <- NA

# prepare colour palate 
col1 = "goldenrod1"
col2 = "firebrick"
col3 = rgb(104, 176, 171, maxColorValue = 255)
col6 = rgb(105, 109, 125, maxColorValue = 255)

pal <- c(col1, col2, col3, NA, NA, col6, NA, NA, "white")


## 1. Plotting ################################################################
par(mar = c(2, 4, 0, 0)+0.2,
    xpd = TRUE)

# plot all the charts
for(i in 1:nrow(catalog)){
FunPlotBar(FunTablePrep(i), pal)
}

# extract catalog with data for reuse

final.data <- dplyr::select(catalog, country, years.new, phase, Region.Name, 
                         Sub.region.Name, Intermediate.Region.Name,
                         ISO.alpha3.Code, total.cases, valid.cases, 
                         urban.wife, urban.both, urban.husband, urban.other, urban.missing,
                         rural.wife, rural.both, rural.husband, rural.other, rural.missing)


write.csv(final.data, "data/processed/final.data.csv")

## 1.2. Plot ledge

ledge <- matrix(c(.3,.25, .17, .08, .1,
                  .25,.2, .2, .15, .1), nrow = 2, byrow = TRUE)
# plot 
barplot(t(ledge), col = pal[c(1,3,2,6,9)],
        axes = FALSE, names.arg = rep(NA,2))

# add gridlines
for ( l in seq(0, 1, 0.2)){
  abline(h = l, col = "gray", lty = 5)
}

# plot 
barplot(t(ledge), col = pal[c(1,3,2,6,9)],
        axes = FALSE, names.arg = 1:2, add = TRUE)
rect(-0.2, 0.35, 0.13, 0.65, col = "white", border = "white")
mtext( "XX", side = 2, 
       line = 1)
height = (38.5-1.2)/30*6/(29.2/15)
dev.copy2eps(file=paste0("figures/","ledge",".eps"), height=height*2, width=6)


## 1.2. Plot empty gridlines


# plot 
barplot(FunTablePrep(3)[[1]], col = c(NA, NA, NA, NA, NA),
        border = c(NA, NA, NA, NA, NA),
        axes = FALSE, names.arg = rep(NA, 2))

# add gridlines
for ( l in seq(0, 1, 0.2)){
  abline(h = l, col = "gray", lty = 5)
}
height = (38.5-1.2)/30*6/(29.2/15)
dev.copy2eps(file=paste0("figures/","gridlines",".eps"), height=height, width=6)


# this is old stuff, might get reused one day. 
# # colours for euler
# pal <- qualpalr::qualpal(n = 2, list(h = c(0, 180), s = c(0.4, 0.6), l = c(0.6, 0.85)))
# plot(pal)
# w1 <- pal$RGB[1,1]
# w2 <- pal$RGB[1,2]
# w3 <- pal$RGB[1,3]
# h1 <- pal$RGB[2,1]
# h2 <- pal$RGB[2,2]
# h3 <- pal$RGB[2,3]
# 
# alpha = 0.4
# col1 <- rgb(w1, w2, w3, alpha)
# col1.b <- rgb(1,1,1,0.7)
# col2 <- rgb(h1, h2, h3, alpha)
# col2.b <- rgb(1,1,1,0.7)
# 
# # plot euler diagrams
# cairo_ps("figures/test2.eps", width = 12, height = 12)
# layout(matrix(c(1:12), nrow = 4))
# par(mar = c(1, 1, 1, 1))
# for(i in 1:12){
#   FunPlotBase(i, col1, col1.b, col2, col2.b)
# }
# dev.off()
# par() <-.oldpar
# 
# 
# cairo_ps("figures/test1.eps")
# FunPlotSimple(i)
# dev.off()

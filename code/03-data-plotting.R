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
source("code/FunTablePrep.R")
source("code/FunPlotBar.R")
.oldpar <- par()

## 0.1 clean slate ############################################################
# add new columns to catalogue to be updated during plotting

catalog$total.cases <- NA
catalog$eligible.cases <- NA
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
# plot all the charts
for(i in 1:nrow(catalog)){
  FunPlotBar(FunTablePrep(i), pal)
}

# extract catalog with data for reuse

final.data <- dplyr::select(catalog, country, years.new, phase, Region.Name, 
                            Sub.region.Name, Intermediate.Region.Name,
                            ISO.alpha3.Code, total.cases, eligible.cases, 
                            urban.wife, urban.both, urban.husband, urban.other, urban.missing,
                            rural.wife, rural.both, rural.husband, rural.other, rural.missing)


write.csv(final.data, "results/human-readable/final.data.csv")

## 1.2. Plot ledge
height = (38.5-1.2)/30*6/(29.2/15)
postscript(file=paste0("figures/","ledge",".eps"),
           horiz=FALSE,onefile=FALSE,width=6,height=height*2,paper="special") 
par(mar = c(2, 4, 0, 0)+0.2,
    xpd = TRUE)
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
dev.off()

## 1.2. Plot empty gridlines
postscript(file=paste0("figures/","gridlines",".eps"),
           horiz=FALSE,onefile=FALSE,width=6,height=height,paper="special") 
par(mar = c(2, 4, 0, 0)+0.2,
    xpd = TRUE)
# plot 
barplot(FunTablePrep(1)[[1]], col = c(NA, NA, NA, NA, NA),
        border = c(NA, NA, NA, NA, NA),
        axes = FALSE, names.arg = rep(NA, 2))

# add gridlines
for ( l in seq(0, 1, 0.2)){
  abline(h = l, col = "gray", lty = 5)
}
dev.off()


###############################################################################
##  PLOTTING      #############################################################
###############################################################################
## 0. Preliminaries  ##########################################################
## 1. Plotting ################################################################
###############################################################################
## 0. Preliminaries  ##########################################################
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

# prepare colour palate 
col1 = rgb(200, 213, 185, maxColorValue = 255)
col3 = rgb(143, 192, 169, maxColorValue = 255)
col2 = rgb(104, 176, 171, maxColorValue = 255)
col6 = rgb(105, 109, 125, maxColorValue = 255)

pal <- c(col1, col2, col3, NA, NA, col6, NA, NA, "white")


## 1. Plotting ################################################################

# plot all the charts
for(i in 1:nrow(catalog)){
FunPlotBar(FunTablePrep(i), pal)
}

# extract catalog section for lookup to use with psfrag.
catalog$psfrag <- paste(catalog$country, 
                        "(", catalog$years.new,
                        ") -- $N_{unweighted} =", format(catalog$valid.cases,big.mark=",", trim=TRUE), "$")
psfrag <- cbind(catalog$wave, catalog$psfrag)
write.csv(psfrag, "data/processed/psfrag.csv")


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

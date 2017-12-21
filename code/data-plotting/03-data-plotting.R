###############################################################################
##  PLOTTING      #############################################################
###############################################################################
## 0. Preliminaries  ##########################################################
## 1. Plotting ################################################################
###############################################################################
## 0. Preliminaries  ##########################################################
library(dplyr)
library(eulerr)
catalog <- read.csv("data/processed/catalog.csv")
source("code/functions/FunPlotSimple.R")

## 0.1 clean slate ############################################################
catalog <- filter(catalog, v632 == TRUE)
catalog$full.rds <- paste0("data/interim/",catalog$filecode, ".rds")
catalog$final.rds <- paste0("data/processed/",catalog$filecode, ".rds")


# df <- readRDS(catalog$final.rds[12])
# table(df$var)
# labelled::labelled(df$var)

postscript("figures/test1.eps")
FunPlotSimple()
dev.off()
postscript("figures/test2.eps")
FunPlotSimple()
dev.off()
postscript("figures/test3.eps")
FunPlotSimple()
dev.off()
# for (i in 5:10){
#   if (exists(as.character(all.df$codename[i]))){
#     if (!all(is.na(get(as.character(all.df$codename[i]))$var))){
#       x <- codebook(get(as.character(all.df$codename[i]))$var)@.Data[[1]]@stats$tab[1:3,1]
#       
#       fit1 <- euler(c("A" = x[[1]], "B" = x[[2]], "A&B" = x[[3]]))
#       plot(fit1)}
# }  }
#   
# 
# prop.table(table(AFIR70$region, AFIR70$var)[,1:3], 1)
# barplot(t(as.matrix(prop.table(table(AZIR52$region, AZIR52$var)[,1:3], 1))))

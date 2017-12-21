###############################################################################
##  DATA IMPORT   #############################################################
###############################################################################
## 0. Preliminaries  ##########################################################
# 1.Extract only required variables############################################
###############################################################################
#' I've had to redo this, after adding the lodown package to import the data
#' for increased reproducibility. The package usefully imports the files and
#' alredy extracts them and saves as .rds files, which are interim, now I 
#' need to extract only the four variables I need: 
#' 
#' @inputData: these are te `data/interim/.*.rds` files that have the full
#' tables (from `haven::read_dta()`) 
#' 
#' Some of them will not have the v632 variable, and others will, btu it will 
#' be all NAs.
#' 
#' @catalog: this is the subset table of the 226 files that had been downloaded
#' and is also in the `data/interim/` folder
#' 
## 0. Preliminaries  ##########################################################
###############################################################################
source("code/functions/FunDataExtractor.R")
catalog <- readRDS("data/interim/catalog.rds")
# add new empty variable to keep track of which files have been extracted
catalog$v632 <- NA

# 1.Extract only required variables############################################
###############################################################################
#' This reduces each country table to essentially four (for now) variables
#' but also checks if thv v632 variable exists, otehrwise we don't need that 
#' table anyway. 
#' 
#' The catalog gets updated with each one as well, 
#' 
for (i in 1:nrow(catalog)){
  FunDataExtractor(i)
}

write.csv(catalog, "data/processed/catalog.csv")



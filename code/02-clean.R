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
library(dplyr)
library(tidyr)
source("code/FunDataExtractor.R")
catalog <- readRDS("data/interim/catalog.rds")
# add new empty variable to keep track of which files have been extracted
catalog$v632 <- NA
# import UN regional codes list
UNcodes <- read.csv("data/raw/UNcodes.csv", stringsAsFactors = FALSE)

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

# update catalog to only v632 
catalog <- dplyr::filter(catalog, v632 == TRUE)

catalog$full.rds <- paste0("data/interim/",catalog$filecode, ".rds")
catalog$final.rds <- paste0("data/processed/",catalog$filecode, ".rds")

#  remove the second dominican file that is only sugar plantation workers
catalog <- dplyr::filter(catalog, output_filename != "data/raw/DRIR5ADT.zip")

# rename countries to UN standard
catalog$country <- as.character(catalog$countr)
# rrename to UN standard country names
catalog[which(catalog$country == "Congo Democratic Republic"),"country"] <- "Democratic Republic of the Congo"
catalog[which(catalog$country == "Bolivia"),"country"]$country <- "Bolivia (Plurinational State of)"
catalog[which(catalog$country == "Cote d'Ivoire"),"country"]$country <- "Côte d'Ivoire"
catalog[which(catalog$country == "Kyrgyz Republic"),"country"]$country <- "Kyrgyzstan"
catalog[which(catalog$country == "Moldova"),"country"]$country <- "Republic of Moldova"
catalog[which(catalog$country == "Tanzania"),"country"]$country <- "United Republic of Tanzania"
# join with regional table
catalog <- left_join(catalog, UNcodes, by = c("country" = "Country.or.Area"))

#save catalog
write.csv(catalog, "data/processed/catalog.final.csv")

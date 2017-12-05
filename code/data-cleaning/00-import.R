###############################################################################
##  DATA IMPORT   #############################################################
###############################################################################
## 0. Preliminaries  ##########################################################
## 1.  Import test version ####################################################
###############################################################################

## 0. Preliminaries  ##########################################################
###############################################################################
rm(list = ls())
options(stringsAsFactors = FALSE)
library(memisc)
library(tidyverse)

## 1.  Import and subset data #################################################
###############################################################################
## 1.1. List all files, importer, subset  #####################################

catalog <- read.csv("data/raw/url.list.txt", header = FALSE, stringsAsFactors = FALSE)
names(catalog) <- "url"
catalog$filename <- gsub( ".*Filename=(.+?)\\&.*", "\\1", catalog$url[1])
catalog$id <- gsub(".*id=(\\d+)&.*", "\\1",  catalog$url)



# regular expression for all individual data files 
all.files <- list.files("data/raw", pattern = ".*zip")

# df of all files
all.df <- data.frame(filename = all.files,
                     codename = substr(all.files, 1,6),
                     country = substr(all.files, 1,2),
                     phase = as.numeric(substr(all.files, 5,5)),
                     v632 = NA)

# remove surveys from phase 3 or earlier, since quesiton wasn't asked
all.df %>% 
  filter(phase>3) -> all.df


i = 1
# ok, so this is an importer class -- not the data (also it's directly 
# looking into the zipped fiel without unzipping it
# becasue some files are named differently... 9.dta instead of .DTA
# I need to manually check this.. 
for (i in 11:15) {
  filename <- grep(".dta", unzip(paste0(path, all.df$filename[i]),list = TRUE)$Name, ignore.case = TRUE, value = TRUE)
  importer <- Stata.file(unzip(paste0(path, all.df$filename[i]), 
                               filename))
  
  if ("v632" %in% names(importer)) {
    assign(paste0(all.df$codename[i],""), subset(importer, select=c(wave   = v000,
                                                                    weight = v005,
                                                                    region = v102,
                                                                    var    = v632)))
    if (!all(is.na(get(as.character(all.df$codename[i]))$var))) all.df$v632[i] <- TRUE} else
    {all.df$v632[i] <- FALSE}
 
  
}

i = 58
for (i in 5:10){
  if (exists(as.character(all.df$codename[i]))){
    if (!all(is.na(get(as.character(all.df$codename[i]))$var))){
      x <- codebook(get(as.character(all.df$codename[i]))$var)@.Data[[1]]@stats$tab[1:3,1]
      
      fit1 <- euler(c("A" = x[[1]], "B" = x[[2]], "A&B" = x[[3]]))
      plot(fit1)}
}  }
  
saveRDS(AZIR52, "data/processed/AZIR52.rds")

prop.table(table(AFIR70$region, AFIR70$var)[,1:3], 1)
barplot(t(as.matrix(prop.table(table(AZIR52$region, AZIR52$var)[,1:3], 1))))

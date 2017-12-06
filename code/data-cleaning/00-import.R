###############################################################################
##  DATA IMPORT   #############################################################
###############################################################################
## 0. Preliminaries  ##########################################################
## 1.  Import and subset data##################################################
###############################################################################

## 0. Preliminaries  ##########################################################
###############################################################################
options(stringsAsFactors = FALSE)
library(dplyr)
library(memisc)


## 1.  Import and subset data #################################################
## 1.0 Manual steps
#' the files are downloaded into data/raw/ from the list:data/raw/url.list.txt
#' Then the Kenya zip files are renamed from KE to KN.
###############################################################################
## 1.1. List all files, create catalog    #####################################

catalog <- read.csv("data/raw/url.list.txt", header = FALSE)
names(catalog) <- "url"
catalog$filename <- gsub( ".*Filename=(.+?)\\&.*", "\\1", catalog$url)
catalog$id <- gsub(".*id=(\\d+)&.*", "\\1",  catalog$url)
catalog$cntry <- gsub( ".*Ctry_Code=(.+?)\\&.*", "\\1",catalog$url)
catalog$cntry.file <- gsub( ".*Filename=([A-Z]{2}).*", "\\1",catalog$url)
catalog$phase <-  gsub( ".*Filename=[A-Z]*([0-9]{1}).*", "\\1",catalog$url)
catalog$v632 <- NA
# I have manually renamed the Kenya files to KN instead of KA, because India
# Kerala has a KA. But the url list doens't know this, so I need to manually 
# fix it here.
# rename the 7 `filename` that start with KE to KN
catalog$filename[catalog$cntry == "KE"] <- gsub("KE", "KN", catalog$filename[catalog$cntry == "KE"])
# (checked with files in data/raw and all good at this point.

## 1.2. Remove files that are too old ########################################

# find files to delete (and make a flag variable)
catalog %>% mutate(exists = ifelse(phase>3, TRUE,FALSE)) -> catalog
catalog%>% 
  filter(phase <4) %>% 
  pull(filename) -> deletion
# delete files
file.remove(paste0("data/raw/", deletion))
rm(deletion)

## 1.3 Importer Function



# ok, so this is an importer class -- not the data (also it's directly 
# looking into the zipped fiel without unzipping it
# becasue some files are named differently... 9.dta instead of .DTA
# I need to manually check this.. 
#' Importer function
#' 
#' Function to extract subset from each zipped DHS file and save them as 
#' individual rds
#'
#'  @i is the index of the file in the catalog.
#'
#' The funciton does the following in order with minimal error checking:
#' 1. gets the filename of the stata file inside the zipped file. 
#' (assuming there always is one)
#' 2. creates a memisc::importer for it
#' 3. If there is no v632 variable in the importer, then that gets flagged
#'    and nothing more happens
#' 4. If v632 exists, the subset is extracted. 
#' 5. v632 is checked in case it is full of NAs - in which case that gets
#'    flagged as well
#' 6. Unflagged subsets get saved as .rds files in data/interim     
#' 7. the objects are deleted - oh, don't need to, it's in the FunEnv.
#' Output: updated catalog file, and processed .rds files. 
#' 

FunImporter <- function(i){
  path <- "data/raw/"
  filename.dta <- grep(".dta", unzip(paste0(path, catalog$filename[i]),
                                     list = TRUE)$Name,
                       ignore.case = TRUE, value = TRUE)
  importer <- Stata.file(unzip(paste0(path, catalog$filename[i]),
                               filename.dta))
  ds.name <- substr(catalog$filename[i],1,6)
  if ("v632" %in% names(importer)) {
    assign(ds.name, subset(importer, select=c(wave   = v000,
                                              weight = v005,
                                              region = v102,
                                              var    = v632)))  
    print("v632 was there")
    if (!all(is.na(get(as.character(ds.name))$var))) {
      print(" and not all NAs")
      catalog$v632[i] <<- TRUE}else
      {print("all NAs")
        catalog$v632[i] <<- FALSE}} else{
          print("v632 wasn't there")
          catalog$v632[i] <<- FALSE}
  if(catalog$v632[i]){
    saveRDS(ds.name, paste0("data/interim/", ds.name, ".rds"))
    print("Hello save")
  }
}




for (i in which(catalog$exists)){
  FunImporter(i)
}



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

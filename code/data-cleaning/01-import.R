###############################################################################
##  DATA IMPORT   #############################################################
###############################################################################
## 0. Preliminaries  ##########################################################
## 1.  Import and subset data##################################################
###############################################################################
#' uses catalog frim data/raw/catalog.full.rds to download and extract
#' only the IR files for the later than 3 phases. And remanes the Kerala file
#' 
#' @catalog.full is the output of the lodown get_catalog function, which takes
#' a while and was taken out to stop repeating it
#' 
#' OUtput: catalog.rds is the pared down catalog, gets saved in data/interim
## 0. Preliminaries  ##########################################################
###############################################################################
options(stringsAsFactors = FALSE)
library(lodown)


## 1.  Import and subset data #################################################
###############################################################################
## 1.1. List all files, create catalog    #####################################
# get all available datasets from DHS using the lodown package, previously extr
catalog.full <- readRDS("data/raw/catalog.full.rds")

# filename - regex 
catalog.full$filecode <- sub(".*/(\\w*).*", "\\1", 
                            catalog.full$output_filename)
# regex: two letters after two letters after last /
catalog.full$dataset <- sub(".*/\\w{2}(\\w{2}).*", "\\1", 
                            catalog.full$output_filename)
# regex two letter before last ., but NA if doesn't exist
catalog.full$filetype <-   ifelse(grepl(".*(\\D{2})\\..*$", 
                                        catalog.full$output_filename), 
                                  sub(".*(\\D{2})\\..*$", "\\1", 
                                      catalog.full$output_filename), "NA")
# wave or phase
catalog.full$phase <- sub("\\D*(\\d{1}).*", "\\1", catalog.full$filecode)

# id (to help distinguish India
catalog.full$id <- sub(".*\\D+(\\d+)$", "\\1", catalog.full$full_url)


## 1.2. Select only fines to download   #######################################
# Select only individual recode files, with STATA files and after phase 30
catalog <- subset(catalog.full, 
                         catalog.full$dataset %in% c("IR", "ir") & 
                           catalog.full$filetype  %in% c("DT", "dt" )&
                           catalog.full$phase > 3)
# remove the folders that lodown inserts for each file
catalog$output_filename <-   sub( "((\\w*/){2})(.*)/(.*$)", "\\1\\4", 
                                  catalog$output_filename)
# i treid changing this to interim, but didn't do anything, goes into raw
# anyway.. 
catalog$output_folder <- "data/raw"


## 1.3. Download files#########################################################
# Now if I run this normally, the Kenya one will overwrite the Kerala one,
# as  I am throwing it all inthe same folder. SO I will best just rename Kerala, 
# and then repeat Kenya

lodown( "dhs" , catalog, 
        your_email = "maja.zaloznik@gmail.com" , 
        your_password = "barabe2017" , 
        your_project = "Cross cultural variation in")
# rename the KE file to IK - india-Kerala, then repeat
file.rename("data/raw/KEIR42DT.rds", "data/raw/IKIR42DT.rds")
lodown( "dhs" , subset(catalog, catalog.subset$country == "Kenya"), 
         your_email = "maja.zaloznik@gmail.com" , 
         your_password = "barabe2017" , 
         your_project = "Cross cultural variation in")
 
# just fix the catalog filecode in case i need it later. 
catalog$filecode[catalog$filecode == "KEIR42DT" & catalog$id == 156 ] <- "IKIR42DT"

## 1.4 move around stuff ######################################################
# which .rds files have now been saved? (pattern stops from deleting the catalog)
new.files <- list.files(path = "data/raw", pattern = ".*[A-Z]+.*.rds")

# move them to the interim folder
file.rename(paste0("data/raw/", new.files), paste0("data/interim/", new.files) )

# delete zip files
file.remove(paste0("data/raw/", list.files(path = "data/raw", pattern = ".*.zip")))

# save catalog
saveRDS(catalog, "data/interim/catalog.rds")



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
#' Ootput: catalog.rds is the pared down catalog, gets saved in data/interim
#' 
## 0. Preliminaries  ##########################################################
###############################################################################
options(stringsAsFactors = FALSE)
library(lodown)
memory.limit(256000)
source(".config")

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
catalog.full$filetype <-   ifelse(
  grepl(".*(\\D{2})\\..*$",
        catalog.full$output_filename),
  sub(".*(\\D{2})\\..*$", "\\1",
      catalog.full$output_filename),
  "NA"
)
# wave or phase
catalog.full$phase <-
  sub("\\D*(\\d{1}).*", "\\1", catalog.full$filecode)

# id (to help distinguish India
catalog.full$id <-
  sub(".*\\D+(\\d+)$", "\\1", catalog.full$full_url)


## 1.2. Select only fines to download   #######################################
# Select only individual recode files, with STATA files and after phase 30
catalog <- subset(
  catalog.full,
  catalog.full$dataset %in% c("IR", "ir") &
    catalog.full$filetype  %in% c("DT", "dt") &
    catalog.full$phase > 3
)
# remove the folders that lodown inserts for each file
catalog$output_filename <-
  sub("((\\w*/){2})(.*)/(.*$)", "\\1\\4",
      catalog$output_filename)

catalog$output_folder <- "data/raw"
rownames(catalog) <- seq(length = nrow(catalog))

# remove India 72 :(
# I can't load it on any 8GB laptop, so it's out unfortunately
catalog <- catalog[catalog$filecode != "IAIR72DT",]
## 1.3. Download files#########################################################

catalog <- lodown(
  "dhs" ,
  catalog,
  your_email = your_email ,
  your_password = your_password ,
  your_project = your_project
)

## 1.4 move around stuff ######################################################
# which .rds files have now been saved? (pattern stops from deleting the catalog)
new.files <-
  list.files(path = "data/raw", pattern = ".*[A-Z]+.*.rds")

# move them to the interim folder
file.rename(paste0("data/raw/", new.files),
            paste0("data/interim/", new.files))

# delete zip files
file.remove(paste0("data/raw/", list.files(path = "data/raw", pattern = ".*.zip")))

# save catalog
saveRDS(catalog, "data/interim/catalog.rds")

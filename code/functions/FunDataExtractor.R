#' FunDataExtractor
#' 
#' Extracts subset of table and resaves, updating the catalog
#' 
#' This reduces each country table to essentially four (for now) variables
#' but also checks if thv v632 variable exists, otehrwise we don't need that 
#' table anyway. 
#' 
#' The catalog gets updated 
#' 
#' @i is the index (row) in the catalog 

FunDataExtractor <- function(i){
  file.name <- paste0("data/interim/",catalog$filecode[i], ".rds")
  full.table <- readRDS(file.name)
  file.extracted <- paste0("data/processed/",catalog$filecode[i], ".rds")
  if(!"v632" %in% names(full.table)){ # variable doens't exist
    catalog$v632[i] <<- FALSE} else { # if the variable does exist
      catalog$v632[i] <<- TRUE
      if(!all(is.na(full.table$v632))){ # exists, and isn't all NA
        extract.table <- subset(full.table, 
                                select=c(v000,
                                         v005,
                                         v102,
                                         v312,
                                         v502,
                                         v632))
        colnames(extract.table) <- c("wave", "weight", "region", "contraception", "married","var")
        saveRDS(extract.table, file.extracted)
      } else {# all are NAs
        catalog$v632[i] <<- FALSE }
    }
}


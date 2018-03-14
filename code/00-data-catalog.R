## Data catalog import ########################################################
# get all available datasets from DHS using the lodown package
source(".config")
catalog.full <- lodown::get_catalog( "dhs" ,"data/raw",
                             your_email = your_email, 
                             your_password = your_password , 
                             your_project = Your_project)

## while testing this is reduced to 1 row:
catalog.full <- catalog.full[1:50,]
saveRDS(catalog.full, "data/raw/catalog.full.rds")
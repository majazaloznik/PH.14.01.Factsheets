## Data catalog import ########################################################
# get all available datasets from DHS using the lodown package
source(".config")
catalog.full <- lodown::get_catalog( "dhs" ,"data/raw",
                             your_email = your_email, 
                             your_password = your_password , 
                             your_project = your_project)

saveRDS(catalog.full, "data/raw/catalog.full.rds")
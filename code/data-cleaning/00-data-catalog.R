## Data catalog import ########################################################
# get all available datasets from DHS using the lodown package
catalog.full <- lodown::get_catalog( "dhs" ,"data/raw",
                             your_email = "maja.zaloznik@gmail.com" , 
                             your_password = "barabe2017" , 
                             your_project = "Cross cultural variation in")

saveRDS(catalog.full, "data/raw/catalog.full.rds")
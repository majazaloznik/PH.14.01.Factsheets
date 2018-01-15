#' FunTablePrep
#' 
#' Prepares a proportional table from the full counts and weights.
#' But also merges the counts together if there are several surveys 
#' with the same phase. 
#' 
#' @i row in catalog
#' 
#' 
#' This should end up checking if there are multiple surveys from the same
#' phase and merging them -- but the only way you can notice is by 
#' seing they are the same. But I know which ones they are anyway. 



FunTablePrep <- function(i) {
  row <- catalog[i,]
  all.rows <- catalog[catalog$country == row$country & 
                        catalog$phase == row$phase, ]
  
  df <- data.frame(wave = character(), 
                   weight = integer() , 
                   region = integer(), 
                   var  = integer())
  for ( j in 1:nrow(all.rows)) {
    df <- rbind(df, readRDS(all.rows$final.rds[j]))
  }
  pt <- prop.table(xtabs(df$weight ~ df$var + df$region), 2) 
  return(pt)
}
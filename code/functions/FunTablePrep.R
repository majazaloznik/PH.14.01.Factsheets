#' FunTablePrep
#' 
#' Prepares a proportional table from the full counts and weights.
#' But also merges the counts together if there are several surveys 
#' with the same phase. 
#' 
#' @i row in catalog
#' 
#' 
#' This should  check if there are multiple surveys from the same
#' phase and merge them -- but the only way you can notice is by 
#' seing they are the same. But I know which ones they are anyway. 
#' 
#' The order of the rows are also sorted to swap 2 and 3 for nice
#' plotting. 
#' 
#' Outups a list: 
#' [[1]] is the prop xtable  to be used in the barplot
#' [[2]] is the year or range of years, which isused in the title
#' [[3]] is the N of cases with valid `var` values, so what 100% 
#' sums up to unweighted. 



FunTablePrep <- function(i) {
  row <- catalog[i,]
  
  all.rows <- catalog[catalog$country == row$country & 
                        catalog$phase == row$phase, ]
  
  # initialise empty df
  df <- data.frame(wave = character(), 
                   weight = integer() , 
                   region = integer(), 
                   var  = integer())

  # read to df (multiple files if required)
  for ( j in 1:nrow(all.rows)) {
    df <- rbind(df, readRDS(all.rows$final.rds[j]))
  }
  
  # drop cases with no valid var (save number before)
  catalog$total.cases[i] <<- nrow(df)
  df <- df[!is.na(df$var ),]
  
  # proportional table 
  pt <- prop.table(xtabs(df$weight ~ df$var + df$region), 2) 
  
  # swap rows 2 and 3
  new.order <- na.omit(match(c("1", "3","2" , "6", "9"), rownames(pt)))
  pt <- pt[new.order ,]
  
  #update the catalog
  catalog$valid.cases[i] <<- nrow(df)
  year <- range(all.rows$year)
  year <- ifelse(year[1] == year[2],year[1], paste(year[1], year[2], sep = "-"))
  catalog$years.new[i] <<- year
  catalog$wave[i] <<- paste0(unique(df$wave),collapse="")
  
  return(list(pt, paste0(unique(df$wave),collapse="")))
}


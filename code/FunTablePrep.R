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
#' [[2]] is the wave name


FunTablePrep <- function(i) {
  row <- catalog[i,]
  
  all.rows <- catalog[catalog$country == row$country & 
                        catalog$phase == row$phase, ]
  
  # initialise empty df
  df <- data.frame(wave = character(), 
                   weight = integer() , 
                   region = integer(), 
                   contraception = integer(),
                   married = integer(),
                   var  = integer())

  # read to df (multiple files if required)
  for ( j in 1:nrow(all.rows)) {
    df <- rbind(df, readRDS(all.rows$final.rds[j]))
  }
  
  # drop ineligible cases (save number before)
  
  catalog$total.cases[i] <<- nrow(df)
  df <- df[df$married == 1 & df$contraception > 0,]
  df[is.na(df)] <- 9
  # this is because of Namibia files having weirdly missing rows
  df <- df[which(df$region != 9),]
  # weighted counts table
  w.counts <- xtabs(df$weight ~ df$var + df$region, addNA = TRUE)/1000000
  catalog$urban.wife[i] <<-  w.counts["1", "1"]
  catalog$urban.husband[i] <<- w.counts["2", "1"]
  catalog$urban.both[i] <<- w.counts["3", "1"]

  catalog$rural.wife[i] <<-  w.counts["1", "2"]
  catalog$rural.husband[i] <<- w.counts["2", "2"]
  catalog$rural.both[i] <<-  w.counts["3", "2"]
  
  if ("6" %in% unlist(dimnames(w.counts))) {
    catalog$urban.other[i] <<- w.counts["6", "1"]
    catalog$rural.other[i] <<- w.counts["6", "2"]}
  
  if ("9" %in% unlist(dimnames(w.counts))) {
    catalog$urban.missing[i] <<- w.counts["9", "1"]
    catalog$rural.missing[i] <<- w.counts["9", "2"]}

  
  # proportional table 
  pt <- prop.table(w.counts, 2) 
  
  # swap rows 2 and 3
  new.order <- na.omit(match(c("1", "3","2" , "6", "9"), rownames(pt)))
  pt <- pt[new.order ,]
  
  #update the catalog
  catalog$eligible.cases[i] <<- nrow(df)
  year <- range(all.rows$year)
  year <- ifelse(year[1] == year[2],year[1], paste(year[1], year[2], sep = "-"))
  catalog$years.new[i] <<- year
 
  
  # manually change name for two datasets that have a misleading `wave' value
  wave.name <- ifelse(any(all.rows$filecode == "SNIR7QDT"), "SN7",
                      ifelse(any(all.rows$filecode == "GHIR72DT"), "GH7",
                             ifelse(any(all.rows$filecode == "ETIR51DT"), "ET5",
                                    ifelse(any(all.rows$filecode == "RWIR70DT"), "RW7",
                                           ifelse(any(all.rows$filecode == "RWIR53DT"), "RW5",
                                                  ifelse(any(all.rows$filecode == "COIR53DT"), "CO5",
                                                         ifelse(any(all.rows$filecode == "COIR61DT"), "CO6",
                                                                ifelse(any(all.rows$filecode == "BDIR72DT"), "BD7",
                                                                       ifelse(all.rows$filecode == "KHIR73DT", "KH7", 
                                                                              ifelse(all.rows$filecode == "KHIR61DT", "KH6", 
                                                                                     ifelse(all.rows$filecode == "KHIR51DT", "KH5", 
                                                                                            ifelse(all.rows$filecode == "KHIR42DT", "KH4", 
                             paste0(unique(df$wave),collapse="")))))))))))))
  catalog$wave[i] <<- wave.name
  # return for plotting
  return(list(pt, wave.name))
}




FunPlotSimple <- function(i){
  df <- readRDS(catalog$final.rds[i])
  pt <- prop.table(xtabs(df$weight ~ df$var + df$region), 2)
  fit1 <- euler(c("wife-urban" = pt[1,1], "husband-urban" = pt[2,1], "wife-urban&husband-urban" = pt[3,1],
                  "wife-rural" = pt[1,2], "husband-rural" = pt[2,2], "wife-rural&husband-rural" = pt[3,2]))
  plot(fit1)
}


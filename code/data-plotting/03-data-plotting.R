
# for (i in 5:10){
#   if (exists(as.character(all.df$codename[i]))){
#     if (!all(is.na(get(as.character(all.df$codename[i]))$var))){
#       x <- codebook(get(as.character(all.df$codename[i]))$var)@.Data[[1]]@stats$tab[1:3,1]
#       
#       fit1 <- euler(c("A" = x[[1]], "B" = x[[2]], "A&B" = x[[3]]))
#       plot(fit1)}
# }  }
#   
# 
# prop.table(table(AFIR70$region, AFIR70$var)[,1:3], 1)
# barplot(t(as.matrix(prop.table(table(AZIR52$region, AZIR52$var)[,1:3], 1))))

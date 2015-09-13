setwd('C:\\Users\\iliu2\\Documents\\8.Ad-hoc analytics\\LookAlike');
rm(list = ls()); gc()
load('data/20150913_lookalike_results.RData')
load('data/20150913_lookalike_results_rf.RData')

ls()
head(p)

library(data.table)
test <- fread('data/FCO_LOOKALIKE_COMPLETE.csv', data.table=F)
test <- test[which(test$AGE_BAND != 'Under 18'),-c(38:40)]
for(i in 1:ncol(test)){
  if(i %in% c(2,3,5:17)) test[,i] <- as.factor(test[,i])
}

# output <- cbind(test[,1], p)
output <- pred
head(output)
names(output) <- c('GROUP_LOYALTY_MEMBER_NUMBER', 'N','Y')

write.csv(output,file = '20150913_lookalike_rf_results.csv', row.names = F)

output$SEG <- ifelse(output$Y >= 0.91,'91-100',
                     ifelse(output$Y >= 0.81,'81-90',
                            ifelse(output$Y >= 0.71,'71-80',
                                   ifelse(output$Y >= 0.61,'61-70',
                                          ifelse(output$Y >= 0.51,'51-60',
                                                 ifelse(output$Y >= 0.41,'41-50',
                                                        ifelse(output$Y >= 0.31,'31-40',
                                                               ifelse(output$Y >= 0.21,'21-30',
                                                                      ifelse(output$Y >= 0.11,'11-20','0-10'
                                                                             )))))))))

table(output$SEG)
plot(density(output$Y))
sort(table(output$Y),decreasing = T)[1:5]

# Sample
sample <- rbind(head(output[which(output$Y>0.81),]),
head(output[which(output$Y>0.61),]),
head(output[which(output$Y>0.51),]),
head(output[which(output$Y>=0.15),]))

write.csv(sample,file = '20150913_lookalike_gbm_results_sample.csv', row.names = F)

length(output[which(output$Y>=0.15),1])
length(output[which(output$Y<0.15),1])

table(pred$Y)
write.csv(table(pred$Y),file = '20150913_lookalike_rf_results_sample.csv', row.names = F)

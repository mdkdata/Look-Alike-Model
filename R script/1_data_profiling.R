setwd('C:\\Users\\iliu2\\Documents\\8.Ad-hoc analytics\\LookAlike');
rm(list = ls()); gc()
library(data.table)

dt_full <- fread('data/FCO_LOOKALIKE_COMPLETE.csv', data.table=F)
dim(dt_full)
str(dt_full); names(dt_full)
head(dt_full)
for(i in 1:ncol(dt_full)){
  if(i %in% c(2,3,5:17)) dt_full[,i] <- as.factor(dt_full[,i])
}
dt_full$FCO_CST <- as.factor(dt_full$FCO_CST)
#####################
### Split dataset ###
#####################
fco_dt <- dt_full[which(dt_full$FCO_CST == 'Y'),1:37]
llo_dt <- dt_full[which(dt_full$LLO_CST == 'Y' 
                        & dt_full$FCO_CST == 'N'),1:37]
fc_dt <- dt_full[which(dt_full$LLO_CST == 'N' 
                       & dt_full$FCO_CST == 'N'
                       & dt_full$LL_CST == 'N'
                       & dt_full$FC_CST == 'Y'),1:37]
ll_dt <- dt_full[which(dt_full$LLO_CST == 'N' 
                       & dt_full$FCO_CST == 'N'
                       & dt_full$LL_CST == 'Y'
                       & dt_full$FC_CST == 'N'),1:37]
llfc_dt <- dt_full[which(dt_full$LLO_CST == 'N' 
                         & dt_full$FCO_CST == 'N'
                         & dt_full$LL_CST == 'Y'
                         & dt_full$FC_CST == 'Y'),1:37]
lq_dt <- dt_full[which(dt_full$LLO_CST == 'N' 
                       & dt_full$FCO_CST == 'N'
                       & dt_full$LL_CST == 'N'
                       & dt_full$FC_CST == 'N'),1:37]
dim(fco_dt);dim(llo_dt);dim(fc_dt);dim(ll_dt);dim(llfc_dt);dim(lq_dt)

##########################
### Plot Distributions ###
##########################
par(mfcol=c(2,3))
hist(log10(fco_dt$SPIRITS_QTY_S), breaks=100, col="blue")
hist(log10(llo_dt$SPIRITS_QTY_S), breaks=100, col="red")
hist(log10(fc_dt$SPIRITS_QTY_S), breaks=100, col="red")
hist(log10(ll_dt$SPIRITS_QTY_S), breaks=100, col="red")
hist(log10(llfc_dt$SPIRITS_QTY_S), breaks=100, col="red")
hist(log10(lq_dt$SPIRITS_QTY_S), breaks=100, col="red")

##############
### t.test ###
##############
t.test(fco_dt$NO_TRANS, ll_dt$NO_TRANS, alternative='two.sided', conf.level=.95) # paired=T
summary(fco_dt$NO_TRANS); summary(ll_dt$NO_TRANS)

# WINE_QTY_S
# FES_Y
# NO_TRANS
# DAYS_SINCE_LAST_TRN

# [1] "GROUP_LOYALTY_MEMBER_NUMBER" "MOSAIC_DESC"                 "LIFESTAGE_HIGH_NAME"         "FES_Y"                      
# [5] "AGE_BAND"                    "OPENER_6M_ALL"               "SURV_RESP_WW"                "SURV_RESP_RW"               
# [9] "SURV_RESP_SW"                "SURV_RESP_B"                 "SURV_RESP_S"                 "SURV_RESP_PM"               
# [13] "SURV_RESP_NONE"              "MBR_GENDER"                  "CUSTOMER_AFFLUENCE"          "POINTS_SEGMENT"             
# [17] "ONLINESHOPPING_YR"           "NO_TRANS"                    "DAYS_SINCE_LAST_TRN"         "TOTAL_SALES"                
# [21] "LL_DT"                       "FC_DT"                       "BEER_QTY"                    "BEER_SALES"                 
# [25] "BEER_TRANS"                  "BEER_SALES_S"                "BEER_QTY_S"                  "WINE_QTY"                   
# [29] "WINE_SALES"                  "WINE_TRANS"                  "WINE_SALES_S"                "WINE_QTY_S"                 
# [33] "SPIRITS_QTY"                 "SPIRITS_SALES"               "SPIRITS_TRANS"               "SPIRITS_SALES_S"            
# [37] "SPIRITS_QTY_S"  


################
### Modeling ###
################
library(rpart)
fit <- rpart(FCO_CST ~ ., data=dt_full[,c(2:37,41)], method='class')#,control=rpart.control(minsplit=2, minbucket=1, cp=0.001)) 
printcp(fit)	
plotcp(fit)
rsq.rpart(fit)
print(fit)
summary(fit)

# plot tree 
plot(fit, uniform=TRUE, 
     main="Classification Tree for Kyphosis")
text(fit, use.n=TRUE, all=TRUE, cex=.8)

# create attractive postscript plot of tree 
post(fit, file = "c:/tree.ps", 
     title = "Classification Tree for Kyphosis")

### Random Forest prediction of Kyphosis data
library(randomForest)
fit <- randomForest(FCO_CST ~ ., data=dt_full[,c(2:37,41)])
print(fit) # view results 
importance(fit) # importance of each predictor

library(caret)
# Config
fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 5,
  classProbs =T,
# repeated ten times
  repeats = 2)
Grid <-  expand.grid(n.trees=150,interaction.depth=3,shrinkage=0.1,n.minobsinnode = 10)
# Training
set.seed(825)
gbmFit1 <- train(FCO_CST ~ ., data=dt_full[,c(2:37,41)],
                 method = "gbm",
                 trControl = fitControl,
                 tuneGrid = Grid,
                 metric ='ROC',
                 ## This last option is actually one
                 ## for gbm() that passes through
                 verbose = T)
gbmFit1

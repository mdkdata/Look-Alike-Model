setwd('C:\\Users\\iliu2\\Documents\\8.Ad-hoc analytics\\LookAlike');
rm(list = ls()); gc()
library(data.table)

dt_full <- fread('data/FCO_LOOKALIKE_TRAIN.csv', data.table=F)
dt_comp <- fread('data/FCO_LOOKALIKE_COMPLETE.csv', data.table=F)
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
other_dt <- dt_full[which(dt_full$FCO_CST == 'N'),1:37]
test_dt <- dt_comp[which(dt_comp$FCO_CST == 'N'),1:37]

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
jpeg(filename = 'FES_Y_dist.jpeg', width = 520, height = 640)
par(mfcol=c(2,1))
hist(fco_dt$FES_Y, breaks=100, col="blue", freq = F, main='FES_Y Distribution - FCO', xlab = 'FES_Y')
hist(other_dt$FES_Y, breaks=100, col="red", freq = F, main='FES_Y Distribution - Other', xlab = 'FES_Y')
dev.off()

hist(fco_dt$LL_DT, breaks=100, col="blue", freq = F, main='LL_DT Distribution - FCO')
hist(other_dt$LL_DT, breaks=100, col="red", freq = F, main='LL_DT Distribution - Other')

hist(fco_dt$FC_DT, breaks=100, col="blue", freq = F, main='FC_DT Distribution - FCO')
hist(other_dt$FC_DT, breaks=100, col="red", freq = F, main='FC_DT Distribution - Other')

hist(log10(fco_dt$BEER_SALES_S), breaks=100, col="blue", freq = F, main='BEER_SALES_S Distribution - FCO')
hist(log10(other_dt$BEER_SALES_S), breaks=100, col="red", freq = F, main='BEER_SALES_S Distribution - Other')

hist(log10(fco_dt$BEER_QTY_S), breaks=100, col="blue", freq = F, main='BEER_QTY_S Distribution - FCO')
hist(log10(other_dt$BEER_QTY_S), breaks=100, col="red", freq = F, main='BEER_QTY_S Distribution - Other')

jpeg(filename = 'Wine_Sales_dist.jpeg', width = 520, height = 640)
par(mfcol=c(2,1))
hist(log10(fco_dt$WINE_SALES_S), breaks=100, col="blue", freq = F, main='WINE_SALES Distribution - FCO', xlab='Avg. Wine Sales (log10)')
hist(log10(other_dt$WINE_SALES_S), breaks=100, col="red", freq = F, main='WINE_SALES Distribution - Other', xlab='Avg. Wine Sales (log10)')
dev.off()

jpeg(filename = 'Wine_Qty_dist.jpeg', width = 520, height = 640)
par(mfcol=c(2,1))
hist(log10(fco_dt$WINE_QTY_S), breaks=100, col="blue", freq = F, main='WINE_QTY Distribution - FCO', xlab='Avg. Wine Qty (log10)')
hist(log10(other_dt$WINE_QTY_S), breaks=100, col="red", freq = F, main='WINE_QTY Distribution - Other', xlab='Avg. Wine Qty (log10)')
dev.off()


hist(log10(fco_dt$SPIRITS_SALES_S), breaks=100, col="blue", freq = F, main='SPIRITS_SALES_S Distribution - FCO')
hist(log10(other_dt$SPIRITS_SALES_S), breaks=100, col="red", freq = F, main='SPIRITS_SALES_S Distribution - Other')

hist(fco_dt$SPIRITS_QTY_S, breaks=100, col="blue", freq = F, main='SPIRITS_QTY_S Distribution - FCO')
hist(other_dt$SPIRITS_QTY_S, breaks=100, col="red", freq = F, main='SPIRITS_QTY_S Distribution - Other')

# Notched Boxplot of Tooth Growth Against 2 Crossed Factors
# boxes colored for ease of interpretation
jpeg(filename = 'FES_Y_boxplot.jpeg', width = 520, height = 640)
par(mfcol=c(1,1))
boxplot(FES_Y~FCO_CST, data=dt_full, notch=TRUE, 
        col=(c("gold","darkgreen")),
        main="FES_Y", xlab="FCO & Other Liquor")
dev.off()

jpeg(filename = 'WINE_boxplot.jpeg', width = 520, height = 640)
par(mfcol=c(1,1))
boxplot(log10(WINE_QTY_S)~FCO_CST, data=dt_full, notch=F, 
        col=(c("gold","darkgreen")),
        main="Wine Sales", xlab="FCO & Other Liquor")
dev.off()

##############
### t.test ###
##############
t.test(fco_dt$NO_TRANS, ll_dt$NO_TRANS, alternative='two.sided', conf.level=.95) # paired=T
summary(fco_dt$FES_Y); summary(other_dt$FES_Y)
summary(fco_dt$WINE_QTY_S); summary(other_dt$WINE_QTY_S)
summary(fco_dt$WINE_SALES_S); summary(other_dt$WINE_SALES_S)

################
### Modeling ###
################
library(rpart)
# 1. develop trees
fit_rpart <- rpart(FCO_CST ~ ., data=dt_full[,c(2:37, 41)], method='class',control=rpart.control(minsplit=20, minbucket=6, cp=0.0002)) 
printcp(fit_rpart)	
plotcp(fit_rpart)
rsq.rpart(fit_rpart)
print(fit_rpart)
summary(fit_rpart)

# 2. prune the tree 
pfit<- prune(fit_rpart, cp= fit_rpart$cptable[which.min(fit_rpart$cptable[,"xerror"]),"CP"])
rsq.rpart(pfit)
# 3. plot tree 
library(rattle)
library(rpart.plot)
library(RColorBrewer)
library(partykit)

plot(pfit, uniform=TRUE, 
     main="Classification Tree for FCO Customers")
text(pfit, use.n=TRUE, all=TRUE, cex=.8)

prp(pfit) # plot the tree
prp(pfit, varlen=3) # shorten variable name

# new_tree <- prp(pfit, snip=T)$obj # interactive trim the tree
# prp(new_tree)

fancyRpartPlot(pfit) # a fancy plot tree

# rx.tree <- rxDTree(FCO_CST ~ ., data=dt_full[,c(2:38)], maxNumBins = 100, minBucket = 10, maxDepth = 5, cp=0.01, xVal=0)
# prp(rxAddInheritance(rx.tree))

# 4. create attractive postscript plot of tree 
post(pfit, file = "C:/Users/iliu2/Documents/8.Ad-hoc analytics/LookAlike/tree.ps", 
     title = "Classification Tree for FCO Customers")

# 5. predict
pred <- predict(pfit, newdata = dt_full[which(dt_full$FCO_CST == 'N'),])
length(which(pred[,2]>=0.5))

path.rpart(pfit)
residuals(pfit, type='pearson') #deviance


##################
### Modeling 2 ###
##################
# Conditional Inference Tree for Kyphosis
library(party)
fit_party <- ctree(FCO_CST ~ ., data=dt_full[,c(2:38)])
plot(fit_party, main="Conditional Inference Tree for FCO Customers")

pred <- predict(fit_party, newdata = dt_full)
length(which(pred[,2]>=0.5))


##################
### Modeling 3 ###
##################
library(caret)
# Config
fitControl <- trainControl(method = "adaptive_cv",
                           number = 10,
                           repeats = 5,
                           ## Estimate class probabilities
                           classProbs = TRUE,
                           ## Evaluate performance using 
                           ## the following function
                           summaryFunction = twoClassSummary,
                           ## Adaptive resampling information:
                           adaptive = list(min = 10,
                                           alpha = 0.05,
                                           method = "gls",
                                           complete = TRUE))
# Grid <-  expand.grid(n.trees=150,interaction.depth=3,shrinkage=0.1)
# Training
set.seed(825)
fit_caret <- train(FCO_CST ~ ., data=dt_full[,c(2:38)],
                   method = "rpart2",
                   trControl = fitControl,
                   # tuneGrid = Grid,
                   metric ='ROC',
                   tuneLength = 8,
                   ## This last option is actually one
                   ## for gbm() that passes through
                   verbose = T)
fit_caret
p <- predict(fit_caret, newdata = dt_full,type = "prob")

# Plot
trellis.par.set(caretTheme())
plot(fit_caret)

# Variable Imp
gbmImp <- varImp(fit_caret, scale = T)
gbmImp



###################
### Save Models ###
###################
save(fit_rpart, fit_party, fit_gbm, file = 'MODELS.RData')

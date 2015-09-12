setwd('/Users/ivanliu/Google Drive/Clients/Coles/');
setwd('C:\\Users\\iliu2\\Documents\\8.Ad-hoc analytics\\LookAlike');
rm(list = ls()); gc()
library(data.table)

train <- fread('data/FCO_LOOKALIKE_TRAIN.csv', data.table=F)

str(train); names(train)

for(i in 1:ncol(train)){
  if(i %in% c(2,3,5:17,38)) train[,i] <- as.factor(train[,i])
}

# ?glm
# train_df <- cbind(as.data.frame(model.matrix(FCO_CST ~ -1 + ., data=train[,c(2:38)])),train$FCO_CST)
# levels(train$FCO_CST) <- c(0,1)
# fit <- glm(FCO_CST~., data=train[,2:38])

library(caret)
# Config
fitControl <- trainControl(method = "cv",
                           number = 10,
                           classProbs = TRUE,
                           summaryFunction = twoClassSummary)
#Grid <-  expand.grid(n.trees = 150, interaction.depth = 6, shrinkage = 0.02)
Grid <-  expand.grid(mtry=6)

# Training
set.seed(825)
fit <- train(FCO_CST ~ ., data=train[,-1],
                   method = "rf",
                   trControl = fitControl,
                   tuneGrid = Grid,
                   preProcess = c('center', 'scale'),
                   metric ='ROC',
                   verbose = T)

# Training on Full set
fitControl2 <- trainControl(method = "none",
                           classProbs = TRUE,
                           summaryFunction = twoClassSummary)
set.seed(825)
fit2 <- train(FCO_CST ~ ., data=train[,-1],
             method = "rf",
             trControl = fitControl,
             tuneGrid = Grid,
             preProcess = c('center', 'scale'),
             metric ='ROC',
             verbose = T)


# Plot
trellis.par.set(caretTheme())
plot(fit)

# Variable Imp
fitImp <- varImp(fit, scale = T)
fitImp

# predict
test <- fread('data/FCO_LOOKALIKE_COMPLETE.csv', data.table=F)
test <- test[which(test$AGE_BAND != 'Under 18'),-c(38:40)]
for(i in 1:ncol(test)){
  if(i %in% c(2,3,5:17)) test[,i] <- as.factor(test[,i])
}
p <- predict(fit, newdata = test[,-c(1,38)],type = "prob")
pred <- cbind(test[,1], p)
names(pred) <- c('Mbr_Num', 'N', 'Y')

# Output
head(p)
length(p[which(p$Y>=.5),2])

fit_rf <- fit
save(fit_rf, pred, file='20150913_lookalike_results_rf.RData')

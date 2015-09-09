library(caret)
options("na.action")
# Spliting
set.seed(998)
target <- all_dt$target
# df <- cbind(as.data.frame(all_dum), target)
df <- all_dt[,-ncol(all_dt)]
df$target <- ifelse(df$target %in% c('fco'), 'Y', 'N')
df$target <- as.factor(df$target)
inTraining <- createDataPartition(df$target, p = .75, list = FALSE)
training <- df[ inTraining,]
testing  <- df[-inTraining,]

# Config
fitControl <- trainControl(## 10-fold CV
    method = "repeatedcv",
    number = 10,
    ## repeated ten times
    repeats = 5)

# Training
set.seed(825)
gbmFit1 <- train(target ~ ., data = training,
                 method = "gbm",
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 verbose = T)
gbmFit1
save(gbmFit1,gbmImp, file='model1.RData')

# Plot
trellis.par.set(caretTheme())
plot(gbmFit1)

# Variable Imp
gbmImp <- varImp(gbmFit1, scale = FALSE)


# Adaptive Resampling
fitControl2 <- trainControl(method = "adaptive_cv",
                            number = 10,
                            repeats = 2,
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
set.seed(825)
gbmFit2 <- train(target ~ ., data = training,
                 method = "gbm",
                 trControl = fitControl2,
                 preProc = c("center", "scale", "pca"),
                 tuneLength = 8,verbose = T,
                 metric = "ROC")

# Model 
fitControl <- trainControl(method = "none", number = 10, repeats = 5, classProbs = T, verbose = T)
Grid <-  expand.grid(mtry=17)
fit <- train(target ~ ., data = training, method ="rf", metric ='ROC', 
             trControl = fitControl, do.trace=100, tuneGrid = Grid)
#preProc = c("center","scale"),tuneLength = 10, repeats = 15


# Class Distince Calculation
centroids <- classDist(all_dum, all_dt$col)
distances <- predict(centroids, testBC)
distances <- as.data.frame(distances)
head(distances)

xyplot(dist.Active ~ dist.Inactive,
       data = distances,
       groups = testMDRR,
       auto.key = list(columns = 2))
# Spliting
set.seed(998)
inTraining <- createDataPartition(all_dum$target, p = .75, list = FALSE)
training <- all_dum[ inTraining,]
testing  <- all_dum[-inTraining,]

# Config
fitControl <- trainControl(## 10-fold CV
    method = "repeatedcv",
    number = 10,
    ## repeated ten times
    repeats = 10)

# Training
set.seed(825)
gbmFit1 <- train(Target ~ ., data = training,
                 method = "gbm",
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 verbose = T)
gbmFit1

# Plot
trellis.par.set(caretTheme())
plot(gbmFit1)

# Variable Imp
gbmImp <- varImp(gbmFit1, scale = FALSE)


# Adaptive Resampling
fitControl2 <- trainControl(method = "adaptive_cv",
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
set.seed(825)
gbmFit2 <- train(x = training_x,
                 y = training_y,
                 method = "gbm",
                 trControl = fitControl2,
                 preProc = c("center", "scale", "pca"),
                 tuneLength = 8,
                 metric = "ROC")

# Class Distince Calculation
centroids <- classDist(trainBC, trainMDRR)
distances <- predict(centroids, testBC)
distances <- as.data.frame(distances)
head(distances)

xyplot(dist.Active ~ dist.Inactive,
       data = distances,
       groups = testMDRR,
       auto.key = list(columns = 2))
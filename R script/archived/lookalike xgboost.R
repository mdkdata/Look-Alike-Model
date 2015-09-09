print(" Building xgbTree caret model")
xgtrain = xgb.DMatrix(data = sparse.model.matrix(~., data = predictor),label = response)
xgval = xgb.DMatrix(data = sparse.model.matrix(~., data = valPredictor),label = valResponse)
xgbTree_caret <- train(x = predictor,
                       y = response,
                       method = "xgbTree",
                       tuneGrid = expand.grid(nrounds = 10*(10:100),
                                              eta = c(0.04),
                                              max_depth = c(5)),                            
                       trControl = trainControlxgbTree,
                       watchlist = list(val = xgval,train = xgtrain),
                       eval_metric = "error",
                       min_child_weight = 10,
                       #early.stop.round = 50,
                       printEveryN = 20,
                       subsample = 0.6,
                       verbose = 1,
                       colsample_bytree =0.8,
                       base_score = 0.5,
                       nthread =8#,
                       #preProcess = c("center","scale")
                       #                        ,tuneLength = 100
)

plot(xgbTree_caret)

predTrainxgbTree_caret = predict.train(xgbTree_caret,newdata = predictor, type = "prob")
print("Confusion Matrix of prediction on training set")
table(response, predTrainxgbTree_caret[,2]>0.5)
auc_train = as.numeric(performance(prediction(predTrainxgbTree_caret[,2],response),"auc")@y.values)
print("Plot ROC for training set")
plot.roc(response, predTrainxgbTree_caret[,2],print.thres = seq(00.05,0.95, by = 0.05))
print("AUC for prediction on training set")
auc_train# # 
print("Weighted AUC for prediction on training set")
roc_auc_truncated(labels = as.numeric(response),predictions = predTrainxgbTree_caret[,2])

predValxgbTree_caret = predict(models$xgbTree1,newdata = valPredictor, type = "prob")
print("Confusion Matrix of prediction on validation set")
table(valResponse, predValxgbTree_caret[,2]>0.5)
auc_val_xgb = as.numeric(performance(prediction(predValxgbTree_caret[,2],valResponse),"auc")@y.values)
print("Plot ROC for training set")
plot.roc(valResponse, predValxgbTree_caret[,2],print.thres = seq(00.05,0.95, by = 0.05))
print("AUC for prediction on validation set")
auc_val_xgb# # 
print("Weighted AUC for prediction on validation set")
roc_auc_truncated(labels = as.numeric(valResponse),predictions = predValxgbTree_caret[,2])

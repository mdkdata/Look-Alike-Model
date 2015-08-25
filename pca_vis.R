setwd('/Users/ivanliu/Google Drive/Clients/Coles/FCO Model')
fco_dt <- read.csv('../FCO Model/FCO.csv')
llo_dt <- read.csv('../FCO Model/LLO.csv')
head(fco_dt);
dim(fco_dt);dim(llo_dt)

#########################
### Feature Selection ###
#########################
# round(cor(fco_dt[,1:4]), 2)
# cols <-
#     colnames(fco_dt)[c(
#         1,3,5,6,7,8,21:28,30:90,124:139,140,143,146:150,152,154:155,160:163,167:175,177:204,206:207
#     )]
# table(fco_dt[,187])
cols <-
    colnames(fco_dt)[c(
        1,2,5,6,8,21:28,124:139,140:141,152,154:155,160:163,172:173,176,187:189, 196:204,206:207 #177:186, 190:195
    )]

fco <- fco_dt[,cols]
llo <- llo_dt[,cols]
#str(fco[,99:147])
fco[,c('LOYALTY_RANK_NUMBER')] <-
    as.factor(fco[,c('LOYALTY_RANK_NUMBER')])
# fco[,c('MBR_RES_PCODE')] <- as.factor(fco[,c('MBR_RES_PCODE')])
fco$target <- 1

llo[,c('LOYALTY_RANK_NUMBER')] <-
    as.factor(llo[,c('LOYALTY_RANK_NUMBER')])
# llo[,c('MBR_RES_PCODE')] <- as.factor(llo[,c('MBR_RES_PCODE')])
llo$target <- 0

######################
### Dummy Variable ###
######################
library(caret)
all_df <- rbind(fco,llo)
dim(all_df)
dummies <- dummyVars(target ~ ., data = all_df)
all_dum <- predict(dummies, newdata = all_df)

head(all_dum[,c(3,4,7,16,17)])
all_dum <- all_dum[,-c(3,4,7,16,17)]
# for (i in 1:ncol(fco)) {
#     if (is.factor(fco[,i])) {
#         print(i)
#         print(levels(fco[,i]))
#     }
# }

all_dum[which(is.na(all_dum))] <- 0

########################
### NearZeroVariable ###
########################
nzv <- nearZeroVar(all_dum, saveMetrics= TRUE)
nzv[nzv$nzv,][1:100,]
nzv <- nearZeroVar(all_dum)
all_dum_nzv <- all_dum[, -nzv]

###########
### PCA ###
###########
pc <-
    princomp(
        all_dum[,2:(ncol(all_dum) - 1)], cor = TRUE, scores = TRUE, center = TRUE,
        scale. = TRUE
    )
summary(pc)
plot(pc,type = "lines")
# biplot(pc)

### Caret PCA ###
# trans <- preProcess(all_dum_nzv[,2:(ncol(all_dum_nzv) - 1)], 
#                     method=c("BoxCox", "center", 
#                              "scale", "pca"))
# PC <- predict(trans, all_dum_nzv[,2:(ncol(all_dum_nzv) - 1)])

###############
### K-means ###
###############
set.seed(42)
cl <- kmeans(all_dum[,2:(ncol(all_dum) - 1)],3)
all_dum <- as.data.frame(all_dum)
all_dum$cluster <- as.factor(cl$cluster)

############
### PLOT ###
############
# 3-D PCA plot
library(rgl)
plot3d(pc$scores[,1:3], col = all_df$target + 1, main="FirstChoice vs. Others")
plot3d(pc$scores[,1:3], col=all_dum$cluster, main="k-means clusters")

# 2-D PCA plot
# library(ggbiplot)
# g <- ggbiplot(
#     pc[,1:2], obs.scale = 1, var.scale = 1,
#     groups = all_df$target, ellipse = TRUE,
#     circle = TRUE
# )
# g <- g + scale_color_discrete(name = '')
# g <- g + theme(legend.direction = 'horizontal',
#                legend.position = 'top')
# print(g)
#
plot(pc$scores[which(all_df$target == 1),1:2], col= 'blue', main='PCA of Different Member Groups')
points(pc$scores[which(all_df$target == 0),1:2], col = 'red')

plot(pc$scores[which(all_df$cluster == 1),1:2], col= 'blue', main='PCA of Different Member Groups')
points(pc$scores[which(all_df$cluster == 2),1:2], col = 'red')
points(pc$scores[which(all_df$cluster == 3),1:2], col = 'green')

# xyplot(Comp.1 ~ Comp.2,
#        data = cbind(pc$scores[,1:2],all_df$target),
#        groups = target,
#        auto.key = list(columns = 2))
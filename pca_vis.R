setwd('/Users/ivanliu/Google Drive/Clients/Coles/FCO Model')
fco_dt <- read.csv('../FCO Model/FCO.csv')
llo_dt <- read.csv('../FCO Model/LLO.csv')
head(fco_dt);
dim(fco_dt);dim(llo_dt)

### Feature Selection ###
# round(cor(fco_dt[,1:4]), 2)
cols <- colnames(fco_dt)[c(1,3,5,6,7,8,21:28,30:90,124:139,140,143,146:150,152,154:155,160:163,167:175,177:204,206:207)]

fco <- fco_dt[,cols]
#str(fco[,99:147])
fco[,c('LOYALTY_RANK_NUMBER')] <- as.factor(fco[,c('LOYALTY_RANK_NUMBER')])
fco[,c('MBR_RES_PCODE')] <- as.factor(fco[,c('MBR_RES_PCODE')])
fco$target <- 1

### Dummy Variable ###
library(caret)
dummies <- dummyVars(target ~ ., data = fco)
head(predict(dummies, newdata = fco))

for (i in 1:ncol(fco)){
    if(is.factor(fco[,i])){
        print(i)
        print(levels(fco[,i]))
    }
}

colnames(fco)[7]




### PCA ###
pc <- princomp(fco_dt[,1:4], cor=TRUE, scores=TRUE)
summary(pc)
plot(pc,type="lines")

biplot(pc)

# 3-D PCA plot
library(rgl)
plot3d(pc$scores[,1:3], col=iris$Species)

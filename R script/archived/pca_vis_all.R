setwd('C:\\Users\\iliu2\\Documents\\8.Ad-hoc analytics\\LookAlike')
fco_dt <- read.csv('data/fco.csv')
llo_dt <- read.csv('data/llo.csv')
coleso_dt <- read.csv('data/coleso.csv')
eshop_dt <- read.csv('data/eshop.csv')
targeto_dt <- read.csv('data/targeto.csv')
webjet_dt <- read.csv('data/webjet.csv')
webTran_dt <- read.csv('data/webTran.csv')

dim(fco_dt);dim(llo_dt);dim(coleso_dt);dim(eshop_dt);dim(targeto_dt);dim(webjet_dt);dim(webTran_dt)
head(fco_dt)
# fco_dt[which(fco_dt$MOSAIC_DESC=='n/a'),5] <- '-'
fco <- fco_dt[,-c(1,6,7,9,13,17,19,25,27,29,35)]
llo <- llo_dt[,-c(1,6,7,9,13,17,19,25,27,29,35)]
coleso <- coleso_dt[sample(1:nrow(coleso_dt),10000),-c(1,6,7,9,13,17,19,25,27,29,35)]
eshop <- eshop_dt[,-c(1,6,7,9,13,17,19,25,27,29,35)]
targeto <- targeto_dt[sample(1:nrow(targeto_dt),10000),-c(1,6,7,9,13,17,19,25,27,29,35)]
webjet <- webjet_dt[sample(1:nrow(webjet_dt),10000),-c(1,6,7,9,13,17,19,25,27,29,35)]
dim(fco);dim(llo);dim(coleso);dim(eshop);dim(targeto);dim(webjet)
head(fco);str(fco);colnames(fco)
for (i in 1:ncol(fco)){
  if(i %in% c(11:40,42:43,45,47:49)){
    fco[,i] <- as.numeric(fco[,i])
  }else{
    fco[,i] <- as.factor(fco[,i])
  }
}
for (i in 1:ncol(llo)){
  if(i %in% c(11:40,42:43,45,47:49)){
    llo[,i] <- as.numeric(llo[,i])
  }else{
    llo[,i] <- as.factor(llo[,i])
  }
}

for (i in 1:ncol(coleso)){
  if(i %in% c(11:40,42:43,45,47:49)){
    coleso[,i] <- as.numeric(coleso[,i])
  }else{
    coleso[,i] <- as.factor(coleso[,i])
  }
}
for (i in 1:ncol(eshop)){
  if(i %in% c(11:40,42:43,45,47:49)){
    eshop[,i] <- as.numeric(eshop[,i])
  }else{
    eshop[,i] <- as.factor(eshop[,i])
  }
}

for (i in 1:ncol(targeto)){
  if(i %in% c(11:40,42:43,45,47:49)){
    targeto[,i] <- as.numeric(targeto[,i])
  }else{
    targeto[,i] <- as.factor(targeto[,i])
  }
}

for (i in 1:ncol(webjet)){
  if(i %in% c(11:40,42:43,45,47:49)){
    webjet[,i] <- as.numeric(webjet[,i])
  }else{
    webjet[,i] <- as.factor(webjet[,i])
  }
}

### PCA ###
fco$target <- 'fco'
llo$target <- 'llo'
coleso$target <- 'coleso'
eshop$target <- 'eshop'
targeto$target <- 'targeto'
webjet$target <- 'webjet'

fco$col <- 1
llo$col <- 2
coleso$col <- 3
eshop$col <- 4
targeto$col <- 5
webjet$col <- 6

all_dt <- rbind(fco,llo, coleso,eshop,targeto,webjet)
all_dt$target <- as.factor(all_dt$target)

library(caret)
dim(all_dt)
dummies <- dummyVars(target ~ ., data = all_dt[,-ncol(all_dt)])
all_dum <- predict(dummies, newdata = all_dt[,-ncol(all_dt)])

all_dum[which(is.na(all_dum))] <- 0

### save data 
save(all_dum,all_dt, file='data/data.RData')
load('data/data.RData')

pc <- princomp(all_dum, cor = F, scores = TRUE, center = TRUE, scale. = TRUE)
summary(pc)
plot(pc,type = "lines")

### t-SNE
library(ggplot2)
library(readr)
library(Rtsne)

set.seed(1)
features <- all_dum

tsne <- Rtsne(as.matrix(features), check_duplicates = FALSE, pca = TRUE, initial_dims=50,
              perplexity=30, theta=0.5, dims=2)

embedding <- as.data.frame(tsne$Y)
embedding$Class <- as.factor(all_dt$target)

p <- ggplot(embedding, aes(x=V1, y=V2, color=Class)) +
  geom_point(size=1.25) +
  guides(colour = guide_legend(override.aes = list(size=6))) +
  xlab("") + ylab("") +
  ggtitle("t-SNE 2D Embedding of Products Data") +
  theme_light(base_size=20) +
  theme(strip.background = element_blank(),
        strip.text.x     = element_blank(),
        axis.text.x      = element_blank(),
        axis.text.y      = element_blank(),
        axis.ticks       = element_blank(),
        axis.line        = element_blank(),
        panel.border     = element_blank())
p

### k-means
set.seed(42)
cl <- kmeans(all_dum,3)
all_dum <- as.data.frame(all_dum)
all_dum$cluster <- as.factor(cl$cluster)

### 3d plot
library(rgl)
plot3d(pc$scores[,1:3], col = all_dt$col, main="FirstChoice vs. Others")
plot3d(pc$scores[,1:3], col=all_dum$cluster, main="k-means clusters")

plot3d(embedding[,1:3], col = all_df$target + 1, main="FirstChoice vs. Others")
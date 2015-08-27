setwd('/Users/ivanliu/Google Drive/Clients/Coles/FCO Model')
fco_dt <- read.csv('../FCO Model/fco.csv')
llo_dt <- read.csv('../FCO Model/llo.csv')
coleso_dt <- read.csv('../FCO Model/coleso.csv')
eshop_dt <- read.csv('../FCO Model/eshop.csv')
targeto_dt <- read.csv('../FCO Model/targeto.csv')
webjet_dt <- read.csv('../FCO Model/webjet.csv')
webTran_dt <- read.csv('../FCO Model/webTran.csv')

dim(fco_dt);dim(llo_dt);dim(coleso_dt);dim(eshop_dt);dim(targeto_dt);dim(webjet_dt);dim(webTran_dt)
head(fco_dt)
# fco_dt[which(fco_dt$MOSAIC_DESC=='n/a'),5] <- '-'
fco <- fco_dt[,-c(1,6,7,9,13,17,19,25,27,29,35)]
llo <- llo_dt[,-c(1,6,7,9,13,17,19,25,27,29,35)]
coleso <- coleso_dt[,-c(1,6,7,9,13,17,19,25,27,29,35)]
eshop <- eshop_dt[,-c(1,6,7,9,13,17,19,25,27,29,35)]
targeto <- targeto_dt[,-c(1,6,7,9,13,17,19,25,27,29,35)]
webjet <- webjet_dt[,-c(1,6,7,9,13,17,19,25,27,29,35)]
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

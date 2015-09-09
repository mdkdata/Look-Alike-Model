
# Forked from https://www.kaggle.com/forums/t/13122/visualization/68866
# which was written by https://www.kaggle.com/users/8998/piotrek
# 
# Key differences from original:
# - downsampling to 15000 train examples to run quickly on Kaggle Scripts
# - using ggplot2 for plotting

library(ggplot2)
library(readr)
library(Rtsne)

set.seed(1)
num_rows_sample <- 15000

train        <- read_csv("../input/train.csv")
train_sample <- train[sample(1:nrow(train), size = num_rows_sample),]
features     <- train_sample[,c(-1, -95)]
features <- all_dum[,-c(1,151)]

tsne <- Rtsne(as.matrix(features), check_duplicates = FALSE, pca = TRUE, 
              perplexity=30, theta=0.5, dims=2)

embedding <- as.data.frame(tsne$Y)
embedding$Class <- as.factor(sub("Class_", "", all_dum[,151]))

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

ggsave("tsne.png", p, width=8, height=6, units="in")

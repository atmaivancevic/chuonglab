#!/usr/bin/env Rscript

# R script to make boxplots of control vs cancer samples
# Example usage:
# Rscript --vanilla repeat_boxplot.R giggleMatrix.tab MER57E3 MER57E3.png

library(ggplot2)
library(ggpubr)

args = commandArgs(trailingOnly=TRUE)
# args[1] = input matrix
# args[2] = repeat of interest
# args[3] = output file name

giggleScore <- read.table(args[1], sep="\t", header = TRUE, row.names=1)

# set to the repeat of interest
ervName = args[2]
#ervName

ervRes <- giggleScore[c(ervName),]
ervRes <- t(ervRes)
ervRes

# Assign control vs tumour vs test
condition <- factor(c(rep("control", 7), rep("cancer", 32), rep("tumour", 4)))
condition <- data.frame(condition)

test <- cbind(ervRes, condition)

colnames(test) <- c("score", "group")

test$group <- as.factor(test$group)

all_comparisons <- list( c("control", "cancer"), c("control","tumour"), c("cancer", "tumour") )
#all_comparisons

png(file = args[3], width = 6, height = 6, units = 'in', res = 300)

ggplot(test, aes(x=group, y=score, fill=group)) + geom_boxplot() + geom_jitter(shape=16, position=position_jitter(0), size=3) + ggtitle(ervName) + theme(plot.title = element_text(hjust = 0.5, size=15), axis.text=element_text(size=10)) + labs(y="giggle score", x = "group") + stat_compare_means(comparisons = all_comparisons, method = "t.test", label = "p.signif")

dev.off()
q(save="yes")

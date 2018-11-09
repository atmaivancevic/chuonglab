# Read in the tab-delimited count table
setwd("~/Documents/giggleScoreMatrices/")
giggleScore <- read.table("giggleMatrix_LTR10.tab", sep="\t", header = FALSE, row.names=1)

head(giggleScore)

colnames(giggleScore) <- c("c28","c29","c37","crypt5","CRC17A","CRC23A","CRC6A","CRC7A","HCT116","SW480","COLO205","V1009","V1024","V1051","V1058","V1074","V1106","V206","V389","V410","V411","V429","V456","V481","V576","V5","V784","V852","V855","V866","V940","V968")

head(giggleScore)

LTR10A <- giggleScore[c("LTR10A"),]
LTR10A

LTR10A_control <- LTR10A[1:4]
LTR10A_control

LTR10A_tumour <- LTR10A[5:8]
LTR10A_tumour

LTR10A_crc <- LTR10A[9:32]
LTR10A_crc

LTR10A

LTR10A <- t(LTR10A)
LTR10A

# Assign control vs tumour vs test
condition <- factor(c(rep("control", 4), rep("tumour", 4), rep("crc", 24)))
condition

condition <- data.frame(condition)
condition

test <- cbind(LTR10A, condition)
test

colnames(test) <- c("score", "group")

test$group <- as.factor(test$group)
test

library(ggplot2)
#install.packages("ggpubr")
library(ggpubr)

all_comparisons <- list( c("control", "crc"), c("crc", "tumour"), c("control","tumour") )
all_comparisons

control_cancer <- list( c("control", "crc"))

ggplot(test, aes(x=group, y=log10(score), fill=group)) + geom_boxplot() + geom_jitter(shape=16, position=position_jitter(0), size=3) + ggtitle("LTR10A") + theme(plot.title = element_text(hjust = 0.5, size=15), axis.text=element_text(size=10)) + labs(y="log10 (giggle score)", x = "group") + stat_compare_means(comparisons = all_comparisons, method = "t.test", label = "p.signif")

##########################################################
# Or could make a scatterplot


sample <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32)
sample

new2 <- cbind(new, sample)
new2

colnames(new2) <- c("combo", "condition", "sample")
new2

new2 <- data.frame(new2)
new2

library(ggplot2)

# make a scatterplot
ggplot(data=new2, aes(x=sample, y=log2(combo))) + 
ggtitle("LTR10A") +
theme(plot.title = element_text(hjust = 0.5), legend.position="right") +
labs(y="log2 (giggle score)", x = "sample") +
geom_point(data=new2[which(new2$condition == 1),], colour = "royalblue1", stroke=2, size=1)  +
geom_point(data=new2[which(new2$condition == 2),], colour = "red", stroke=2, size=1) +
geom_point(data=new2[which(new2$condition == 3),], colour = "orange", stroke=2, size=1) 

# or make a box plot
ggplot(data=new2, aes(x=sample, y=log2(combo), fill=group)) + geom_boxplot()

##########################################################################
# can also plot the odds against sig from giggle result table

fc <-c(2.3893203695794685,2.0250954179818095,1.7499392799738336,2.0965950837722982,4.6324736950691143,1.423788719794723,2.8526503798375082,3.2574099216174437,4.6054915873074398,1.5516519297346487,8.1938294020023434,7.4564246758110579,5.8703518209059595,7.5350717577883906,7.8748762733475992,6.572669740186269,8.2870891428645095,10.459038050960936,8.5159187753536418,4.9284940071026933,8.9996722459466412,4.7621542634263863,10.197961071806926,4.256644254694983,4.6251957974839666,6.3961081623126255,5.8497098818853726,8.2745396449146291,9.3788631025231073,6.5548205109362625,8.5602471638684019,15.29855927128453)

fc

pval <- c(1.2155581414455133e-05,0.0048496896292206544,0.0086049728426150202,0.0020238523424633891,6.9039351628180539e-21,0.14264257899324535,3.3683515506785475e-10,6.1384717723785749e-11,1.3391590246280703e-18,0.084566271334186062,3.3272549882957477e-45,3.6180588082335391e-24,2.1099203368185282e-30,4.856944370344407e-27,4.3917516494243456e-43,1.2432522254784449e-28,5.3251151544514651e-46,3.8022372228734809e-44,1.6116203805087984e-53,3.1780173012187357e-28,6.0297263969030182e-41,1.3136028370315338e-16,4.5219439668245608e-47,2.8857115050736393e-13,3.5188456871292501e-22,4.2094353275570754e-21,6.6605665603896247e-24,3.7666790079812513e-08,1.671782725960832e-45,1.0154763558775744e-22,4.1370207260998875e-23,6.6834438003039709e-67)

pval

new3 <- cbind(new2, fc, pval)
new3

new3 <- data.frame(new3)

ggplot(new3, aes(x=log2(fc), y=-log10(pval))) + 
ggtitle("LTR10A") +
theme(plot.title = element_text(hjust = 0.5)) +
geom_point(data=new3[which(new3$condition == 1),], colour = "royalblue1", stroke=2, size=1)  +
geom_point(data=new3[which(new3$condition == 2),], colour = "red", stroke=2, size=1) +
geom_point(data=new3[which(new3$condition == 3),], colour = "orange", stroke=2, size=1) 

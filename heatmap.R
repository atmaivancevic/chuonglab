#source("https://bioconductor.org/biocLite.R")
#biocLite("DESeq2")

if (!require("gplots")) {
   install.packages("gplots", dependencies = TRUE)
   library(gplots)
   }
if (!require("RColorBrewer")) {
   install.packages("RColorBrewer", dependencies = TRUE)
   library(RColorBrewer)
   }


# Read in the tab-delimited count table
setwd("~/Documents/giggleScoreMatrices/")
giggleScore <- read.table("giggleMatrix_LTR10.tab", sep="\t", header = FALSE, row.names=1)

head(giggleScore)

colnames(giggleScore) <- c("c28","c29","c37","crypt5","CRC17A","CRC23A","CRC6A","CRC7A","HCT116","SW480","COLO205","V1009","V1024","V1051","V1058","V1074","V1106","V206","V389","V410","V411","V429","V456","V481","V576","V5","V784","V852","V855","V866","V940","V968")

head(giggleScore)

giggleScore <- as.matrix(giggleScore)
head(giggleScore, 50)

scaled_giggle <- scale(giggleScore)


dummy <- head(giggleScore, 50)
dummy

my_palette <- colorRampPalette(c("blue", "white", "red"))(n = 256)

# creates a 5 x 5 inch image
png("heatmaps_in_r.png",    # create PNG for the heat map        
  res = 300,            # 300 pixels per inch
  height = 800,
  width = 800,
  pointsize = 4)        # smaller font size

heatmap.2(giggleScore,  # same data set for cell labels
  main = "Dummy", # heat map title
  notecol="black",      # change font color of cell labels to black
  density.info="none",  # turns off density plot inside color legend
  trace="none",         # turns off trace lines inside the heat map
  margins =c(12,9),     # widens margins around plot
  scale=c("column"),
  col=my_palette)       # use on color palette defined earlier


dev.off()               # close the PNG device


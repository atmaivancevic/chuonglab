source("https://bioconductor.org/biocLite.R")
biocLite("DESeq2")

# Read in the tab-delimited count table
setwd("/Users/atmaivancevic/Documents/bamCountMatrices")
countdata <- read.table("bamCountsPerRegion_cohen2017_d100.tab", sep="\t", header = FALSE)

head(countdata)

# Set fourth column to be the rownames
rownames(countdata) <- countdata[,4]
head(countdata)

# Remove the first four columns (chr, start, stop, regionlabel)
countdata <- countdata[,5:ncol(countdata)]
head(countdata)

# Add bam names as column names
colnames(countdata) <- c("c28","c29","c37","crypt5","CRC17A","CRC23A","CRC6A","CRC7A","HCT116","SW480","COLO205","V1009","V1024","V1051","V1058","V1074","V1106","V206","V389","V410","V411","V429","V456","V481","V576","V5","V784","V852","V855","V866","V940","V968")
head(countdata)

# Convert table to matrix format
countdata <- as.matrix(countdata)
head(countdata)

# Assign control vs test samples
condition <- factor(c(rep("control", 4), rep("cancer", 28)))

# Create a "coldata" table containing the sample names with their appropriate condition (e.g. control versus cancer sample)
coldata <- data.frame(row.names=colnames(countdata), condition)
coldata
head(countdata)

# Construct a DESeqDataSet

library("DESeq2")

dds <- DESeqDataSetFromMatrix(countData = countdata,
                              colData = coldata,
                              design = ~ condition)

dds
dds$condition <- relevel(dds$condition, ref = "control")
dds

dds
dds <- DESeq(dds)
resultsNames(dds)

res_cancer_vs_control <- results(dds, contrast=c("condition", "cancer", "control"))
head(res_cancer_vs_control)

res_cancer_vs_control <- na.omit(res_cancer_vs_control)
head(res_cancer_vs_control)

res_cancer_vs_control <- res_cancer_vs_control[order(res_cancer_vs_control$padj), ]
table(res_cancer_vs_control$padj<0.05)

plotMA(res_cancer_vs_control, ylim=c(-10,10))

# extract only baseMean less than 10
res_cancer_vs_control_baseMean <- subset(res_cancer_vs_control, baseMean < 10)
res_cancer_vs_control_baseMean_logFC <- subset(res_cancer_vs_control_baseMean, log2FoldChange >3)
res_cancer_vs_control_baseMean_logFC
plotMA(res_cancer_vs_control_baseMean, ylim=c(-10,10))

max(res_cancer_vs_control$baseMean)

# extract only signficant padj values
res_cancer_vs_control_padj <- subset(res_cancer_vs_control, padj < 0.05)
head(res_cancer_vs_control_padj)

# replot it
plotMA(res_cancer_vs_control_padj, ylim=c(-10,10))

# extract only signficant padj values
res_cancer_vs_control_padj_fc <- subset(res_cancer_vs_control_padj_fc, padj < 0.05)
head(res_cancer_vs_control_padj)

### Merge your results table with the normalized count data table.
res_cancer_vs_control_merged <- merge(as.data.frame(res_cancer_vs_control), as.data.frame(counts(dds, normalized = TRUE)), by = "row.names", sort = FALSE)

head(res_cancer_vs_control)

res_cancer_vs_control_padj <- subset(res_cancer_vs_control, padj < 0.05)
res_cancer_vs_control_padj

plotMA(res_cancer_vs_control_padj, ylim=c(-10,10))

res_cancer_vs_control_highFCandhighMean <- subset(res_cancer_vs_control, abs(log2FoldChange) > 1 & baseMean > 7000)
plotMA(res_cancer_vs_control_highFCandhighMean, ylim=c(-10,10))
res_cancer_vs_control_highFCandhighMean




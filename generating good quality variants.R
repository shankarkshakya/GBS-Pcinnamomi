
rm(list = ls())
library(vcfR, quietly = T)
library(poppr, quietly = T)
library(ggplot2, quietly = T)
library(reshape2, quietly = T)

replicates <- read.vcfR("replicates_8samples.vcf.gz", verbose = FALSE)

dp <- extract.gt(replicates, element = "DP", as.numeric=TRUE)
quants <- apply(dp, MARGIN=2, quantile, probs=c(0.05, 0.95), na.rm=TRUE)
dp2 <- sweep(dp, MARGIN=2, FUN = "-", quants[1,])
dp[dp2 < 0] <- NA
dp2 <- sweep(dp, MARGIN=2, FUN = "-", quants[2,])
dp[dp2 > 0] <- NA
dp[dp < 10] <- NA
replicates@gt[,-1][ is.na(dp) == TRUE ] <- NA

dp <- extract.gt(replicates, element = "DP", as.numeric=TRUE)
myMiss <- apply(dp, MARGIN = 1, function(x){ sum( is.na(x) ) } ) #number of NA per variant
myMiss <- myMiss / ncol(dp)
replicates <- replicates[myMiss == 0, ] # tolerate upto % missing data.

# 8 samples
# 630 CHROMs
# 72,267 variants
# Object size: 42.3 Mb
# 0 percent missing data


## Subset large vcf file by previously identified variants from replicates

library(mypackage)
raw_vcf <- read.vcfR("Pcinna242.rmdup.gvcf2vcf.vcf.gz", verbose = FALSE)
raw_vcf <- raw_vcf[ , -(grep("Rep2.fq|Rep3.fq", colnames(raw_vcf@gt)))]

vcf.gatk <- subset_vcf2vcf(raw_vcf, replicates)
vcf.gatk

# 236 samples
# 630 CHROMs
# 72,267 variants
# Object size: 284.1 Mb
# 3.323 percent missing data


dp <- extract.gt(vcf.gatk, element = "DP", as.numeric=TRUE)
quants <- apply(dp, MARGIN=2, quantile, probs=c(0.05, 0.95), na.rm=TRUE)
dp2 <- sweep(dp, MARGIN=2, FUN = "-", quants[1,])
dp[dp2 < 0] <- NA

dp2 <- sweep(dp, MARGIN=2, FUN = "-", quants[2,])
dp[dp2 > 0] <- NA

dp[dp < 4] <- NA

vcf.gatk@gt[,-1][ is.na(dp) == TRUE ] <- NA

dp <- extract.gt(vcf.gatk, element = "DP", as.numeric=TRUE)
myMiss <- apply(dp, MARGIN = 1, function(x){ sum( is.na(x) ) } ) #number of NA per variant
myMiss <- myMiss / ncol(dp)
vcf.gatk <- vcf.gatk[myMiss < 0.1, ] # tolerate upto % missing data.

vcf.gatk

# 236 samples
# 437 CHROMs
# 26,043 variants
# Object size: 107.9 Mb
# 7.751 percent missing data



## Filtering samples

dp <- extract.gt(vcf.gatk, element = "DP", as.numeric=TRUE)
myMiss <- apply(dp, MARGIN = 2, function(x){ sum( is.na(x))} ) # number of NA per sample
myMiss <- myMiss / nrow(dp)
vcf.gatk@gt <- vcf.gatk@gt[, c(TRUE, myMiss < 0.1)]


df <- as.data.frame(vcf.gatk@gt)
id <- rownames(df[rowSums(!is.na(df)) == 209,])
id <- as.numeric(id)

vcf.gatk <- vcf.gatk[id,]

gt <- as.data.frame(extract.gt(vcf.gatk))

all_typed <- gt[rowSums(is.na(gt)) == 0, ]

loci <- rownames(all_typed)

fix <- as.data.frame(vcf.gatk@fix)
id <- fix$ID

filter <- as.numeric(rownames(fix[fix$ID %in% loci, ]))
vcf.gatk <- vcf.gatk[filter, ]

vcf.gatk 

# 208 samples
# 310 CHROMs
# 6,372 variants
# Object size: 26.3 Mb
# 0 percent missing data

Psojae <- read.vcfR("Psojae.vcf")

# 1 samples
# 968 CHROMs
# 1,381,887 variants
# Object size: 327.6 Mb
# 0.03481 percent missing data


final_vcf <- subset_vcf2vcf(vcf.gatk, Psojae)


final_vcf <- extract.indels(final_vcf)
final_vcf <- final_vcf[is.biallelic(final_vcf), ]


#write.vcf(final_vcf, "Good_895variants.gz")

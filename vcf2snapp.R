library(vcfR, quietly = T)
library(poppr, quietly = T)
library(ggplot2, quietly = T)
library(reshape2, quietly = T)

vcf <- read.vcfR("Min10x_cov_203isolates_1027Variants.gz")

vcf <- extract.indels(vcf)

id <- unlist(strsplit(colnames(vcf@gt)[-1], split = ".fq"))
pcinna_pop <- read.csv("New Microsoft Excel Worksheet.csv", header = TRUE)
pcinna_pop <- pcinna_pop[pcinna_pop$Isolate %in% id, ]
pcinna_pop <- pcinna_pop[match(id, pcinna_pop$Isolate), ]

pop_cinna <- pcinna_pop$Country

pop_cinna_sojae <- as.factor(c(as.character(pop_cinna), "Psojae"))

vcf_cinna_sojae <- vcf
colnames(vcf_cinna_sojae@gt)[204] <- "Psojae"

vcf_cinna <- vcf[ , -ncol(vcf_cinna_sojae@gt)]




# colnames(vcf_cinna@gt)
# pop_cinna
# 
# tips <- unlist(strsplit(colnames(vcf_cinna@gt)[-1], split = ".fq"))
# tips <- unlist(lapply(strsplit(tips, "-"), function(x) x[2]))
# 
# tips <- paste(tips, pop_cinna, sep = "_")
# 
# tips[184:202] <- paste0(seq(1:19), tips[184:202])

# 
# colnames(vcf_cinna@gt)[-1] <- tips

vcf_cinna
pop_cinna

vcf_popsub <- function(vcf, pop, in_pop) {
  ids <- which(pop %in% in_pop)
  ids <- ids+1
  vcf <- vcf[, c(1,ids)]
  
  return(vcf)
  
}

in_pop <- c("Portugal", "Taiwan", "Australia", "USA", "Vietnam", "Chile")

vcf_cinna <- vcf_popsub(vcf = vcf_cinna, pop = pop_cinna, in_pop = in_pop)

id <- unlist(strsplit(colnames(vcf_cinna@gt)[-1], split = ".fq"))
pcinna_pop <- read.csv("New Microsoft Excel Worksheet.csv", header = TRUE)
pcinna_pop <- pcinna_pop[pcinna_pop$Isolate %in% id, ]
pcinna_pop <- pcinna_pop[match(id, pcinna_pop$Isolate), ]

pop_cinna <- pcinna_pop$Country


## Subset to different size

source("R/subset_vcfbypop.R")

p <- subset_vcfbypop(vcf_cinna, pop_cinna)

set.seed(100)

vcf_5 <- lapply(p, function(x) x[ , c(1,sample(2:ncol(x@gt), size = 5, replace = F))])

new_vcf <- vcf_5[[1]]

new_vcf@gt <- cbind(vcf_5$Portugal@gt, vcf_5$Taiwan@gt[, -1], vcf_5$Australia@gt[, -1], vcf_5$USA@gt[, -1],vcf_5$Vietnam@gt[, -1],vcf_5$Chile@gt[, -1])


colnames(new_vcf@gt)

id <- unlist(strsplit(colnames(new_vcf@gt)[-1], split = ".fq"))
pcinna_pop <- read.csv("New Microsoft Excel Worksheet.csv", header = TRUE)
pcinna_pop <- pcinna_pop[pcinna_pop$Isolate %in% id, ]
pcinna_pop <- pcinna_pop[match(id, pcinna_pop$Isolate), ]

pop_cinna <- pcinna_pop$Country

tips <- unlist(strsplit(colnames(new_vcf@gt)[-1], split = ".fq"))
tips <- unlist(lapply(strsplit(tips, "-"), function(x) x[2]))

tips <- paste(tips, pop_cinna, sep = "_")

tips[16:19] <- paste0(seq(1:4), tips[16:19])



library(adegenet)
library(strataG)
 y <- vcfR2genind(new_vcf)
 indNames(y) <- tips

y <- genind2gtypes(y)

write.nexus.snapp(y, "vcf_cinna_3pop.snapp.data.nex")


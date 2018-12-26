rm(list = ls())
library(vcfR)
library(vimes)
library(mypackage)

vcf <- read.vcfR("vcf_cinna_202isolates_1010SNPs.gz")
vcf <- vcf[ , -c(grep("NewGuin", colnames(vcf@gt)))]

id <- unlist(strsplit(colnames(vcf@gt)[-1], split = ".fq"))

pcinna_pop <- read.csv("New Microsoft Excel Worksheet (1).csv", header = TRUE)
pcinna_pop <- pcinna_pop[pcinna_pop$Isolate %in% id, ]
pcinna_pop <- pcinna_pop[match(id, pcinna_pop$Isolate), ]
pop_cinna <- pcinna_pop$Continent

continent <- as.character(pcinna_pop$Continent)
country <- as.character(pcinna_pop$Country)

continent[grep("Taiwan", country)] <- "Taiwan"
continent[grep("Vietnam", country)] <- "Vietnam"
continent[grep("Australia", country)] <- "Australia"
continent[grep("North_America", continent)] <- "North America"
continent[grep("South_America", continent)] <- "South America"

country_continent_mixpop <- continent
new_pop <- as.factor(country_continent_mixpop)

mycol <- c("#0000FF", "#FFFF00","#ff0000","#00FFFF","#FFC0CB","#00ff00","#FF00FF")
#plot(1:7, 1:7, col = mycol, pch = 19, cex = 2)

levels(new_pop) <- mycol
mycol <- new_pop


id <- 2:ncol(vcf@gt)-1
colnames(vcf@gt)[2:ncol(vcf@gt)] <- id

vcf_gl <- vcfR2genlight(vcf)
vcf_dist <- dist(vcf_gl)

out <- vimes_data(vcf_dist)
res <- vimes(out, cutoff = mean(vcf_dist))

#tiff("vimes.tiff", width = 7, height = 7, res = 600, units = "in")

plot(res$graph, vertex.color = as.character(mycol), 
     vertex.size = 4, edge.color="black", vertex.label = NA)


legend("topleft", legend = sort(unique(country_continent_mixpop)),
       pch = 22, pt.bg=levels(mycol), pt.cex=4, cex=1.2, 
       bty = "n", y.intersp = 0.55)





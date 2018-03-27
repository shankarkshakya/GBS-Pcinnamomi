
rm(list =ls())
library(reshape2)
library(vcfR)
library(ggplot2)

qmat_files <- list.files("./299_variants/qmatrices/")
source("admix_plot.R")
plot_list <- vector("list", length(qmat_files))
x <- read.vcfR("vcf_204cinnaisolates_299variants.gz")
id <- unlist(strsplit(colnames(x@gt)[-1], split = ".fq"))
pcinna_pop <- read.csv("New Microsoft Excel Worksheet.csv", header = TRUE)
pcinna_pop <- pcinna_pop[pcinna_pop$Isolate %in% id, ]
pcinna_pop <- pcinna_pop[match(id, pcinna_pop$Isolate), ]

continent <- as.character(pcinna_pop$Continent)
country <- as.character(pcinna_pop$Country)

continent[grep("Taiwan", country)] <- "Taiwan"
continent[grep("Vietnam", country)] <- "Vietnam"

country_continent_mixpop <- continent
pop <- country_continent_mixpop

for (k in 1:length(qmat_files)) {
  source("admix_plot.R")
  qmat <- read.table(file.path("./299_variants/qmatrices/", qmat_files[k]))
  colnames(qmat) <- paste("Group", seq(1:ncol(qmat)), sep = ".")
  qmat <- cbind(pop, qmat)
  i <- sapply(qmat, is.factor)
  qmat[i] <- lapply(qmat[i], as.character)
  qmat <- qmat[qmat$pop != "Oceania", ]
  # key <-  c("AUS" = "AUS", "Africa"= "AF",
  #           "Europe"= "EURO", "North_America"= "N_America",
  #           "South_America"= "S_America","Oceania"= "OCN", "Taiwan" = "TWN", "Vietnam" = "VNM")
  # 
  key <-  c("AUS" = "AUS", "Africa"= "AF",
            "Europe"= "EURO", "North_America"= "N.AMERICA",
            "South_America"= "S.AMERICA","Oceania"= "OCN", "Taiwan" = "TWN", "Vietnam" = "VNM")
  
  qmat$pop <- factor(key[qmat$pop], ordered = TRUE, levels = key)
  #qmat$pop <- factor(key[qmat$pop], levels = unique(qmat$pop)[c(2,4,3,6,1,5,7)], ordered = T)
  
  qmat$pop <- factor(key[qmat$pop], levels = unique(qmat$pop)[c(5,7,1,4,3,6,2)], ordered = T)
  
  #temp_plot <- admix_plot(qmat, horiz = F, sort.probs = F, col = c("#191919", "#C20088", "#FF0010"))
  # working: test <- c("#191919", "#0075DC", "#C20088", "#FF0010","#993F00", "#4C005C", "#005C31", "#2BCE48", "#FFCC99", "#808080", "#94FFB5")
  test <- c("#191919", "#0075DC", "#C20088", "#FF0010","#FFA8BB", "#4C005C", "#005C31", "#2BCE48", "#FFCC99", "#808080", "#94FFB5")
  temp_plot <- admix_plot(qmat, horiz = F, sort.probs = T, col = test)
  temp_plot <- temp_plot + theme(axis.text.x = element_text(angle = 0, size = 12, face = "bold")) 
  
  plot_list[[k]] <- temp_plot
  
} 



library(cowplot)

# x <- plot_list[4:5]
# myplot_list <- lapply(x[1:2], function(x) x + theme(axis.text.x=element_blank()))
# myplot_list <- c(myplot_list, x[3])
# plot_grid(plotlist = myplot_list[3], nrow = 3, ncol = 1, hjust = 1)


## Save individual K
#tiff("./FIGS/ADMIXTURE_k5.tiff", width = 18, height = 3, units = "in", res = 600)
plot_list[[5]]

#dev.off()



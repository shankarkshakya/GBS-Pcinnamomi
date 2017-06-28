
library(vcfR)

vcf <- read.vcfR("MAF_Filtered.vcf.gatk6262.gz", verbose = FALSE)

mypca <- readRDS("vcf.gatk.nf20_pca.RData")
pcascores <- mypca$scores
rownames(pcascores) <- unlist(strsplit(rownames(pcascores), split = ".fq"))
pcinna_pop <- read.csv("Pcinna_pop.csv", header = TRUE)
pcinna_pop <- pcinna_pop[pcinna_pop$Isolate %in% rownames(pcascores), ]
pcinna_pop <- pcinna_pop[match(rownames(pcascores), pcinna_pop$Isolate), ]
newpca_pop <- cbind(pcinna_pop, pcascores)
pop_vec <- newpca_pop$Country

vcfR2migrate <- function(vcf, pop_vec) {

vcf <- extract.indels(vcf, return.indels = F) #Removing indels
vcf <- vcf[is.biallelic(vcf)]

gt <- extract.gt(vcf, return.alleles = T, convertNA = T)
gt <- gt[!rowSums((is.na(gt))),]

FORMAT <- vcf@gt[1:nrow(gt),1]
vcf@gt <- cbind(FORMAT, gt)



vcf_list <- vector("list", length(unique(pop_vec)))
names(vcf_list) <- unique(pop_vec)
 
for (i in (1:length(vcf_list))) {
  temp_pop <- names(vcf_list[i])
  temp_vcf <- vcf
  FORMAT <- vcf@gt[,1]
  gt <- temp_vcf@gt[, -1]
  
  cols <- gt[ , which(names(vcf_list[i]) == pop_vec)]
  
  temp_vcf@gt <- cbind(FORMAT, cols)
  
 
  vcf_list[[i]] <- temp_vcf

}

n.pop <- vector("list", length(vcf_list))
names(n.pop) <- names(vcf_list)
for ( i in 1:length(vcf_list)) {

    pop1 <- vcf_list[[i]]

    gt <- pop1@gt

    all <- vector("list", nrow(gt))
      
    for (j in 1:nrow(gt)){
        ind <- gt[j, -1]
        all[[j]] <- as.data.frame(unlist(strsplit(ind, "/")))
    }
    
n.pop[[i]] <- do.call("rbind", all)

}


for (i in 1:length(n.pop)) {
  temp.pop <- n.pop[[i]]
  names <- rownames(temp.pop)
  rownames(temp.pop) <- NULL
  temp.pop <- cbind(names,temp.pop)
  indnum <- nrow(temp.pop)/ (2*nrow(vcf@gt))
  colnames(temp.pop) <- c(indnum, names(n.pop)[[i]])
  #loci.length <-  rep(1, nrow(vcf@gt))
  
  write.table(temp.pop, file = paste(names(n.pop[i]), ".txt"), sep = "\t", row.names = F, quote = F)
  
}


loci.length <-  rep(1, nrow(vcf@gt))

}

vcfR2migrate(vcf, pop_vec = pop_vec)







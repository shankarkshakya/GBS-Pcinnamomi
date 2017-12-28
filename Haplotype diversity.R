vcf
pop


library(mypackage)

list_vcf <- sublist_vcfbypop(vcf, pop)
Htype <- vector("list", length(list_vcf))
names(Htype) <- names(list_vcf)

for (i in 1:length(Htype)){
  gt <- extract.gt(list_vcf[[i]], element = "GT", return.alleles = T)
  gt <- alleles2consensus(gt)
  gt <- t(gt)
  gt_bin <- ape::as.DNAbin(gt)
  h <- haplotype(gt_bin)
  #net <- haploNet(h) 
  #Htype[[i]] <- plot(net, size=attr(net, "freq"), scale.ratio = 2, cex = 0.8)
  Htype[[i]] <- h
}


gt <- extract.gt(vcf[,-199], element = "GT", return.alleles = T)
gt <- alleles2consensus(gt)
gt <- t(gt)
gt_bin <- ape::as.DNAbin(gt)

rownames(gt_bin) <- paste("Pop", pop[-198],sep = "_")

h <- haplotype(gt_bin)
f.pop <- haploFreq(gt_bin, haplo = h)
rownames(f.pop) <- paste("Haplotype", 1:nrow(f.pop), sep = "_")

f.pop <- as.data.frame(f.pop)

barplot(colSums(f.pop > 0) / colSums(f.pop)) ##Haplotypic diversity
barplot(colSums(f.pop > 0) /3) ##Haplotypic diversity corrected for sample size min



par(mfrow = c(2,1))
pie(f.pop[1,])
pie(f.pop[2,])
## Four unique haplotypes
f.pop[c( which(rowSums(f.pop) == 1)), ]
f.pop[c( which(rowSums(f.pop) == 2)), ]
f.pop[c( which(rowSums(f.pop) == 4)), ]
f.pop



nt <- haploNet(h)

fq <- attr(nt, "freq")
plot(nt, size = fq, pie = f.pop, labels= F)
plot(nt, size=attr(nt, "freq"), scale.ratio = 1, cex = 1, pie=f.pop, labels = F)

legend(-150,100, colnames(f.pop), col=rainbow(ncol(f.pop)), pch=20)

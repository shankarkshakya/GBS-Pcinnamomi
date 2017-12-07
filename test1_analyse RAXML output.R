
## Converting vcf genotype to RAXML phylip format file

test_vcf <- read.vcfR("test.vcf.gz")

# output genotype
gt.filtered <- extract.gt(test_vcf, return.alleles = T)

#get.alleles(gt.filtered)
p <- alleles2consensus(gt.filtered, sep = "/")
gt.df <- apply(p, 2, function (x) paste(x, collapse = ""))

gt.df <- gsub(pattern = "/", "", gt.df, fixed = T)
#write.table(gt.df, file = "multistate.data.phy", quote = F)


library(ape)
p <- read.tree("RAxML_bootstrap.result")
class(p)

tree1 <- p[[1]]

plot(tree1)


id <- unlist(strsplit(tree1$tip.label, split = ".fq"))

pcinna_pop <- read.csv("New Microsoft Excel Worksheet.csv", header = TRUE)
pcinna_pop <- pcinna_pop[pcinna_pop$Isolate %in% id, ]
pcinna_pop <- pcinna_pop[match(id, pcinna_pop$Isolate), ]

pcinna_pop <- pcinna_pop[-nrow(pcinna_pop),]



pop <- as.character(pcinna_pop$Country)
pop[198] <- "Psojae"

pop <- as.factor(pop)

library(ggtree)
countryInfo <- split(tree1$tip.label, pop)
tree2 <- groupOTU(tree1, countryInfo)

tree2$tip.label <- as.character(pop)

ggtree(tree2, aes(color=group, label = node), layout="circular") + 
  geom_tiplab(size=5, aes(angle=angle))

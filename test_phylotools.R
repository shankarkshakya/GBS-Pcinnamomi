
mytree <- read.tree("RAxML_bestTree.Pcinna_sojae_203")
mytree <- drop.tip(mytree, "Psojae")

#mytree <- read.nexus("33ind_snap.trees.MCC.tre")

id <- unlist(strsplit(mytree$tip.label, split = ".fq"))
pcinna_pop <- read.csv("New Microsoft Excel Worksheet.csv", header = TRUE)
pcinna_pop <- pcinna_pop[pcinna_pop$Isolate %in% id, ]
pcinna_pop <- pcinna_pop[match(id, pcinna_pop$Isolate), ]

pop_cinna <- pcinna_pop$Country


tips <- unlist(strsplit(mytree$tip.label, split = ".fq"))
tips <- unlist(lapply(strsplit(tips, "-"), function(x) x[2]))

#tips <- paste(tips, pop_cinna, sep = "_")
#which(duplicated(tips))

len <- length(which(duplicated(tips)))
tips[which(duplicated(tips))] <- paste0(seq(1:len), tips[which(duplicated(tips))])

mytree$tip.label <- tips



ids <- as.data.frame(mytree$tip.label)

ids[2] <- pop_cinna
rownames(ids) <- ids$`mytree$tip.label`
ids <- ids[2]
ids <- as.matrix(ids)[, 1]

tree <- mytree
x <- ids

#plotTree(tree,type="fan",fsize=0.8,ftype="i", show.tip.label = F)
plot.phylo(tree, type = "fan", show.tip.label = F)

cols <- setNames(alphabet(n=17)[1:length(unique(x))],sort(unique(x)))

tiplabels(pie=to.matrix(x,sort(unique(x))),piecol=cols,cex=0.3)

add.simmap.legend(colors=cols,prompt=T,x=0.9*par()$usr[1],
                  y=-max(nodeHeights(tree)),fsize=0.8)


fitER <- ace(x,tree,model = "ER", type="discrete")
fitER

#plotTree(ladderize(tree),type="fan",fsize=0.5,ftype="i")
plot.phylo(tree, type = "fan", show.tip.label = F)

nodelabels(node=1:tree$Nnode+Ntip(tree),
           pie=fitER$lik.anc,piecol=cols,cex=0.3)

tiplabels(pie=to.matrix(x,sort(unique(x))),piecol=cols,cex=0.2)

add.simmap.legend(colors=cols,prompt=TRUE,x=0.9*par()$usr[1],
                  y=-max(nodeHeights(tree)),fsize=0.9)



rspp <- as.data.frame(fitER$lik.anc[1, ])
colnames(rspp) <- "RSPP"
rspp <- cbind(pop = rownames(rspp), rspp)
rownames(rspp) <- NULL

library(ggplot2)

ggplot(data = rspp) + aes(x = pop, y = RSPP, fill = pop) + geom_bar(stat = "identity") 
  




#########

mtree <- make.simmap(tree,x,model="ER")

plot(mtree,cols,type="fan",fsize=0.8,ftype="i")
add.simmap.legend(colors=cols,prompt=FALSE,x=0.9*par()$usr[1],
                  y=-max(nodeHeights(tree)),fsize=0.8)


mtrees <- make.simmap(tree,x,model="ER",nsim=100)

par(mfrow=c(10,10))
null <- sapply(mtrees,plot,colors=cols,lwd=1,ftype="off")


pd <- summary(mtrees,plot=FALSE)
pd

plot(pd,fsize=0.6,ftype="i")

plot(mtrees[[1]],cols,type="fan",fsize=0.8,ftype="i")
nodelabels(pie=pd$ace,piecol=cols,cex=0.5)
add.simmap.legend(colors=cols,prompt=FALSE,x=0.9*par()$usr[1],
                  y=-max(nodeHeights(tree)),fsize=0.8)


plot(fitER$lik.anc,pd$ace,xlab="marginal ancestral states",
     ylab="posterior probabilities from stochastic mapping")
lines(c(0,1),c(0,1),lty="dashed",col="red",lwd=2)

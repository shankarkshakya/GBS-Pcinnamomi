
library(vcfR)

vcf <- read.vcfR("MAF_Filtered.vcf.gatk6262.gz", verbose = FALSE)

pop_vec <- structure(c(7L, 7L, 9L, 9L, 9L, 9L, 9L, 9L, 9L, 7L, 7L, 9L, 9L, 
                       7L, 9L, 9L, 9L, 9L, 9L, 9L, 9L, 9L, 9L, 9L, 9L, 9L, 9L, 9L, 9L, 
                       9L, 9L, 9L, 9L, 9L, 7L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 
                       1L, 7L, 1L, 1L, 8L, 8L, 8L, 8L, 8L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 
                       1L, 1L, 1L, 1L, 10L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 6L, 6L, 1L, 
                       10L, 10L, 10L, 10L, 10L, 10L, 10L, 10L, 10L, 10L, 10L, 10L, 2L, 
                       2L, 2L, 2L, 2L, 7L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 5L, 5L, 
                       5L, 5L, 5L, 4L, 4L, 4L, 4L, 3L, 3L, 3L, 3L, 3L, 3L, 6L, 6L, 9L, 
                       9L, 9L, 9L, 9L, 9L, 9L), .Label = c("Australia", "Chile", "Dominican Republic", 
                                                           "France", "Italy", "PNG", "Portugal", "South Africa", "Taiwan", 
                                                           "Vietnam"), class = "factor")

vcfR2migrate <- function(vcf, pop) {

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


migrate_pop <- n.pop
  
for (i in 1:length(n.pop)) {
  temp.pop <- n.pop[[i]]
  names <- rownames(temp.pop)
  rownames(temp.pop) <- NULL
  temp.pop <- cbind(names,temp.pop)
  indnum <- nrow(temp.pop)/ (2*nrow(vcf@gt))
  colnames(temp.pop) <- c(indnum, names(n.pop)[[i]])
  
  migrate_pop[[i]] <- temp.pop
  
  #write.table(temp.pop, file = paste(names(n.pop[i]), ".txt", sep = ""), sep = "\t", row.names = F, quote = F)
  
}

loci_length <- rep(1, nrow(vcf@gt))

return(list(loci_length = loci_length, migrate_pop = migrate_pop))

#return(migrate_pop)

}




contries <- c("Taiwan", "Australia")
output_path <- file.path("test.txt")
data_to_write <- x$migrate_pop[sapply(x$migrate_pop, function(x) any(colnames(x) %in% contries))]

# write header
header <- paste0("N ", length(data_to_write), " ", length(x$loci_length), "\n", paste(x$loci_length, collapse = " "))
writeLines(header, output_path)

# write data
for (frame in data_to_write) {
  write.table(frame, file = output_path, append = TRUE, quote = FALSE, sep = "\t", row.names = FALSE, col.names = TRUE)
}

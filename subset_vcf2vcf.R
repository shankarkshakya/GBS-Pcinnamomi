
##Subset a large vcf by variants from smaller set of vcf file.


subset_vcf2vcf <- function(vcf1, vcf2) {

      vcf1@fix[,3] <- paste(vcf1@fix[,1], vcf1@fix[,2], sep = "_")
      vcf2@fix[,3] <- paste(vcf2@fix[,1], vcf2@fix[,2], sep = "_")
      
  
      vcf1.df <- as.data.frame(vcf1@fix)
      vcf2.df <- as.data.frame(vcf2@fix)
      
      row_id <- as.numeric(rownames(subset(vcf1.df, vcf1.df$ID %in% vcf2.df$ID)))
      
      new_vcf <- vcf1[row_id, ]
      
      return(new_vcf)
  

}




vcf2SNAPP <- function(all.vcf, file = "snapp.nex.out") {
              
              gt.filtered <- extract.gt(all.vcf, element = "GT", as.numeric = T, convertNA = T)
             
              gt.filtered <- t(gt.filtered)
              
              ape::write.nexus.data(gt.filtered, file)
              
              snapp.file <- scan(file, what = "character", sep = "\n", 
                                 quiet = TRUE)
              
              bgn <- grep("BEGIN", snapp.file)
              snapp.file[bgn] <- "BEGIN CHARACTERS;"
              fmt <- grep("FORMAT", snapp.file)
              snapp.file[fmt] <- "  FORMAT DATATYPE=STANDARD MISSING=? GAP=- SYMBOLS=\"012\" LABELS=LEFT TRANSPOSE=NO INTERLEAVE=NO;"
              
              #return(snapp.file)
              write(snapp.file, file)
              
}

vcf_cinna <- vcf_cinna[1:10, 1:11]

vcf2SNAPP(all.vcf = vcf_cinna)





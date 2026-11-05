library(coloc)
library(tidyverse)

#coloc
gwas<-read.table('gwas.txt',header = T)
eqtl<-read.table('eqtl.txt',header = T)
input <- merge(eqtl, gwas, by="rs_id", all=FALSE, suffixes=c("_eqtl","_gwas"))
result <- coloc.abf(dataset1=list(pvalues=input$pval_nominal_gwas, type="cc", s=0.33, N=50000), dataset2=list(pvalues=input$pval_nominal_eqtl, type="quant", N=10000), MAF=input$MAF)
need_result1=result$results %>% filter(SNP.PP.H4 > 0)
write.table('coloc_result.txt',file=filename,quote=F,sep='\t',eol='\n',row.names = F,col.names = T)

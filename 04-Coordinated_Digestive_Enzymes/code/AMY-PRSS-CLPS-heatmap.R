# using pheatmap to plot. See also in https://zhuanlan.zhihu.com/p/370477638
library(pheatmap)

KGP_avgCN<-read.table("../KGP-AMY-PRSS-CLPS-heatmap.txt", row.names=1,header=TRUE)

popu<-c("MSL","YRI","FIN","MXL","CEU","TSI","BEB","GIH","PJL","STU","JPT","CHB","CHS","CDX","KHV")
Group<-c("AFR","AFR","EUR","AMR","EUR","EUR","SAS","SAS","SAS","SAS","EAS","EAS","EAS","EAS","EAS")
popu_label<-as.data.frame(Group)
rownames(popu_label)<-popu

range_norm<-function(x) {  # 0-1 normalization
  y=(x-min(x))/(max(x)-min(x))
  return(y)
  }

normed<-apply(KGP_avgCN,1,range_norm)
KGP_avgCN_normed<-as.data.frame(t(normed))

pheatmap(KGP_avgCN_normed, clustering_method = 'ward.D', cluster_rows = FALSE, legend_breaks = c(0, 1), legend_labels = c("low", "high"),cellwidth = 15,cellheight = 15, cutree_cols = 4, annotation_col = popu_label)
# clustering method only ward.D as expected！


#----------------------------------------------------------
# remove AMR populations, only AFR, EUR, SAS, EAS included!

KGP_avgCN<-read.table("../KGP-AMY-PRSS-CLPS-heatmap.txt", row.names=1,header=TRUE)
KGP_avgCN_exAMR<-KGP_avgCN[,colnames(KGP_avgCN)!="MXL"]

popu<-c("MSL","YRI","FIN","CEU","TSI","BEB","GIH","PJL","STU","JPT","CHB","CHS","CDX","KHV")
Group<-c("AFR","AFR","EUR","EUR","EUR","SAS","SAS","SAS","SAS","EAS","EAS","EAS","EAS","EAS")
popu_label<-as.data.frame(Group)
rownames(popu_label)<-popu

range_norm<-function(x) {  # 0-1 normalization
  y=(x-min(x))/(max(x)-min(x))
  return(y)
}

normed<-apply(KGP_avgCN_exAMR,1,range_norm)
KGP_avgCN_normed<-as.data.frame(t(normed))

pheatmap(KGP_avgCN_normed, clustering_method = 'ward.D', cluster_rows = FALSE, legend_breaks = c(0, 1), legend_labels = c("low", "high"),cellwidth = 15,cellheight = 15, cutree_cols = 4, annotation_col = popu_label)

# heatmap with red and yellow color
pheatmap(KGP_avgCN_normed, 
         clustering_method = 'ward.D', cluster_rows = FALSE, 
         legend_breaks = c(0, 1), legend_labels = c("low", "high"),
         cellwidth = 15,cellheight = 15, cutree_cols = 4, 
         color =colorRampPalette(c("yellow","red"))(100),
         annotation_col = popu_label, 
         annotation_colors = list(Group=c(AFR="DarkBlue",EUR="DarkGreen",SAS="Blue",EAS="Green")))

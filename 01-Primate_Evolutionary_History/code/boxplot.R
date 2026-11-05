library(ggplot2)
library(magrittr)
library(ggpubr)
data<-read.table("compHap_human_AFR_v4_copyall.txt",header=T)
#data<-read.table("compHap_chimp-human_v4_copyall.txt",header=T)
#data$pop=factor(data$pop, levels=c("SGDP_WEU","UYG","HAN"))
#,fill="",palette=c("#5BC0EB","#9BC53D","#E55934")
ggboxplot(data, x = "hap", y = "dist")+ 
theme(legend.position="none",
	axis.title.x=element_text(size=16,hjust=0.5),
	axis.title.y=element_text(size=16,hjust=0.5),
	axis.text.x=element_text(size=16,color="black",
		angle=45,vjust=0.5),
	axis.text.y=element_text(size=16,color="black"),
	legend.text=element_text(size=20)) + 
#stat_compare_means(method = "t.test",
#	comparisons = list(c("SGDP_WEU", "UYG"), c("UYG", "HAN")),
#	label="p.signif",label.x=c(1,1),
#	label.y = c(1290,1300)) + 
labs(x = "", y = 'Base differences')
#ylim(1100,1330)
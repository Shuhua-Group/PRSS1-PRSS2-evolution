library(ggplot2)
library(magrittr)
library(ggthemes)
library(ggpubr)
library(Rmisc)
library(showtext)
#showtext_auto(enable=T)
#font_add('Arial', regular = '/Library/Fonts/Arial Unicode.ttf')

#pdf('CN5.recom.pdf',width=5.5,height=5)
#pd <- position_dodge(0.8)

data<-read.table("CN3+5.recom.txt",header=T)
#data<-read.table("CN5.recom.txt",header=T)
#data<-read.table("CN3.recom.txt",header=T)

#datac<-summarySE(data, measurevar="perc", groupvars=c("ANC","type"))

#data$ANC=factor(data$ANC, levels=c("5-ANC","4-AFR","3-2SHR","2-1SHR","1-XJU"))
#datac$ANC=factor(datac$ANC, levels=c("5-ANC","4-AFR","3-2SHR","2-1SHR","1-XJU"))
#datac$type=factor(datac$type, levels=c("OregAnno","TFBS","bivalent_enh","HiC","polycomb","promoter","genic_enh","intergenic_enh"))
ggplot(data=data,aes(x=POS,y=REC,group=POP,colour=POP))+
#labs(y="SV size")+
#geom_violin(data=data,aes(x=ANC,y=length,fill=ANC),alpha=0.7)+
#geom_errorbar(aes(ymin=perc-sd, ymax=perc+sd),width=.1,position=pd)+
geom_line()+
geom_point()+
labs(y="Recombination")+
theme_few()+
theme(legend.title = element_blank(),
	legend.key.size = unit(1,'lines'),
	legend.text=element_text(size=9,family="Arial"),
	#legend.pos="top",
	axis.title.x=element_blank(),
	axis.title.y=element_text(size=12,hjust=0.5,vjust=1.5),
	axis.text.x=element_text(size=12,color="black"),
	axis.text.y=element_text(size=12,color="black"))+
#scale_x_discrete(breaks=c("10.681","21.292","31.755"),
#	labels=c("copy1","copy2","copy3/5"))
#scale_y_continuous(breaks=c(0,0.2,0.4,0.6),labels=c("0%","20%","40%","60%"))+
scale_colour_manual(values=c("#247BA0","#228B22","#F77F00"),
	labels=c("CEU","CHB","YRI"))
#dev.off()
#,"","#F25F5C","#247BA0","#FCBF49","#70C1B3"



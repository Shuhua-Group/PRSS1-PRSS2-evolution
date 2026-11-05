library(ggplot2)
library(dplyr)
library(ggsignif)


# function to calculate sd
data_summary <- function(data, varname, groupnames){
  require(plyr)
  summary_func <- function(x, col){
    c(mean = mean(x[[col]], na.rm=TRUE),
      sd = sd(x[[col]], na.rm=TRUE))
  }
  data_sum<-ddply(data, groupnames, .fun=summary_func,
                  varname)
  data_sum <- rename(data_sum, c("mean" = varname))
  return(data_sum)
}

setwd("D:\work\PRSS-evo\experiment\PRSS2_enhancer_experiment")
# Read data
exp_data<-read.table("../ggplot-dual_luc_exp_20231222.txt", header=TRUE)

# Generate data summary
exp_data_summary <- data_summary(exp_data, varname="Ratio", 
                                 groupnames="Group")

# ANOVA
fit<-aov(Ratio~Group, data=exp_data)
anova_res<-summary(fit)
p_anova<-round(anova_res[[1]][[5]][1],3)


# publication v2 remove control
p<-ggplot(exp_data_summary, aes(x=Group, y=Ratio, fill=Group)) + 
  geom_bar(stat="identity", 
           color="black",
           position=position_dodge()) +
  geom_point(exp_data, aes(x=Group, y=Ratio), position=position_jitter(w=0.2, h=0))+
  scale_fill_manual(values=c('#56B4E9','#E69F00','#E69F00','#E69F00','#E69F00'))+
  geom_errorbar(aes(ymin=Ratio-sd, ymax=Ratio+sd), width=.2,
                position=position_dodge(.9)) +
  labs(y = "Luc/R-Luc")+
  theme_classic() +
  geom_signif(data=exp_data, aes(x=Group, y=Ratio),
              comparisons=list(c("PRSS2", "PRSS2-PRSS3P2_peak1"), 
                               c("PRSS2", "PRSS2-PRSS3P2_peak2"), 
                               c("PRSS2", "PRSS2-TRY7_peak1"), 
                               c("PRSS2", "PRSS2-TRY7_peak2")),
              test="t.test", 
              test.args=list(alternative = "less", paired=TRUE),
              map_signif_level=TRUE,
              y_position=c(3.4,3.8,4.2,4.6)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 14),
        axis.text.y = element_text(size = 14),
        legend.position="none",
        plot.title=element_text(hjust=0.5, face="bold")) +
  labs(x="")
ggsave("PRSS2_lucifer.jitter.pdf", p, dpi=300, width=6, height=6, units="in")



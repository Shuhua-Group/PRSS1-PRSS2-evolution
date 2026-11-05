library(ggplot2)

dat<-read.table('CLPS.Pancreas.6_35786859_35798675.data.txt',sep = '\t',header = T)

#eQTL
cov_names <- paste0("covs",1:53)
form_eqtl <- as.formula(paste("exp ~ cnv +", paste(cov_names, collapse = "+")))
out <- summary(lm(form_eqtl, data = dat))
list1 <- out$coef[,1]
list2 <- as.matrix(list1)
l1 <- rownames(list2)
dat_reg <- dat
dat_reg$cnv <- as.numeric(as.character(dat_reg$cnv))
out_reg <- summary(lm(form_eqtl, data = dat_reg))
SV <- out_reg$coef[2,1]
SVse <- out_reg$coef[2,2]
SVp <- out_reg$coef[2,4]

#箱线图
dat$cnv <- factor(dat$cnv, levels = c("2","3","4","5","6"))
ggplot(dat, aes(x=cnv,y=exp))+
  stat_boxplot(
    color='#5A4290',
    geom = "errorbar",
    width=0.15,
    linewidth=1)+ 
  geom_boxplot(
    color='#5A4290',
    size=1,
    width=0.5,
    outlier.colour = NA)+
  geom_jitter(
    color='#838383',
    width =0.2,
    shape = 20,
    size=2.5) +
  annotate("text", x = Inf, y = -Inf, 
           label = paste0("p-value: ", format(SVp, scientific = TRUE, digits = 3)), 
           hjust = 1.1, vjust = -0.8, size = 5) +
  theme_bw() +
  theme(
    panel.grid.major=element_blank(),
    panel.grid.minor=element_blank(),
    axis.line= element_line(colour = "black"),
    axis.text = element_text(color="black", size=12),
    axis.title = element_text(color="black", size=14)) +
  labs(
    x="6_35786859_35798675",
    y="CLPS expression level",
    title = 'Pancreas')
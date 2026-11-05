library(ggplot2)
library(ggpmisc)
library(ggpubr)

df<-read.table('chr7_142773135_A_G_b38_ase_PRSS1-PRSS2.value1.txt',header = T,row.names = 1)

p1<-ggplot(df, aes(x = ref_ratio, y = value)) +
  geom_point(shape = 16, colour = "#00AFBB", size = 2) +
  geom_smooth(method = "lm", color = "#00AFBB", fill = "#00AFBB",
              alpha = 0.2, fullrange = TRUE) +
  stat_cor(method = "pearson") +
  scale_x_continuous(breaks = c(0, 0.25, 0.5, 0.75, 1), limits = c(0, 1)) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(),
        plot.title = element_text(hjust = 0.5)) +
  labs(x = 'Ref Ratio', y = 'PRSS1/PRSS2 Ratio',
       title = 'chr7_142751439_C_T_b38')

p2<-ggplot(df, aes(x = "ASE", y = ref_ratio)) +
  geom_violin(trim = FALSE, fill = "#00AFBB", color = "black") +
  geom_boxplot(width = 0.12, fill = "white",
               outlier.shape = NA, coef = 0) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(),
        axis.title.x = element_blank(),
        plot.title = element_text(hjust = 0.5)) +
  labs(y = 'PRSS1/PRSS2 Ratio',
       title = 'chr7_142751439_C_T_b38')

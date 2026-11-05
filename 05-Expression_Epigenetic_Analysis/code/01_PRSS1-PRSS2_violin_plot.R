library(ggplot2)

df_all<-read.table('chr7_142770582_A_G_b38_value_Pancreas.paired.txt',header = T,sep = '\t')
col_vec <- c("5/5"="#603896", "3/5"="#3388bb", "3/3"="#60ad5e")

ggplot(df_all, aes(x = genotype, y = value, fill = genotype)) +
  geom_violin(scale = "width", trim = F) +
  geom_boxplot(width = 0.2, fill = "white", outlier.shape = NA) +
  scale_fill_manual(values = col_vec) +
  labs(y = "PRSS2 expression", x = "") +
  theme_bw() +
  theme(
    legend.position = "none",
    axis.text = element_text(size = 14),
    axis.title.y = element_text(size = 16)
  )
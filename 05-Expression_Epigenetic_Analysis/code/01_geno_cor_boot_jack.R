library(ggplot2)

df_all <- read.table("PRSS1_PRSS2.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)
# 基因型拆分
d0  <- df_all[df_all$genotype == "0", c("sample","PRSS1","PRSS2","genotype")]
da1 <- df_all[df_all$genotype == "1", c("sample","PRSS1","PRSS2","genotype")]
da2 <- df_all[df_all$genotype == "2", c("sample","PRSS1","PRSS2","genotype")]

rownames(d0)  <- d0$sample
rownames(da1) <- da1$sample
rownames(da2) <- da2$sample

n_boot <- 999
p1 <- numeric(n_boot) # 
p2 <- numeric(n_boot) 

row.name1 <- rownames(da1)
row.name2 <- rownames(da2)

#Bootstrap 999次，每次抽43个无放回
for (i in 1:n_boot) {
  sam.row.name1 <- sample(row.name1, 43, replace = FALSE)
  sam.row.name2 <- sample(row.name2, 43, replace = FALSE)
  
  d1 <- da1[sam.row.name1, ]
  d2 <- da2[sam.row.name2, ]
  
  d1file <- paste0('d1/d1-', i, '.txt')
  d2file <- paste0('d2/d2-', i, '.txt')
  
  write.table(d1, file = d1file, sep = "\t", quote = F, row.names = F)
  write.table(d2, file = d2file, sep = "\t", quote = F, row.names = F)
  
  p1[i] <- cor(d1[,2], d1[,3], method = "pearson")
  p2[i] <- cor(d2[,2], d2[,3], method = "pearson")
}

# 提取中位数对应的那一次抽样样本：
#3/5 0.608383750650843   299
#5/5 0.479179876907937   545
idx_35 <- which.min(abs(p1 - median(p1)))
idx_55 <- which.min(abs(p2 - median(p2)))

cat("3/5中位数对应序号：", idx_35, "\n")
cat("5/5中位数对应序号：", idx_55, "\n")

#读取中位数对应的文件
d1_mid <- read.table(paste0('./d1/d1-', idx_35, '.txt'), header = T, sep = "\t")
d2_mid <- read.table(paste0('./d2/d2-', idx_55, '.txt'), header = T, sep = "\t")

row.name0  <- rownames(d0)
row.name1_mid <- d1_mid$sample
row.name2_mid <- d2_mid$sample

# Jackknife循环：42次，每次抽42个
n_jack <- 42
p0_jack <- numeric(n_jack) #3/3
p1_jack <- numeric(n_jack) #3/5
p2_jack <- numeric(n_jack) #5/5

for (i in 1:n_jack) {
  sam.row.name0  <- sample(row.name0, 42, replace = FALSE)
  sam.row.name1m <- sample(row.name1_mid, 42, replace = FALSE)
  sam.row.name2m <- sample(row.name2_mid, 42, replace = FALSE)
  
  dd0 <- d0[sam.row.name0, ]
  dd1 <- d1299[d1299$sample %in% sam.row.name1m, ]
  dd2 <- d2543[d2543$sample %in% sam.row.name2m, ]
  
  p0_jack[i] <- cor(dd0[,2], dd0[,3], method = "pearson")
  p1_jack[i] <- cor(dd1[,2], dd1[,3], method = "pearson")
  p2_jack[i] <- cor(dd2[,2], dd2[,3], method = "pearson")
}

res_jack <- data.frame(
  Genotype = c(rep("3/3", n_jack), rep("3/5", n_jack), rep("5/5", n_jack)),
  cor_r    = c(p0_jack, p1_jack, p2_jack)
)
write.table(res_jack, file = "PRSS1_PRSS2_cor.txt", sep = "\t", quote = F, row.names = F)

#密度图
df_plot <- read.table("PRSS1_PRSS2_cor.txt", header=T, sep="\t")

ggplot(df_plot, aes(x = cor, fill = Genotype)) +
  geom_histogram(
    aes(y = after_stat(density)), 
    binwidth = 0.005,
    position = "identity",      
    alpha = 0.8,
    color = NA
  ) +
  scale_fill_manual(values = color_set) +
  labs(
    x = "PRSS1 & PRSS2 correlation (R)",
    y = "Density"
  ) +
  theme_bw() +
  theme(
    panel.grid = element_line(color="gray90"),
    panel.border = element_rect(linewidth=1),
    legend.position = "bottom"
  )
#小提琴图
df_all$geno_label <- factor(df_all$genotype,
                            levels = c(2, 1, 0),   
                            labels = c("5/5", "3/5", "3/3"))

col_vec <- c("5/5"="#603896", "3/5"="#3388bb", "3/3"="#60ad5e")

ggplot(df_all, aes(x = geno_label, y = PRSS2, fill = geno_label)) +
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


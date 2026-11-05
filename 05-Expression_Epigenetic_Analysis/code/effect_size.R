
library(tidyverse)
library(ggsignif) 

#导入数据==============
# 数据:
# genotype: 0/1/2
# PRSS1：PRSS1 TPM
# PRSS2：PRSS2 TPM

dat <- read.csv("your_data.csv") 


#计算两个基因TPM中位数
median_prss1 <- median(dat$PRSS1)
median_prss2 <- median(dat$PRSS2)

#bootstrap次数：100次
n_boot <- 100
#样本总数
n_sample <- nrow(dat)

#新建空列表，保存每次结果
boot_res <- list()

#bootstrap
# 固定随机种子，结果可复现set.seed(123) 
for (i in 1:n_boot) {
  
  #有放回抽样
  idx <- sample(1:n_sample, size = n_sample, replace = TRUE)
  dat_boot <- dat[idx, ]
  
  #对PRSS1做eQTL
  lm1 <- lm(PRSS1 ~ genotype, data = dat_boot)
  beta_prss1 <- coef(lm1)[["genotype"]] # 提取基因型的效应β
  
  #对PRSS2做eQTL
  lm2 <- lm(PRSS2 ~ genotype, data = dat_boot)
  beta_prss2 <- coef(lm2)[["genotype"]]
  
  #归一化：effect size/该基因TPM中位数
  norm_beta_prss1 <- beta_prss1 / median_prss1
  norm_beta_prss2 <- beta_prss2 / median_prss2
  
  #存入结果
  boot_res[[i]] <- tibble(
    Gene = c("PRSS1", "PRSS2"),
    Effect_size = c(norm_beta_prss1, norm_beta_prss2)
  )
}

#结果合并
boot_df <- bind_rows(boot_res)
write.csv(boot_df, "boot_effect_size.csv", row.names = F)

#小提琴图
ggplot(boot_df, aes(x = Gene, y = Effect_size, fill = Gene)) +
  geom_violin(scale = "width", alpha = 0.8) +
  geom_boxplot(width = 0.15, fill = "white", outlier.shape = NA) +
  scale_fill_manual(values = c("PRSS1"="#ff6b6b", "PRSS2"="#00bbbb")) +
  labs(
    y = "Effect size / TPM median",
    x = "Gene",
    title = "rs2855983"
  ) +
  geom_signif(
    comparisons = list(c("PRSS1", "PRSS2")),
    test = "wilcox.test",
    map_signif_level = TRUE,
    annotations = "****",
    y_position = 0.32
  ) +
  theme_bw() +
  theme(
    legend.position = "none",
    plot.title = element_text(hjust = 0.5, size=20)
  )

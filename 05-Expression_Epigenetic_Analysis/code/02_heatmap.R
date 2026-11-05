library(tidyverse)
library(pheatmap)

df_cor <- read.table("PRSS1-PRSS2.cor.norm.heatmap.txt", header = TRUE, sep = "\t", stringsAsFactors = F)
cor_wide <- df_cor %>%
  pivot_wider(names_from = genotype, values_from = cor) %>%
  column_to_rownames("Tissue")

col_order <- c("3/3","3/5","5/5","All")
cor_wide <- cor_wide[, col_order]

# 配色：R小=绿色，R大=黄色
col_pal <- colorRampPalette(c("#205020","#60aa40","#ffff40"))(100)

#热图
p <- pheatmap(
  cor_wide,
  cluster_rows = TRUE,
  cluster_cols = FALSE,
  show_colnames = TRUE,
  show_rownames = TRUE,
  color = col_pal,
  scale = "none",
  legend = TRUE,
  legend_title = "R",
  legend_breaks = c(0.25, 0.5, 0.75),
  legend_labels = c("0.25", "0.50", "0.75"),
  treeheight_row = 30,
  treeheight_col = 0,
  border_color = NA,
  na_col = "grey90",
  cellwidth = 35,
  cellheight = 12,
  fontsize = 8,
  angle_col = 0,
  silent = TRUE
)


#   PRSS_all_exp.txt : 样本 × PRSS基因 + genotype 列
#   AMY_all_exp.txt  : 样本 × AMY基因  + genotype 列

library(tidyverse)
library(psych)      
library(paletteer)  
library(scales) 

dir_path  <- "./data_and_code/Figure2/FIG2C/"
prss_file <- file.path(dir_path, "PRSS_all_exp.txt")
amy_file  <- file.path(dir_path, "AMY_all_exp.txt")
genotypes <- c("AA", "AG", "GG")

norm_sample <- function(x) gsub("[.]", "-", x)

read_combined <- function(path) {
  d <- read.table(path, header = TRUE, row.names = 1,
                  stringsAsFactors = FALSE, check.names = FALSE)

  gi <- grep("genotype", names(d), ignore.case = TRUE)

  gt <- d[[gi]]; names(gt) <- norm_sample(rownames(d))   
  d  <- d[, -gi, drop = FALSE]                 
  m  <- sapply(d, as.numeric)                
  rownames(m) <- norm_sample(rownames(d))
  list(mat = m, genotype = gt)
}

prss <- read_combined(prss_file) 
amy  <- read_combined(amy_file)  
all_res <- list()

for (g in genotypes) {
  s_p <- names(prss$genotype)[prss$genotype == g]
  s_a <- names(amy$genotype)[amy$genotype == g]
  common <- intersect(s_p, s_a)

  X <- prss$mat[common, , drop = FALSE]  
  Y <- amy$mat[common, , drop = FALSE]   

  res <- corr.test(X, Y, method = "pearson", adjust = "none")   

  d_r <- res$r |> as.data.frame() |> rownames_to_column("rowname") |>
    pivot_longer(!rowname, names_to = "name", values_to = "R")
  d_p <- res$p |> as.data.frame() |> rownames_to_column("rowname") |>
    pivot_longer(!rowname, names_to = "name", values_to = "P")
  d <- inner_join(d_r, d_p, by = c("rowname", "name")) |>
    mutate(genotype = g)          

  all_res[[g]] <- d
}

# 把三组所有基因对合并后，做全局bonferroni校正
df_all <- bind_rows(all_res) |>
  mutate(P.adj = p.adjust(P, method = "bonferroni"))  

write.table(df_all,
            file = file.path(dir_path, "correlation_result.txt"),
            quote = FALSE, sep = "\t", eol = "\n", row.names = FALSE, col.names = TRUE)




#固定基因顺序
amy_levels <- c("AMY2B", "AMY2A", "AMY1C", "AMY1B", "AMY1A")
df_all$name     <- factor(df_all$name, levels = intersect(amy_levels, unique(df_all$name)))
df_all$genotype <- factor(df_all$genotype, levels = c("AA", "AG", "GG"))

p_bubble <- ggplot(df_all, aes(x = genotype, y = name)) +
  geom_point(aes(size = abs(R), color = P.adj)) +
  facet_wrap(~ rowname) +                
  scale_color_paletteer_c(palette = "pals::coolwarm", direction = -1,
                          limits = c(0, 0.10), breaks = c(0, 0.05, 0.10),
                          oob = scales::squish, name = "P.adj") +
  scale_size_continuous(name = "R", range = c(2, 8),
                        breaks = c(0.4, 0.6, 0.8)) +
  scale_y_discrete(limits = rev(levels(df_all$name))) +
  guides(size  = guide_legend(override.aes = list(colour = "black")),  
         color = guide_colorbar()) +
  labs(x = "Genotype", y = NULL, title = "Gene Expression Correlation",
       tag = "C") +                      
  theme_bw() +
  theme(  
        strip.text = element_text(face = "bold", size = 14),
        panel.border = element_rect(color = "grey50"),
        axis.text = element_text(color = "black", size = 11),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
        axis.title = element_text(size = 13),
        legend.text = element_text(size = 10),
        legend.title = element_text(size = 11),
        plot.title = element_text(face = "bold", hjust = 0.5),
        plot.tag = element_text(face = "bold", size = 16),
        plot.tag.position = "topleft")
ggsave(file.path(dir_path, "PRSS-AMY_corr.png"), p_bubble,width = 8, height = 7, dpi = 300)

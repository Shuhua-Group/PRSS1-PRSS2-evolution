library(WGCNA)

options(stringsAsFactors = FALSE)
enableWGCNAThreads()

powers<-1:20

load("PancreasNorm.RData")

sft<-pickSoftThreshold(
  datExpr,
  powerVector = powers
)

plot( 
  sft$fitIndices[, 1], 
  -sign(sft$fitIndices[, 3]) * sft$fitIndices[, 2], 
  type = "b", 
  xlab = "Power", 
  ylab = "Scale-free topology fit" 
)

softPower<-9

net = blockwiseModules(datExpr, power = softPower,
                       TOMType = "unsigned", 
                       minModuleSize = 30,
                       reassignThreshold = 0, mergeCutHeight = 0.25,
                       numericLabels = TRUE, pamRespectsDendro = FALSE,
                       saveTOMs = TRUE,
                       saveTOMFileBase = "Pancreas-Norm-TOM", 
                       verbose = 3
)

sizeGrWindow(12, 9)


plotDendroAndColors(net$dendrograms[[1]], mergedColors[net$blockGenes[[1]]],
                    "Module colors",
                    dendroLabels = FALSE, hang = 0.03,
                    addGuide = TRUE, guideHang = 0.05)


moduleColors <- labels2colors(net$colors) 

MEs  <- moduleEigengenes(datExpr, moduleColors)$eigengenes

MEs <- orderMEs(MEs)

MM <- as.data.frame(
  cor(datExpr, MEs, use = "pairwise.complete.obs")
)

colnames(MM) <- sub("^ME", "MM", colnames(MEs))

MM_export <- data.frame(
  GeneName = rownames(MM),
  Module = moduleColors,
  MM,
  check.names = FALSE
)

write.csv(
  MM_export,
  file = "gene_module_membership.csv",
  row.names = FALSE
)



library(GenomicFeatures)
library(AnnotationForge)
library(AnnotationDbi)
library(ArchR)
library(BSgenome)
library(BSgenome.Hsapiens.NCBI.NA12878)
library(parallel)
genomeAnnotation = createGenomeAnnotation(genome = BSgenome.Hsapiens.NCBI.NA12878)
txdb<-loadDb("/picb/humpopg-bigdata4/louhaiyi/TGS/NA12878/gencode-v34-liftoff/R-TxDb_OrgDb/txdb.NA12878.gencode34.add_PRSS3P2_TRY7.mainChr.sqlite")
orgdb<-loadDb("/picb/humpopg-bigdata4/louhaiyi/TGS/NA12878/gencode-v34-liftoff/R-TxDb_OrgDb/org.Hsapiens.eg.sqlite")
geneAnnotation <- createGeneAnnotation(TxDb = txdb, OrgDb = orgdb, annoStyle = "GID")
inputFiles='../ENCDO856ZOJ-NA12878mainChr/outs/atac_fragments.tsv.gz'
names(inputFiles)='ENCDO856ZOJ-pancreas'
ArrowFiles <- createArrowFiles(inputFiles = inputFiles, sampleNames = names(inputFiles), genomeAnnotation = genomeAnnotation, geneAnnotation = geneAnnotation, force = TRUE)

proj_pancreas_HOM5<- ArchRProject(ArrowFiles=ArrowFiles, outputDirectory="pancreas-HOM5", copyArrows=TRUE, geneAnnotation = geneAnnotation, genomeAnnotation = genomeAnnotation)
seRNA<-import10xFeatureMatrix(input=c("../ENCDO856ZOJ-NA12878mainChr/outs/filtered_feature_bc_matrix.h5"),names=c("ENCDO856ZOJ-pancreas"))
proj_pancreas_HOM5 <- addGeneExpressionMatrix(input = proj_pancreas_HOM5, seRNA = seRNA, force = TRUE)

proj_pancreas_HOM5 <- proj_pancreas_HOM5[proj_pancreas_HOM5$TSSEnrichment > 6 & proj_pancreas_HOM5$nFrags > 2500 & !is.na(proj_pancreas_HOM5$Gex_nUMI)]
proj_pancreas_HOM5 <- addIterativeLSI(ArchRProj = proj_pancreas_HOM5, clusterParams = list(resolution = 0.2, sampleCells = 10000, n.start = 10), saveIterations = FALSE, useMatrix = "TileMatrix", depthCol = "nFrags", name = "LSI_ATAC")
proj_pancreas_HOM5 <- addIterativeLSI(ArchRProj = proj_pancreas_HOM5, clusterParams = list(resolution = 0.2, sampleCells = 10000, n.start = 10), saveIterations = FALSE, useMatrix = "GeneExpressionMatrix", depthCol = "Gex_nUMI", varFeatures = 2500, firstSelection = "variable", binarize = FALSE, name = "LSI_RNA")
proj_pancreas_HOM5 <- addCombinedDims(proj_pancreas_HOM5, reducedDims = c("LSI_ATAC", "LSI_RNA"), name =  "LSI_Combined")
proj_pancreas_HOM5 <- addUMAP(proj_pancreas_HOM5, reducedDims = "LSI_ATAC", name = "UMAP_ATAC", minDist = 0.8, force = TRUE)
proj_pancreas_HOM5 <- addUMAP(proj_pancreas_HOM5, reducedDims = "LSI_RNA", name = "UMAP_RNA", minDist = 0.8, force = TRUE)
proj_pancreas_HOM5 <- addUMAP(proj_pancreas_HOM5, reducedDims = "LSI_Combined", name = "UMAP_Combined", minDist = 0.8, force = TRUE)
proj_pancreas_HOM5 <- addClusters(proj_pancreas_HOM5, reducedDims = "LSI_Combined", name = "Clusters", resolution = 0.4, force = TRUE)
p1 <- plotEmbedding(proj_pancreas_HOM5, name = "Clusters", embedding = "UMAP_ATAC", size = 1.5, labelAsFactors=F, labelMeans=F)
p2 <- plotEmbedding(proj_pancreas_HOM5, name = "Clusters", embedding = "UMAP_RNA", size = 1.5, labelAsFactors=F, labelMeans=F)
p3 <- plotEmbedding(proj_pancreas_HOM5, name = "Clusters", embedding = "UMAP_Combined", size = 1.5, labelAsFactors=F, labelMeans=F)
plotPDF(p1, p2, p3, name = "UMAP-scATAC-scRNA-Combined", addDOC = FALSE)
proj_pancreas_HOM5 <- addGroupCoverages(ArchRProj = proj_pancreas_HOM5, groupBy = "Clusters")
#Create a folder named 'CallPeaks'.
proj_pancreas_HOM5 <- addReproduciblePeakSet(ArchRProj = proj_pancreas_HOM5, groupBy = "Clusters", peakMethod = "Tiles", method = "p", plot=FALSE)
proj_pancreas_HOM5<-addPeakMatrix(proj_pancreas_HOM5)

proj_pancreas_HOM5 <- addPeak2GeneLinks(ArchRProj = proj_pancreas_HOM5, useMatrix="GeneExpressionMatrix", reducedDims = "LSI_Combined")
saveArchRProject(ArchRProj = proj_pancreas_HOM5)

markerGene<-c("PRSS1")
p2g <- getPeak2GeneLinks(ArchRProj = proj_pancreas_HOM5, corCutOff = 0.5, resolution = 10000, returnLoops = TRUE)
p <- plotBrowserTrack(ArchRProj = proj_pancreas_HOM5, groupBy = "Clusters", geneSymbol = markerGene, upstream = 5000, downstream = 50000, loops = p2g)
plotPDF(plotList = p, name = "Plot-Tracks-Marker-Genes-with-Peak2GeneLinks-cor0.5-r10k.pdf", ArchRProj = proj_pancreas_HOM5, addDOC = FALSE, width = 5, height = 5)

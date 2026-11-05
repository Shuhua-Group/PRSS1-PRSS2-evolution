library(BSgenomeForge)
forgeBSgenomeDataPkg(
  seed="BSgenome-NA12878mainChr-seed.txt",
  dir="BSgenome-NA12878"
)

library(GenomicFeatures)
txdb<-makeTxDbFromGFF(
  file="NA12878.gtf",
  format="gtf",
  organism="Human",
  taxonomyId=9606
)

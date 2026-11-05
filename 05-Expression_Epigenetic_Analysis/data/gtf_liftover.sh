minimap2 -x asm5 -t 32 --cs=long \
	NA12878.fa \
	GRCh38.fa \
	> NA12878_to_GRCh38.pf

k8 paftools.js gff2bed \
	gencode.annotation.gtf \
	> gencode.bed12

k8 paftools.js liftover \
	NA12878_to_GRCh38.pf \
	gencode.bed12 \
	> NA12878.gene.bed12

python bed12_to_gtf.py \
	NA12878.gene.bed12 \
	NA12878.gtf
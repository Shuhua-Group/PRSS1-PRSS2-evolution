# 5 Epigenetic and gene expression analysis of the PRSS1-PRSS2 locus

## 5.1 Pseudogene transcript analysis (Extended Data Fig. 4DE)
This analysis quantifies short-read RNA-seq expression against a customized assembly and plots genome-wide TPM distributions with the trypsinogen genes highlighted. The four panels in the supplied figure are **Pancreas, Adrenal gland, Aorta, and Spleen**.

The amino acid sequence of the three pseudogenes (PRSS3P1, PRSS3P2 and TRY7) were annotated with Ensembl. 

The RNA-seq data were from a 5-copy sample (ENCDO575WHY) from Encode Project.

Run from `PRSS_scripts_public/`. Replace example paths with your input files; `HG002MAT` is an example reference name.

**Dependencies:** Liftoff, RSEM, STAR, fastp, and Python 3 (`pandas`, `numpy`, `matplotlib`, `seaborn`).

### 5.1.1 Prepare the customized reference annotation

Required software: Liftoff, RSEM, STAR, fastp, and Python 3 with `pandas`, `numpy`, `matplotlib`, and `seaborn`.

Use a target assembly FASTA and a source FASTA with its matching gene annotation. The original scripts use an HG002 maternal assembly as Inputs: target genome FASTA, source genome FASTA, and matching source annotation. Include genome-wide annotations and the PRSS copies.

```bash
bash RNA/01_liftoff_annotation.sh \
    -t data/reference/HG002MAT.fa \
    -s data/reference/source_genome.fa \
    -g data/reference/source_annotation.gff3 \
    -o results/RNA/annotation/HG002MAT.gff3 \
    -p 16 -c 0.95
```

Liftoff runs with `-copies -polish`. Use the selected final annotation in step 2. Skip this step if a matching annotation is already available.

### 5.1.2 Quantify RNA-seq expression

Input: single-end reads named `data/fastq/<sample>.fastq.gz`.

```bash
bash RNA/02_rsem_quant.sh \
    -r data/reference/HG002MAT.fa \
    -a results/RNA/annotation/HG002MAT.gff3 \
    -n HG002MAT \
    -i data/fastq -o results/RNA \
    -S reverse -t 16 \
    pancreas adrenal_gland aorta spleen
```

This builds the RSEM/STAR reference, trims reads, quantifies expression, and merges gene TPM. Set `-S none|forward|reverse` to match the library; add `-T` for trimmed reads. Rebuild the reference index after changing the genome or annotation.

Outputs:

- `results/RNA/rsem/HG002MAT/<sample>/<sample>.genes.results`
- `results/RNA/matrix/HG002MAT/gene_TPM_matrix.tsv` (`gene_id` followed by sample TPM columns).


### 5.1.3 Plot the four tissue panels

```bash
python3 RNA/03_plot_tpm_distribution.py \
    --tpm results/RNA/matrix/HG002MAT/gene_TPM_matrix.tsv \
    --samples pancreas adrenal_gland aorta spleen \
    --titles "Pancreas" "Adrenal gland" "Aorta" "Spleen" \
    --ncols 2 \
    --out-prefix results/RNA/plots/Ext_Fig_4E \
    --dpi 600
```

Output: `results/RNA/plots/Ext_Fig_4E.pdf` and `.png`.

Plots show `log10(TPM + 1)`, logarithmic gene counts, median/P95 markers, and PRSS1, PRSS3P1, PRSS3P2, TRY7, and PRSS2. Use `--genes NAME=GENE_ID ...` if gene IDs differ from the defaults, or `--sample <sample>` for one tissue.


## 5.2 SNV-structural form LD and eQTL in pancreas (Fig. 5AB, Extended Data Fig. 8AG)

Gene expression of PRSS2 (PRSS1/PRSS2) in different structural forms:

```bash
Rscript 01_PRSS1-PRSS2_violin_plot.R
```

Plot the LD pattern between eQTL SNVs and structrual forms:

```bash
python prss2_eqtl.py
```

## 5.3 co-expression pattern of PRSS1 and PRSS2 across tissues

### 5.3.1 Correlation of PRSS1 and PRSS2 in different structures (Fig. 5A)

Compare the expression correlation of PRSS1 and PRSS2 across different structures:

```bash
Rscript: 01_geno_cor_boot_jack.R 
```

This step takes `01_PRSS1_PRSS2_input.txt` as input. 
The outputs include `PRSS1_PRSS2_cor.txt`, a density histogram of correlation coefficients, and a violin plot of correlation coefficients.


### 5.3.2 Heatmap of PRSS1-PRSS2 correlation coefficients across multiple tissues (Fig. 5C)

Assess the expression correlation of PRSS1 and PRSS2 across multiple tissues and different structures:

```bash
Rscript 02_heatmap.R
```

This step takes `02_PRSS1-PRSS2.cor.norm.heatmap.txt` as input.
The output is a heatmap showing PRSS1–PRSS2 correlation coefficients across multiple tissues.

## 5.4 PRSS1-PRSS2 expression comparison and allele-specific expression (ASE)

### 5.4.1 Gene expression comparison between PRSS1 and PRSS2 in different tissues (Extended Data Fig. 8C)

```bash
python tissue_expression.py
```

### 5.4.2 Correlation between ASE and PRSS1/PRSS2 ratio in pancreas (Extended Data Fig. 8B)

This step takes `02_PRSS1-PRSS2_REF_ASE.txt` as input.
The outputs are producing scatter plots and violin plots.

```bash
Rscript 02_PRSS1-PRSS2_ratio_ASE_REF.R
```

### 5.4.3 Effect size comparison between PRSS1 and PRSS2 (Fig. 5G) 

This step takes `01_PRSS1_PRSS2_exp.tpm.txt` as input, which contains TPM-normalized expression levels of PRSS1 and PRSS2, along with the genotype data of rs2855983.
Resampling-based eQTL analysis was performed using the script `effect_size.R`; 100 resampling iterations were run separately for PRSS1 and PRSS2.
The outputs include `02_PRSS1-PRSS2.effect_size.exp_median.txt` and a violin plot of effect sizes.
```bash
RScript effect_size.R
```

## 5.5 3D-genome and TAD analysis (Fig. 5D, Extended Data Fig. 8D) 

Hi-C data alignment, TAD Identification and plot

```bash
PRSS_TAD.sh
```


## 5.6 ChIP-seq analysis (Fig. 5DF) 谢波：补充代码和所用的样本信息

ChIP-seq data aligment and peaks calling

```bash
PRSS_chipseq.sh
```


## 5.7 Single-cell ATAC-seq and RNA-seq analysis (Fig. 5DE)

### 5.7.1 Single cell sequencing read alignment and generate the count file

This step uses 10X Genomics tool `cellranger-arc` to generate count file `fragments.tsv.gz` for ATAC and `filtered_feature_bc_matrix.h5` for RNA.

NA12878 assembly can be downloaded from NCBI with accession number GCA_002077035.3.

#### 5.7.1.1 Make the customized reference file for cellranger-arc

```bash
cellranger-arc mkref --config=ref_config.csv
```

where the `ref_config.csv` has the format as shown below:

```
{
		organism: “human”
		genome: [“NA12878”]
		input_fasta: [“/path/to/NA12878_assembly.fa”]
		input_gtf: [“/path/to/NA12878_annotated_gene.gtf”]
}
```

The gtf file is generated by `PAFtools` that liftover GENCODE v34 to NA12878 coordinates and manually added PRSS3P2 and TRY7 annotations. The liftover step can be generated with bash script `gtf_liftover.sh`.

#### 5.7.1.2 Align the single cell sequencing reads to customized reference NA12878

```bash
cellranger-arc --id=<sample> --reference=NA12878 --libraries=fastq_list.csv
```

where `fastq_list.csv` lists all the fastq files.

### 5.7.2 Calculate coaccessibility and peak to gene loop

This step uses R package ArchR to calculate coaccessibility and plot.

Single-cell sequencing data (fastq) for donor ENCDO856ZOJ (a HOM5 carrier) from ENCODE project with accession numbers below:

- pancreas: ENCSR229VVY (snATAC), ENCSR472RRP (scRNA)
- spleen: ENCSR188TJX (snATAC)

#### 5.7.2.1 Generate customized BSgenome and txdb files (R code)

```bash
Rscript BSgenome_txdb_generate.R
```

#### 5.7.2.2 Run ArchR

To run multiome (snATAC+scRNA) ArchR, two input files need to be specified in the R scripts: one is the scATAC result `fragments.tsv.gz`, and the other is gene expression file `filtered_feature_bc_matrix.h5`.

```bash
R CMD BATCH ArchR_multiome_pancreas.R
```

To run snATAC ArchR, only `fragments.tsv.gz` is required.

```bash
R CMD BATCH ArchR_snATAC_spleen.R
```


## 5.8 Promotor and transcription factor analysis

### 5.8.1 Promotor alignment between 5-copy and 3-copy structures (Extended Data Fig. 8D)

Generate the sequence of known promotors of PRSS1, PRSS3P1 and PRSS2 from Genehancer
```bash
samtools faidx GRCh38.fa genehancer_promotor_position > genehancer_promotor.fa
```

Align the promotor sequences to a 5-copy genome NA12878:
```bash
lastz NA12878.fa genehancer_promotor.fa
```

### 5.8.2 HOMER analysis for enriched transcription factors in PRSS2 (Extended Data Fig. 8E)

```bash
Perl findMotifs.pl PRSS3P2_TRY7_PRSS2_promoter.fa fasta promoter_compare -fasta PRSS1_PRSS3P1_promoter.fa
```

`PRSS3P2_TRY7_PRSS2_promoter.fa` is the algined sequence from last step.
`findMotifs.pl` is a script from HOMER software. The results were further filtered out those present in background.


## 5.9 Dual-luciferase report assay (Fig. 5H)

The luciferase ratios were visualized by following R code:

```bash
Rscript PRSS2_luc_plot.R
```
# 2 Haplotype in human populations

This module characterises the haplotypes of the locus in human populations. Variants and copy  
number are called with NGS.PRSS1-2caller 1.5 and phased with Beagle 3.2.2; recombination is  
estimated with LDhat 2.2a; the haplotype network is built with PopART 1.7; haplotype trees are  
dated with BEAST 2.6.7; the assembled structure is validated on haplotype-resolved long-read  
assemblies; and the coding sequences of the two haplotype groups are tested for selection.

## 2.1 Haplotype characterization (Fig. 2A, Extended Data Fig. 5BCD, Supplementary Table 4 & 5) 

### 2.1.1 Haplotype phasing 

Use `Beagle` to phase the genotype on b38_ALT reference (5-copy):

```bash
java -Xmx14256m -jar /picb/humpopg-bigdata5/xiebo/software/beagle/beagle.21Apr21.304.jar gt=PRSSalt_reshape.filtered.vcf out=CHM13_NA12878_MQ50.phased
```

### 2.1.2 Haplotype clustering

[haplotype_heatmaps.py](code/haplotype_heatmaps.py) reads [allele tables](data/heatmaps) and [matched matrices](data/clustering) for archaic, H3/H3R and other haplotypes at MAF 0.01/0.05.

```bash
python code/haplotype_heatmaps.py
```

The panels contain 6/82/82 haplotypes and 326/159 markers at the two thresholds. Samples, markers and alleles must match between paired inputs. Clustering uses Euclidean distance and average linkage. Outputs: six PDF/PNG heatmaps, row orders and counts. Supplied sample selections are retained.

### 2.1.3 Haplotype classification

Assign every 84-SNP haplotype to the 3-copy (CN3), 5-copy (CN5) or recombinant (CNC) background.

```bash
cd data
perl ../code/hap.annotate.pl 84SNP-4053hap.txt
```

The script scores each haplotype against the 28-marker CN3 / CN5 / CNC reference vectors of copy1  
(positions 1–28), copy2 (29–56) and copy5 (57–84), and writes the best match and its Hamming  
distance per copy block.

Raw data: `84SNP-4053hap.txt`, `MainHaps_5copy_cluster_maf0.01.beta.txt`, `CN3_key_SNP.xlsx`,  
`haplotype-SNP_v8.xlsx` — the 84-SNP haplotype matrix of 4,053 haplotypes (chimpanzee outgroup,  
then archaic AltaiNea / Denisovan / Vindija and modern human haplotypes), the main 5-copy  
haplotype clusters at MAF ≥ 0.01, the key SNPs of the 3-copy haplotype and the haplotype–SNP  
correspondence table.

Final results: `84SNP-4053hap.out.xlsx`, `TableS4-Human_haplotype.xlsx`,  
`TableS5-Haplotype_motif.xlsx`, `Fig-2.pdf`

**Software:** NGS.PRSS1-2caller 1.5, Beagle 3.2.2, Perl.

## 2.2 Haplotype Frequency Calculation (Fig. 2AB, Extended Data Fig. 5A) 

Calculate structure and haplotype frequencies from phased individual calls; plot population structure frequencies. Both calculations are implemented as module-level `run(files)` functions in `code/haplotype_frequencies.py` and `code/coding_variant_frequencies.py`, where `files` supplies the input tables and writes the output tables and figures.

```bash
# code/haplotype_frequencies.py        -> run(files): structure_frequencies, haplotype_frequencies, structure_frequencies figure
# code/coding_variant_frequencies.py   -> run(files): coding_haplotype_frequencies, nonsynonymous_variant_frequencies
```

Raw data: `sample_haplotypes.tsv`, `coding_variants.tsv` — the phased copy-number and CDS haplotype  
annotation of each sample, and the nucleotide and amino-acid changes of each CDS haplotype.

Final results: per-population, per-superpopulation and per-project frequencies of the 3-, 4- and  
5-copy structures and of each haplotype group, the per-gene coding-haplotype and  
nonsynonymous-variant frequencies, and the structure-frequency bar plot.

**Software:** Python 3.

To plot the frequency distribution in world map:

[population_frequencies.py](code/population_frequencies.py) reads [PRSS frequencies](data/prss_haplotype_frequencies.tsv) and the offline [map outline](data/world_outlines.json).

```bash
python code/population_frequencies.py
```

## 2.3 Recombination (Fig. 2A)

Estimate the recombination rate along the locus with LDhat on the phased CEU, CHB and YRI sample  
sets.

```bash
cd data
Rscript ../code/recom.R                        # input: CN3+5.recom.txt
```

Raw data: `CEU_MQ50.phased.CN3+5.v2.vcf`, `CHB_MQ50.phased.CN3+5.v2.vcf`,  
`YRI_MQ50.phased.CN3+5.v2.vcf`, `CEU_MQ50.phased.CN3only.v2.vcf`, `CHB_MQ50.phased.CN3only.v2.vcf`,  
`YRI_MQ50.phased.CN3only.v2.vcf`, `CEU_MQ50.phased.CN5only.v2.vcf`, `CHB_MQ50.phased.CN5only.v2.vcf`,  
`YRI_MQ50.phased.CN5only.v2.vcf` — Beagle-phased genotypes at MQ ≥ 50, split into the combined,  
3-copy-only and 5-copy-only sample sets.

Final results: `CN3+5.recom.txt`, `recom.xlsx` — LDhat rates along the locus (columns `POS`, `REC`,  
`POP`) for the combined sample set, with their annotation.

**Software:** Beagle 3.2.2, LDhat 2.2a, R (ggplot2, ggpubr, ggthemes, Rmisc, magrittr, showtext).

## 2.4 Haplotype network (Fig. 2D, Extended Data Fig. 7A) 

Build the median-joining network of the 20 most common haplotypes of the African and  
non-African populations for the worldwide network, and of the short-form and long-form haplotypes  
of the CEU and CHB populations for the Eurasian network.

```bash
cd data
# PopART 1.7: open PRSS1-PRSS2_v4.1.rdf and build the median-joining network
```

Raw data: `CN3.network.vcf`, `CN5.network.vcf` — the variants underlying the 3-copy and 5-copy  
networks; the NEXUS alignments they are converted into are not shipped, they are regenerated from  
these VCFs.

Final results: `PRSS1-PRSS2_v4.1.rdf`, `PRSS1-PRSS2.rdf.xlsx`, `PRSS1-PRSS2.rdf.info.xlsx`,  
`3pop.xlsx`, `Extended_Data_Fig-7.pdf` — the PopART project of the network, its haplotype table and  
annotation, the per-population sample lists and variant-by-sample matrices for the CN3 and CN5  
networks, and the figure.

**Software:** PopART 1.7.

## 2.5 Phylogenetic tree (Fig. 2C)

Date the haplotype tree of modern human populations together with the archaic hominins and the  
primate outgroups.

```bash
cd data
bash ../code/LtoS.rename.sh   # 192 sed rules: append the main-haplotype label (H1 / H4 / HR3 / H1.S / ...) to each tip
beast common.v26.xml
treeannotator common.v26.mcmc.trees 
```

The BEAUti/BEAST configuration of this run is:

```
substitution model : HKY, GammaSiteModel (gammaCategoryCount = 5)
clock model        : strict clock, clock-rate prior Gamma(0.001, 1000)
tree prior         : Calibrated Yule
calibrations       : "c-h" (chimp–human) ~ LogNormal(M = 6.6, S = 0.09)
                     "g-h" (gorilla–human) ~ LogNormal(M = 10.5, S = 0.09)
MCMC               : chainLength = 1000000, first 10% of runs discarded as burn-in
```

Raw data: `142sample.phased.vcf`, `common.v13.fa`, `common.v13.xlsx`, `LtoS_copy2_5.meg`,  
`LtoS_copy2_5.xlsx`, `BEASTtree__rename.txt` — the phased variants of the 142 samples, the  
haplotype alignment of modern human populations together with the archaic hominins and the primate  
outgroups, built from the 1st, 2nd and 5th copies shared by the long-form and short-form  
haplotypes, with its sample-to-haplotype assignment, the copy2 / copy5 alignment of the  
long-to-short (5-copy → 3-copy) comparison with its annotation, and the sample-ID to label mapping  
(e.g. `HGDP00052:HGDP_Balochi_1`). `LtoS.rename.sh` appends the main-haplotype label to each tip of  
`LtoS_copy2_5.meg`.

Final results: `common.v13.1.mcmc.trees.pdf`, `LtoS_copy2_5.njtree.pdf`,  
`Extended_Data_Fig-6.pdf`

**Software:** MAFFT 7.310, ALTER 1.3.4, BEAUti / BEAST 2.6.7, TreeAnnotator, FigTree 1.4.4, MEGA.

## 2.6 Divergence time & TMRCA (Extended Data Fig. 6AB)

Date the haplotype tree and read off TMRCA and divergence times.

```bash
cd data
treeannotator AFR-CN5-4each-v2.trees AFR-CN5-4each-v2.consensus.trees
```

Raw data: `ancHap_arcHaps.nex.txt` — the alignment of the ancestral and archaic haplotypes from  
which the dated trees are reconstructed; the simplified `ancHap_arcHaps.simp.txt` and the  
`AFR-CN5-4each-v2.trees` input of the treeannotator step are not shipped.

Final results: `AFR-CN5-4each-v2.consensus.trees`,  
`PRSS-TMRCA_and_Divtime.AFR_and_nonAFR.2022-4-23.xlsx` — the consensus trees of the African 5-copy  
runs and the TMRCA / divergence-time estimates for African versus non-African haplotypes.

**Software:** BEAST 2.6.7, TreeAnnotator, FigTree 1.4.4.

## 2.7 Long-read validation

Check the assembled haplotype structure of the haplotype-resolved long-read assemblies against the  
reference haplotypes.

```bash
cd data
bash ../code/32haploid_check__script.sh        # samtools faidx on the assemblies listed in the script
nucmer <assembly> b38_PRSSonly.fasta           # then show-coords, see code/nucmer.txt
```

Raw data: the assemblies `v12_*_hgsvc_pbsq2-clr_1000-flye.*.fasta` under  
`32haploid_assembly/fasta/` are not shipped; `code/32haploid_check__script.sh` records the cluster  
paths for the assemblies it checks.

Final results: `32haploid.txt`, `32sample_haploid.xlsx` — the `show-coords` alignment of each  
assembly against the 5-copy reference contig, and the per-sample copy numbers of the assembled  
haplotype structures.

**Software:** SAMtools 1.6, Mummer 3.23.

## 2.8 Human haplotype evolution inferrence (Extended Data Fig. 6C)

PowerPoint illustration based on TMRCA and divergence time estimation. 

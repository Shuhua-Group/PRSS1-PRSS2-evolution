# 3 Natural selection in human populations

## 3.1 Coding sequence dN/dS analysis (Fig. 3A, Extended Data Fig. 4CD) 

Compare the coding sequences carried by the 3-copy and 5-copy haplotypes and test them for  
selection.

```bash
cd data
mafft --auto CN5-CN3.fa > CN5-CN3_mafft.fa    # alignment is regenerated, not shipped
codeml ../code/codeml.ctl.tmp                 # set seqfile / treefile / model as described below
```

`codeml.ctl.tmp` as shipped is the chapter 1 control file: it points to the primate alignment `CDS2_mafft.fa` and its guide tree `CDS2.nwk` and sets `model = 0`. For this run `seqfile` and  `treefile` are set to `CN5-CN3_mafft.fa`/`nonRedundant_20220422edited.fa` and `CN5-CN3.nwk`/ `CDS-AFR-EUR-EAS-nonRedundant-MEtree.nwk`, and the branch model (`model = 2`) is used. The phylogenetic tree is constructed by minimum evolution from the coding sequences of the  long- and short-form haplotypes in the African, European and East Asian populations. The guide tree  `CN5-CN3.nwk` supplied here groups the sequences by copy locus and separates the CN3 and CN5  
haplotypes within each group. PRSS1 and PRSS2, and the long-form and short-form haplotypes in each population, are specified in turn as foreground branches, and a likelihood ratio test against the null model with a single dN/dS on all branches is used to test branches with dN/dS > 1.

Raw data: `CN5-CN3.fa`, `CN5-CN3.nwk`, `PRSS_CDS_haps.fa`, `PRSS1_main_CDS.fa`, `PRSS2_main_CDS.fa`, `nonRedundant_20220422edited.fa`, `CDS-AFR-EUR-EAS-nonRedundant-MEtree.nwk` — the CDS haplotypes of the CN3 and CN5 groups rooted with `chimp-CDS1-v5`, their guide tree grouping the sequences by copy locus and separating the CN3 and CN5 haplotypes within each group, and the main PRSS1 / PRSS2 CDS haplotypes.

Final results: `TableS6-amino_acid_change.xlsx`, `out.xlsx`, `Fig-3.pdf` — the amino-acid changes of the CDS haplotypes with respect to the GRCh38 alternative contig, the nonsynonymous and synonymous variant counts of each copy and population for the 3-copy and 5-copy haplotype groups, and the figure, with the dN/dS ratios of the different trypsinogen gene copies in diverse human populations shown in Fig. 3A.

**Software:** MAFFT 7.310, PAML 4.9j (`codeml`).

## 3.2 Demographic simulation 

Use `stdpopsim` to simulate out-of-Africa events with a typical three-population HapMap model (YRI, CEU, CHB)

```bash
stdpopsim HomSap --help-genetic-maps
stdpopsim HomSap -c chr7 -o HomSap.HapMapII_GRCh37.YRI_CEU_CHB.trees -g HapMapII_GRCh37 -d OutOfAfrica_3G09 216 198 206
```

## 3.3 Haplotype differentiation (Fig. 3B)

Calculate population differentiation Fst in genome-wide structural variants (>1kb)
```bash
python population_differentiation.py
```

This calcuation requires input files `fst_populations.tsv`, `fst_simulation_frequencies.tsv`, and `fst_assembly_background.tsv`.

[fst_background_comparison.py](code/fst_background_comparison.py) combines population frequencies, simulation summaries and 51,570 assembly SV background records.

```bash
python code/fst_background_comparison.py
```

FST preserves the historical pairwise integer-nc convention and clips negative estimates to zero. Outputs: comparison plots, FST tables and background counts/quantiles.

## 3.4 Allele frequency trajectory (Fig. 3C) 

Infer the trajectories of short-form structure:

```bash
relate_clues.sh
```

Plot retained CLUES trajectories and uncertainty bounds:
```bash
python selection_trajectories.py
```

## 3.5 Tajima's D analysis (Fig. 3D, Extended Data Fig. 5F, Extended Data Fig. 7B) 

Calculate Tajima's D:

```bash
tajima_d.sh
```

Compare Tajima's D at the PRSS1-PRSS2 locus with the background (chr7) values:
```bash
python tajima_d_comparison.py
```

## 3.6 EHH analysis of H3 haplotype (Extended Data Fig. 5E)

Curves were exported with rehh 3.2.3: `data2haplohh(polarize_vcf=FALSE)` and `calc_ehh(include_nhaplo=TRUE)`,

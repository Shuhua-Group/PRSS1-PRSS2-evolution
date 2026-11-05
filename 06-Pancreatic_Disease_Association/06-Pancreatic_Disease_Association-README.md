# 6 Pancreatic disease association

## 6.1 PRSS1-PRSS2 structural association study

### 6.1.1 Meta analysis of pancreatitis association in Euroasian populations (Extended Data Fig. 8F)

[pancreatitis_meta_analysis.R](code/pancreatitis_meta_analysis.R) reads [summary estimates](data/pancreatitis_associations.xlsx), sheet CN rows 2–4, and [effect directions](data/effect_directions.tsv).

```bash
Rscript code/pancreatitis_meta_analysis.R
```

### 6.1.2 Stratified association study of pancreatitis in Chinese population (Fig. 6A)

Perform the association test:
```bash
association_test.sh
```
Sample-level data are from Zou et al. 2020 Hum Mutat (PMID: 32383311)

### 6.1.3 Literature summary of pancreatitis genetic association studies (Supplementary Table 3)

Manually curated pancreatitis genetic association studies at the PRSS1-PRSS2 locus.

### 6.1.4 Structural form association with epidemiology data (Fig. 6C)

See data in `Pancreas_pancreatitis_cancer_epidemiology.xlsx`, linear regression was used in Excel to fit the data.


## 6.2 Mendelian Randomization and fine mapping causal variant (Fig. 6B)

### 6.2.1 Mendelian Randomization 

This step takes eQTL files `01_PRSS1_eQTL_input.txt`, `01_PRSS2_eQTL_input.txt`, `01_PRSS1-PRSS2_eQTL_input.txt` and GWAS file `01_gwas_data.txt` as inputs.
The outputs are `02_PRSS1_smr_localzoom.txt`, `02_PRSS2_smr_localzoom.txt` and `02_PRSS1-PRSS2_smr_localzoom.txt`.
Manhattan plots were visualized with Localzoom (https://statgen.github.io/localzoom/#instructions).
```bash
Rscript: 02_smr.R
```

### 6.2.2 Colocalization

This step takes eQTL files `01_PRSS1_eQTL_input.txt`, `01_PRSS2_eQTL_input.txt`, `01_PRSS1-PRSS2_eQTL_input.txt` and GWAS file `01_gwas_data.txt` as inputs.
The outputs are `01_PRSS1_coloc_result.txt`, `01_PRSS2_coloc_result.txt` and `01_PRSS1-PRSS2_coloc_result.txt`.
```bash
Rscript: 01_coloc.R
```

## 6.3 Evolution model of human trypsinogen genes (Fig. 6D)

PowerPoint illustration.
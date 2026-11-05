# 1. Evolutionary history in primate

This module aligns the locus across primates and dates its duplication history. Cross-species  
alignment uses `nucmer` / `show-coords` (Mummer 3.23), the repeat structure is drawn with  
Miropeats 2.02, the duplication tree is dated with BEAST 2.6.7 after MAFFT 7.310 alignment and  
ALTER 1.3.4 conversion, and coding constraint is estimated with PAML 4.9j `codeml`. Primate  
coordinates are listed in Table S1.

## 1.1 Data processing

Extract the locus and its per-copy partitions from GRCh38.

```bash
cd data
bash ../code/fasta__script.sh
```

Raw data: `b38_PRSSonly.fasta`, `b38_PRSSonly_alt.fasta`, `b38_PRSS_copy1.fasta`,  
`b38_PRSS_copy2.fasta`, `b38_PRSS_copy3.fasta`, `b38_PRSSalt_copy1.fasta`,  
`b38_PRSSalt_copy2.fasta`, `b38_PRSSalt_copy3.fasta`, `b38_PRSSalt_copy4.fasta`,  
`b38_PRSSalt_copy5.fasta`, `chimpanzee_chr7_2.fasta`, `macaca1.fasta`, `macaca2.fasta`,  
`macaca3.fasta`, `Primates_PRSS_region.txt`

The script slices the primary assembly at `chr7:142746873-142757513` (copy1),  
`142757514-142768092` (copy2), `142768093-142778584` (copy3) and the ALT contig at  
`749409-760105`, `760106-770685`, `770686-781262`, `781263-791064`, `791065-801557` (copy1–copy5);  
the per-copy lines are commented out in the script because the whole-locus FASTA files are the ones  
used downstream. `Primates_PRSS_region.txt` records the corresponding coordinates in the other  
primates.

Final results: none — the extracted sequences above are the raw data of the following sections.

**Software:** SAMtools 1.6. **External input:** `GRCh38_full_analysis_set_plus_decoy_hla.fa`  
(cluster path in the script); chimpanzee and macaque genome sequences.

## 1.2 Sequence alignment (Fig. 1A, Extended Data Fig. 1AD, Supplementary Table 1)

Align the locus against the chimpanzee genome, draw the repeat structure of the 3-copy haplotype  
and the PRSS3P2 + TRY7 pseudogene segment, and compare copy-to-copy identity within and between  
species.

```bash
cd data
bash ../code/nucmer.txt                        # working-dir names: b38_alt.fa = b38_PRSSonly_alt.fasta ; chimpanzee.fa = chimpanzee_chr7_2.fasta
bash ../code/miropeats_human-human__run.sh
Rscript ../code/heatmap.R                      # input: gelada9-gelada9.txt (other matrices commented in the script)
Rscript ../code/boxplot.R                      # input: compHap_human_AFR_v4_copyall.txt
```

Raw data: `TableS1-Primate_coordinates.xlsx`, `b38_PRSSonly_reverse.fasta`,  
`b38_PRSS3P2+TRY7.fasta`, `human5-human5.txt`, `human3-human5.txt`, `human5-chimp6.txt`,  
`chimp6-chimp6.txt`, `chimp6-gelada9.txt`, `gelada9-gelada9.txt`, `gibbon3-chimp6.txt`,  
`gibbon3-gelada9.txt`, `gibbon3-gibbon3.txt`, `capuchin1-chimp6.txt`,  
`compHap_chimp-human_v4_copyall.txt`, `compHap_human_AFR_v4_copyall.txt`

`b38_PRSSonly_reverse.fasta` is the reverse complement of the 3-copy haplotype and  
`b38_PRSS3P2+TRY7.fasta` is `chr7_KI270803v1_alt:770686-791064`, the PRSS3P2 + TRY7 pseudogene  
segment; together they are the two sequences of the Miropeats self-comparison, which is scanned at  
seed sizes 300–1500. The ten `*.txt` matrices are pairwise identity percentages between the repeat  
copies of the named species, and the two `compHap_*_copyall.txt` tables give per-copy base  
differences (columns `dist`, `hap`) for the chimpanzee–human and African-human comparisons.

Final results: `b38-b38alt.png`, `chimp-b38alt.png`, `gorilla-b38alt.png`, `gibbon-b38alt.png`,  
`macaque-b38alt.png`, `gelada-b38alt.png`, `capchuin-b38alt.png`, `mouse-lemur-b38alt.png`,  
`night_monkey-b38alt.png`, `Black_snub-nosed_monkey-b38alt.png`, `miropeats.v2.1.pdf`,  
`Heatmap.v3.1.pdf`, `compHap_chimp-human_v4_sum.xlsx`, `compHap_human_AFR_v4_sum.xlsx`,  
`Fig-1.pdf`, `Extended_Data_Fig-1.pdf`

**Software:** Mummer 3.23 (`nucmer`, `show-coords`), Miropeats 2.02, R (pheatmap,  
ggplot2, ggpubr, magrittr). **External input:** the long-read assembly  
`v12_NA20509_hgsvc_pbsq2-clr_1000-flye.h2-un.arrow-p1.fasta` used in the first two `nucmer` lines.

## 1.3 Phylogenetic tree (Extended Data Fig. 1C)

Merge the per-taxon FASTA files, align, convert to NEXUS, and date the duplication tree of the  
primate copies with BEAST.

```bash
cd data
bash ../code/BEASTtree__fasta_merger.sh -i <dir-with-per-taxon-fasta> -n <task>
bash ../code/CDS__run.sh                       # fasta_merger -> mafft --auto -> ALTER (FASTA -> NEXUS)
beast DUP2.xml
treeannotator DUP2.mcmc.trees DUP2.consensus.trees
```

The BEAUti/BEAST configuration of this run is:

```
substitution model : HKY, GammaSiteModel (gammaCategoryCount = 5)
clock model        : strict clock, clock-rate prior Gamma(0.001, 1000)
tree prior         : Calibrated Yule
calibration        : capuchin–Ma's night monkey divergence ~ LogNormal(M = 18.3, S = 0.05)
MCMC               : chainLength = 1000000, first 10% of runs discarded as burn-in
```

Raw data: `DUP2_mafft.fa` — the aligned duplication copies of ten non-human primates  
(Chimp, Gibbon, Gorilla, Macaque, Olive_baboon, Orangutan, Sooty_mangabey, Capuchin, Night_monkey,  
Black_snub-nosed_monkey). `CDS__run.sh` sets `TASK` to `primate-human`, so a run of the supplied  
script produces `primate-human.fa`, `primate-human_mafft.fa` and `primate-human.nex`; the `DUP2.*`  
names used here require `TASK` to be set to `DUP2`. These intermediate files are not shipped  
because they are regenerated by the commands above.

Final results: `DUP2.mcmc.trees.pdf`

**Software:** MAFFT 7.310, ALTER 1.3.4, BEAUti / BEAST 2.6.7, TreeAnnotator, FigTree 1.4.4,  
Java (JRE).

## 1.4 Evolutionary constraint at the coding region (Fig. 1C, Extended Data Fig. 4AB)

Estimate dN/dS on the primate CDS alignment with `codeml`.

```bash
cd data
codeml ../code/codeml.ctl.tmp
```

where `codeml.ctl.tmp` sets `seqfile = CDS2_mafft.fa`, `treefile = CDS2.nwk`, `seqtype = 2`  
(codons), `runmode = 0`, `model = 0`, `clock = 0`, `getSE = 1`, `RateAncestor = 0`, `ncatG = 5`,  
`Small_Diff = 5e-7`.

The branch model used in the paper compares, for each copy, the null model (`model = 0`, a single  
rate on all branches) with an alternative model (`model = 2`, a lineage-specific rate on the  
foreground branch) by a likelihood ratio test against the chi-square distribution with df = 1. The  
supplied `codeml.ctl.tmp` sets `model = 0`; the alternative model requires a separate control file.

Raw data: `CDS2_mafft.fa`, `CDS2.nwk` — the aligned coding sequences of the primate trypsinogen  
copies together with the human `b38` copies (`b38_CDS1`, `b38_CDS5`, `b38_PSU2`, `b38_PSU3`,  
`b38_PSU4`), with their guide tree.

Final results: `dnds_results.txt`, `Extended_Data_Fig-4.pdf`

`dnds_results.txt` reports the dN/dS of all sites and of each copy for five groupings: ape-only,  
ape + human, a mixed prosimian / New World monkey / ape + human set, all human haplotypes and  
human major haplotypes.

**Software:** PAML 4.9j (`codeml`).

## 1.5 PRSS1-PRSS2 locus coordinates in primate genomes (Supplementary Table 1)

Supplementary Table 1 lists the coordinates of the trypsinogen gene copies in the primate assemblies. This workflow exports the listed intervals and assembly identifiers, optionally extracts their sequences, and provides BLASTN commands for localization checks. Run the commands below from the `data/` directory; the workbook is supplied with the manuscript (`TableS1-Primate_coordinates.xlsx`). Its coordinates and listed lengths are preserved; no correction is inferred from the best-hit script.

The workbook has two sheets. **Apes** lists the human long-form and short-form haplotypes and the great ape assemblies:

| Species label in Table S1 | Assembly version | Contig ID           | Copy indices |
| ------------------------- | ---------------- | ------------------- | ------------ |
| Human(L)                  | GRCh38.p13       | chr7_KI270803v1_alt | 1–5          |
| Human(S)                  | GRCh38.p13       | chr7                | 1–3          |
| Chimpanzee                | GCA_002880755.3  | NBAG03000017.1      | 1–6          |
| Gorilla                   | GCA_008122165.1  | CYUI03000263.1      | 1–6          |
| Orangutan                 | GCA_002880775.3  | NDHI03003435.1      | 1–6          |

**Old world monkeys** lists Capuchin (`Cebus_imitator-1.0`, `KV389872.1`, copy 1), Ma's night monkey  
(`Anan_2.0`, `KZ203923.1`, copy 1), Gelada (`Tgel_1.0`, `Primary_assembly 3`, copies 1–9), Sooty  
mangabey (`Caty_1.0`, `KQ012797.1`, copies 1–11) and Macaque (`Mmul_10`, `NC_041756.1`, copies 1–12).

### 1.5.1 Export the coordinates and assembly list

The script uses Python 3 standard-library modules only; `openpyxl` is not required.

```bash
python3 ../code/01_prepare_table_s1.py \
    --table <path-to>/TableS1-Primate_coordinates.xlsx \
    --sheet "Apes" \
    --out-dir results/table_s1
```

Run the script once per sheet (`Apes` and `Old world monkeys`). It reads the specified sheet and carries forward the species, assembly and contig values shown only once for each species block.

Outputs in `--out-dir`:

| File                | Contents                                                                                               |
| ------------------- | ------------------------------------------------------------------------------------------------------ |
| `table_s1_t2t.tsv`  | `species`, `assembly`, `contig`, `start`, `end`, `table_length`, `copy_index`, `position_span`         |
| `assemblies.tsv`    | One species/assembly/contig record per assembly                                                        |
| `table_s1_t2t.bed`  | BED6 intervals derived from the listed positions; strand is `.` because the table has no strand column |
| `coordinate_qc.tsv` | Differences between listed length and coordinate span, and overlaps within an assembly/contig          |

The BED export assumes the source positions are 1-based inclusive and converts the start to 0-based; `position_span` is `end - start + 1`. This interpretation is explicit because the workbook does not provide a coordinate-system note. The original `table_length` remains a separate field. Exports generated from the T2T assembly version of the table are also included in `data/` for convenience.

### 1.5.2 Extract the listed intervals from matching assemblies

This step requires `samtools` and the genome FASTA files for the exact assembly versions listed in the table. The example uses the local naming convention `data/assemblies/<assembly_accession>.fna`; rename files or change the path to match your local copies.

```bash
mkdir -p results/table_s1/sequences

while IFS=$'\t' read -r species assembly contig start end table_length copy_index position_span; do
    [[ "$species" == "species" ]] && continue
    fasta="data/assemblies/${assembly}.fna"
    [[ -f "$fasta" ]] || { echo "Missing FASTA: $fasta" >&2; exit 1; }
    [[ -f "${fasta}.fai" ]] || samtools faidx "$fasta" || exit 1
    samtools faidx "$fasta" "${contig}:${start}-${end}" \
        > "results/table_s1/sequences/${assembly}.copy${copy_index}.fa" || exit 1
done < results/table_s1/table_s1_t2t.tsv
```

This extracts the table's intervals as written, in reference orientation. Copy index alone does not supply transcriptional strand or prove orthology. In particular, extraction preserves any overlap already present in the table.

### 1.5.3 Check candidate locations with BLASTN

Use `blastn_best_hit.sh` when the PRSS query sequences are available. The supplied archive does not contain the original query FASTA or its query-to-copy mapping, so this step is a configurable localization check rather than a reconstruction of the original table from undocumented inputs.

The following example uses a complete chromosome as the subject, preserving chromosome-based positions. It requires NCBI BLAST+ and `samtools`.

```bash
mkdir -p results/table_s1/blast

samtools faidx data/assemblies/GCA_002880755.3.fna
samtools faidx data/assemblies/GCA_002880755.3.fna NBAG03000017.1 \
    > results/table_s1/blast/chimpanzee.chromosome.fa

bash ../code/blastn_best_hit.sh \
    -e 1e-5 -t 8 \
    -a results/table_s1/blast/chimpanzee.all_hits.tsv \
    data/queries/PRSS_queries.fa \
    results/table_s1/blast/chimpanzee.chromosome.fa \
    results/table_s1/blast/chimpanzee.best_hits.tsv
```

Replace `data/queries/PRSS_queries.fa` with the actual query FASTA. Repeat for other species using their assembly/contig pairs listed above. Do not use sequences extracted from a table interval as independent evidence validating that same interval.

The script runs `blastn -task megablast`. Its original best-hit behavior is retained: one highest-bit-score reported alignment per query, with the first hit retained for ties. New options `-t` and `-a` specify threads and an additional output containing all reported alignments. Output directories are created automatically.

Both output files use the 12-column, headerless BLAST format:

```text
qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore
```

The actual separator is a tab. BLAST subject coordinates are 1-based inclusive; use `min(sstart, send)` and `max(sstart, send)` for the ordered interval. A reversed start/end pair indicates a reverse-strand alignment. If using an extracted forward-oriented window `contig:L-R` instead of a full chromosome, convert local position `p` using `L + p - 1`.

A retained best hit is one local alignment (HSP), not necessarily the complete gene. Multiple queries can select the same duplicated region. Copy indexing and complete copy boundaries require inspection of all hits and the surrounding sequence; one best hit per query is not a copy-number estimate.

### 1.5.4 Review the coordinate checks

`coordinate_qc.tsv` reports, under the stated 1-based inclusive interpretation, any interval whose listed `Length` differs from its coordinate span and any pair of intervals that overlap within the same assembly/contig. Entries flagged there should be checked against the original annotation before the coordinates are reused; the export preserves the supplied values and does not correct them.

## 1.6 Gibbon evolution model inference (Extended Data Fig. 2B-D)

Compare the sequence identity of the gibbon copies with the orthologous and paralogous copies in  
great apes to distinguish the ancestral-duplication and deletion models described in the paper.

## 1.7 Copy number polymorphism in great apes at the PRSS1-PRSS2 locus (Extended Data Fig. 3AB)

[primate_copy_number.py](code/primate_copy_number.py) draws two scatter/range plots:

- PRSS: [sample measurements](data/prss_copy_number.tsv) and [ranges](data/prss_copy_number_ranges.tsv), 2,109 samples in 14 groups.

```bash
python code/primate_copy_number.py
```

Outputs: PDF/PNG plots and group count/minimum/median/maximum tables. The script checks sample uniqueness and range endpoints. Fixed jitter changes categorical placement only; processed copy-number values are preserved. 

## 1.8 Inferred mutation mechanism of copy number change at the PRSS1-PRSS2 locus (Extended Data Fig. 3C)

PowerPoint illustration based on the evidence of sequence alignment above.

## 1.9 Copy number evolutionary history inference (Fig. 1B, Extended Data Fig. 1B, Extended Data Fig. 2A)

PowerPoint illustration based on the evidence of sequence alignment above.
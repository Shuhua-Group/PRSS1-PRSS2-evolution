"""Coding-haplotype and nonsynonymous variant frequencies."""

from collections import Counter
from .haplotype_frequencies import alleles, GENES


def run(files):
    data = alleles(files)
    annotation = {(r["gene"], r["HapID"]): r for r in files.read("coding_variants")}
    haps, variants = [], []
    for pos, gene in enumerate(GENES, 1):
        for copy in [3, 4, 5]:
            counts = Counter(r[gene + "_CDS"] for r in data if r["copy_number"] == copy)
            denominator = sum(counts.values()) - counts.get("DEL", 0)
            mutations = Counter()
            for hap, count in sorted(counts.items()):
                if hap == "DEL":
                    continue
                a = annotation[(gene, hap.replace(gene, "POS" + str(pos)))]
                # Repeated tokens in a cell represent one variant per allele.
                for change in {
                    v for v in a["Amino Acid (nonsynonymous)"].split(";") if v
                }:
                    mutations[change] += count
                haps.append(
                    dict(
                        gene=gene,
                        copy_number=copy,
                        cds_haplotype=hap,
                        allele_count=count,
                        present_gene_alleles=denominator,
                        frequency=count / denominator,
                        nucleotide_change=a["Nucleotide Change"],
                        nonsynonymous_change=a["Amino Acid (nonsynonymous)"],
                        synonymous_change=a["Amino Acid (synonymous)"],
                    )
                )
            variants.extend(
                dict(
                    gene=gene,
                    copy_number=copy,
                    mutation=k,
                    carrier_alleles=v,
                    present_gene_alleles=denominator,
                    frequency=v / denominator,
                )
                for k, v in sorted(mutations.items())
            )
    files.table("coding_haplotype_frequencies", haps)
    files.table("nonsynonymous_variant_frequencies", variants)

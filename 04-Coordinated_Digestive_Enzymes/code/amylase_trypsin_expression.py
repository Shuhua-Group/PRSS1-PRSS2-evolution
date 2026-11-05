"""Genotype-stratified amylase-trypsin expression correlations."""

from .common import bh, pearson, GROUPS


def run(files):
    output = []
    norm = files.read("pancreas_normalized_expression")
    for group in GROUPS:
        rows = [r for r in norm if r["genotype"] == group]
        for amy in ["AMY2A", "AMY2B"]:
            for gene in ["PRSS1", "PRSS2"]:
                r, p = pearson([a[amy] for a in rows], [a[gene] for a in rows])
                output.append(
                    dict(
                        expression_scale="normalized",
                        genotype=group,
                        amylase=amy,
                        trypsinogen=gene,
                        minimum_TPM="NA",
                        n_samples=len(rows),
                        Pearson_r=r,
                        p_two_sided=p,
                    )
                )
    for row, q in zip(output, bh([r["p_two_sided"] for r in output])):
        row["BH_q"] = float(q)
    tpm = files.read("pancreas_tpm")
    for minimum in [0, 10]:
        tests = []
        for group in GROUPS:
            for amy in ["AMY1", "AMY2"]:
                for gene in ["PRSS1", "PRSS2"]:
                    rows = [
                        r
                        for r in tpm
                        if r["genotype"] == group
                        and float(r[amy]) >= minimum
                        and float(r[gene]) >= minimum
                    ]
                    r, p = pearson([a[amy] for a in rows], [a[gene] for a in rows])
                    tests.append(
                        dict(
                            expression_scale="TPM",
                            genotype=group,
                            amylase=amy,
                            trypsinogen=gene,
                            minimum_TPM=minimum,
                            n_samples=len(rows),
                            Pearson_r=r,
                            p_two_sided=p,
                        )
                    )
        for row, q in zip(tests, bh([r["p_two_sided"] for r in tests])):
            row["BH_q"] = float(q)
        output.extend(tests)
    files.table("amylase_trypsin_expression_correlations", output)

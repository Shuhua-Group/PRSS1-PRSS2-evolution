"""PRSS1/PRSS2 TPM comparisons by tissue and structural genotype."""

import numpy as np
from scipy import stats
from .common import pearson


def run(files):
    tpm = files.read("pancreas_tpm")
    data = [
        dict(
            tissue="pancreas",
            genotype=r["genotype"],
            PRSS1=r["PRSS1"],
            PRSS2=r["PRSS2"],
        )
        for r in tpm
    ]
    data.extend(files.read("other_tissues_tpm"))
    tests = []
    for tissue in dict.fromkeys(r["tissue"] for r in data):
        for group in ["HOM3", "HOM5"]:
            selected = [
                r for r in data if r["tissue"] == tissue and r["genotype"] == group
            ]
            a, b = [
                np.array([float(r[k]) for r in selected]) for k in ["PRSS1", "PRSS2"]
            ]
            r, p = pearson(a, b)
            test = stats.ttest_ind(a, b, equal_var=False)
            tests.append(
                dict(
                    tissue=tissue,
                    genotype=group,
                    n_samples=len(a),
                    PRSS1_mean_TPM=float(a.mean()),
                    PRSS2_mean_TPM=float(b.mean()),
                    Pearson_r_TPM=r,
                    Pearson_p_TPM=p,
                    Welch_t=float(test.statistic),
                    Welch_p_two_sided=float(test.pvalue),
                )
            )
    files.table("tissue_prss_tpm_statistics", tests)

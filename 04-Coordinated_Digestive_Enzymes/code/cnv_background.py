"""Interchromosomal CNV correlations and fixed-pair empirical background."""

import numpy as np
from scipy import stats
from .common import bh, pearson, tail, plt


def run(files):
    populations = files.read("enzyme_population_copy_number")
    cnv = files.read("cnv_population_mean")
    if len(cnv) != 7814 or len({r["CNV"] for r in cnv}) != len(cnv):
        raise ValueError("Expected 7814 distinct interchromosomal CNVs")
    matrix = np.array([[float(r[p["population"]]) for p in populations] for r in cnv])
    matrix -= matrix.mean(axis=1, keepdims=True)
    lengths = np.linalg.norm(matrix, axis=1)
    valid = lengths > 0
    output = [
        dict(CNV=r["CNV"], constant_across_populations=bool(not ok))
        for r, ok in zip(cnv, valid)
    ]
    coefficients = {}
    for amy in ["AMY1", "AMY2"]:
        x = np.array([float(p[amy]) for p in populations])
        x -= x.mean()
        r = np.zeros(len(cnv))
        r[valid] = matrix[valid] @ x / (lengths[valid] * np.linalg.norm(x))
        r = np.clip(r, -1, 1)
        p = 2 * stats.beta(len(x) / 2 - 1, len(x) / 2 - 1, loc=-1, scale=2).cdf(
            -np.abs(r)
        )
        q = bh(p)
        cutoff = sorted(abs(r), reverse=True)[int(0.05 * len(r))]
        for row, rv, pv, qv, ok in zip(output, r, p, q, valid):
            row[amy + "_r"] = float(rv) if ok else float("nan")
            row[amy + "_p"] = float(pv) if ok else float("nan")
            row[amy + "_BH_q"] = float(qv) if ok else float("nan")
            row[amy + "_top5_percent"] = bool(abs(rv) >= cutoff)
        if amy == "AMY1":
            coefficients = {row["CNV"]: float(rv) for row, rv in zip(output, r)}
    files.table("cnv_correlations", output)
    pairs = []
    for r in files.read("cnv_random_pairs"):
        pairs.append(
            dict(
                chr6_CNV=r["chr6_CNV"],
                chr7_CNV=r["chr7_CNV"],
                chr6_R_squared=coefficients[r["chr6_CNV"]] ** 2,
                chr7_R_squared=coefficients[r["chr7_CNV"]] ** 2,
            )
        )
    files.table("cnv_random_pair_correlations", pairs)
    amy1 = [float(r["AMY1"]) for r in populations]
    observed = [
        pearson(amy1, [float(r[response]) for r in populations])[0] ** 2
        for response in ["CLPS_mean_copy", "PRSS_short_frequency"]
    ]
    a, b = [
        np.array([r[k] for r in pairs]) for k in ["chr6_R_squared", "chr7_R_squared"]
    ]
    comparison = []
    for label, values, value in [
        ("chr6_AMY1_CLPS", a, observed[0]),
        ("chr7_AMY1_PRSS", b, observed[1]),
    ]:
        comparison.append(
            dict(
                comparison=label,
                observed_R_squared=value,
                q95=float(np.quantile(values, 0.95)),
                **tail(values, value),
            )
        )
    comparison.append(
        dict(
            comparison="joint_upper_tail",
            observed_R_squared="NA",
            q95="NA",
            **tail(((a >= observed[0]) & (b >= observed[1])).astype(float), 1),
        )
    )
    files.table("cnv_empirical_comparisons", comparison)
    fig, ax = plt.subplots(figsize=(5.2, 4.3))
    ax.scatter(a, b, s=3, alpha=0.15, color="#286496", rasterized=True)
    ax.scatter(*observed, marker="*", s=140, color="#bd5d4b", zorder=3)
    ax.axvline(float(np.quantile(a, 0.95)), color="gray", linestyle="--", linewidth=0.8)
    ax.axhline(float(np.quantile(b, 0.95)), color="gray", linestyle="--", linewidth=0.8)
    ax.set(xlabel="AMY1 vs chr6 CNV: R squared", ylabel="AMY1 vs chr7 CNV: R squared")
    files.figure("cnv_background", fig)

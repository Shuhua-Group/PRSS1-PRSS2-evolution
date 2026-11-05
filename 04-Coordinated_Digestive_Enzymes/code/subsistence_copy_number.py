"""Digestive-enzyme copy-number comparisons by subsistence group."""

from collections import Counter
import numpy as np
from scipy import stats
from .common import plt


def run(files):
    data = files.read("diet_copy_number")
    if len({r["sample_id"] for r in data}) != len(data):
        raise ValueError("Duplicate subsistence sample")
    labels = ["Agriculture", "Fishing/hunting/pastoralism"]
    results, counts = [], []
    fig, axes = plt.subplots(1, 3, figsize=(10, 3.8))
    for ax, gene in zip(axes, ["PRSS_copy", "CLPS_copy", "AMY_copy"]):
        a, b = [
            np.array([float(r[gene]) for r in data if r["subsistence"] == label])
            for label in labels
        ]
        test = stats.mannwhitneyu(
            a, b, alternative="two-sided", method="asymptotic", use_continuity=True
        )
        results.append(
            dict(
                gene=gene,
                n_agriculture=len(a),
                n_other=len(b),
                mean_agriculture=float(a.mean()),
                mean_other=float(b.mean()),
                Wilcoxon_U=float(test.statistic),
                p_two_sided=float(test.pvalue),
            )
        )
        for i, (label, values) in enumerate(zip(labels, [a, b])):
            c = Counter(values)
            counts.extend(
                dict(gene=gene, group=label, copy_number=float(k), n_samples=v)
                for k, v in sorted(c.items())
            )
            ax.scatter(
                list(c),
                [i] * len(c),
                s=[v * 7 for v in c.values()],
                alpha=0.6,
                color=["#286496", "#bd5d4b"][i],
            )
        ax.set_yticks(
            [0, 1],
            [f"Agriculture ({len(a)})", f"Other subsistence ({len(b)})"],
            fontsize=7,
        )
        values = np.concatenate([a, b])
        margin = max(0.5, np.ptp(values) * 0.12)
        ax.set(
            xlim=(min(values) - margin, max(values) + margin),
            ylim=(-0.6, 1.6),
            xlabel="Diploid copy number",
            title=f"{gene}: P={test.pvalue:.3g}",
        )
    files.table("subsistence_copy_number_statistics", results)
    files.table("subsistence_copy_number_distribution", counts)
    files.figure("subsistence_copy_number", fig)

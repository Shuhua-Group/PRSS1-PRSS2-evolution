"""Population correlations among digestive-enzyme copy-number summaries."""

import numpy as np
from .common import pearson, plt


def run(files):
    populations = files.read("enzyme_population_copy_number")
    if len({r["population"] for r in populations}) != 13:
        raise ValueError("Expected 13 population summaries")
    correlations = []
    fig, axes = plt.subplots(2, 3, figsize=(10, 6))
    for i, amy in enumerate(["AMY1", "AMY2", "AMY_total"]):
        for j, response in enumerate(["PRSS_short_frequency", "CLPS_mean_copy"]):
            x, y = [
                np.array([float(r[k]) for r in populations]) for k in [amy, response]
            ]
            r, p = pearson(x, y)
            correlations.append(
                dict(
                    AMY_variable=amy,
                    response=response,
                    n_populations=len(x),
                    Pearson_r=r,
                    R_squared=r * r,
                    p_two_sided=p,
                )
            )
            ax = axes[j, i]
            ax.scatter(x, y, color="#286496", s=25)
            for a, b, row in zip(x, y, populations):
                ax.annotate(
                    row["population"],
                    (a, b),
                    fontsize=6,
                    xytext=(3, 2),
                    textcoords="offset points",
                )
            grid = np.linspace(min(x), max(x), 50)
            ax.plot(
                grid,
                np.polyval(np.polyfit(x, y, 1), grid),
                color="#bd5d4b",
                linewidth=1,
            )
            ax.set(
                xlabel=amy + " mean diploid copy number",
                ylabel=response,
                title=f"r={r:.4f}; P={p:.3g}; n={len(x)}",
            )
    files.table("enzyme_copy_number_correlations", correlations)
    files.figure("enzyme_copy_number_correlations", fig)

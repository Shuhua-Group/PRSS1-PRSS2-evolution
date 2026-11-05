"""PRSS Tajima D comparisons against retained chromosome-7 windows."""

from collections import defaultdict
import math
import numpy as np
from .common import tail, plt


def run(files):
    background = defaultdict(list)
    for r in files.read("tajima_d_background"):
        value = float(r["TajimaD"])
        if not math.isfinite(value):
            raise ValueError("Nonfinite Tajima D window")
        background[(r["Continent"], r["PRSS"])].append(value)
    result = []
    for r in files.read("tajima_d_observed"):
        bg = background[(r["population_label"], r["gene"])]
        value = float(r["Tajima_D"])
        result.append(
            dict(
                population_label=r["population_label"],
                gene=r["gene"],
                copy_number=int(r["copy_number"]),
                Tajima_D=value,
                q05=float(np.quantile(bg, 0.05)),
                **tail(bg, value, True),
            )
        )
    files.table("tajima_d_comparisons", result)
    fig, axes = plt.subplots(1, 3, figsize=(10, 3.6))
    for ax, (cont, label) in zip(
        axes, [("AFR", "YRI / AFR"), ("EUR", "CEU / EUR"), ("EAS", "CHB / EAS")]
    ):
        ax.hist(background[(cont, "PRSS2")], bins=40, density=True, color="#c3cdd3")
        for copy, color in [(3, "#bd5d4b"), (5, "#286496")]:
            row = next(
                r
                for r in result
                if r["population_label"] == cont
                and r["gene"] == "PRSS2"
                and r["copy_number"] == copy
            )
            ax.axvline(
                row["Tajima_D"],
                color=color,
                label=f'{copy}-copy: P={row["empirical_fraction"]:.3g}',
            )
        ax.set(xlabel="PRSS2 Tajima's D", ylabel="Density", title=label)
        ax.legend(fontsize=7)
    files.figure("tajima_d_background", fig)

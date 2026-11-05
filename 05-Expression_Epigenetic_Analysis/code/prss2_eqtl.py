"""Plot retained pancreas PRSS2 eQTL effect sizes and LD."""

import math
from matplotlib.ticker import MaxNLocator, FormatStrFormatter
from .common import plt


def run(files):
    eqtl = files.read("prss2_eqtl")
    output = []
    for r in eqtl:
        p, ld = float(r["p_value"]), float(r["LD_R_squared_with_tag"])
        if not 0 < p <= 1 or not 0 <= ld <= 1:
            raise ValueError("Invalid eQTL P or LD")
        output.append(
            dict(
                variant_id=r["variant_id"],
                rsid=r["rsid"],
                position_GRCh38=int(r["position_GRCh38"]),
                normalized_effect_size=float(r["normalized_effect_size"]),
                p_value=p,
                minus_log10_p=-math.log10(p),
                LD_R_squared_with_tag=ld,
            )
        )
    files.table("prss2_eqtl", output)
    fig, axes = plt.subplots(1, 2, figsize=(9, 3.7))
    for ax, ycol, label in [
        (axes[0], "normalized_effect_size", "Normalized effect size"),
        (axes[1], "minus_log10_p", "-log10(P)"),
    ]:
        scatter = ax.scatter(
            [r["position_GRCh38"] / 1e6 for r in output],
            [r[ycol] for r in output],
            c=[r["LD_R_squared_with_tag"] for r in output],
            vmin=0,
            vmax=1,
            cmap="viridis",
            s=24,
        )
        tag = next(r for r in output if r["rsid"] == "rs2855983")
        ax.annotate(
            "rs2855983",
            (tag["position_GRCh38"] / 1e6, tag[ycol]),
            fontsize=7,
            xytext=(5, 8),
            textcoords="offset points",
        )
        ax.set(xlabel="chr7 GRCh38 position (Mb)", ylabel=label)
        ax.xaxis.set_major_locator(MaxNLocator(4))
        ax.xaxis.set_major_formatter(FormatStrFormatter("%.2f"))
    fig.colorbar(scatter, ax=axes[1], label="LD R squared with tag")
    files.figure("prss2_eqtl", fig)

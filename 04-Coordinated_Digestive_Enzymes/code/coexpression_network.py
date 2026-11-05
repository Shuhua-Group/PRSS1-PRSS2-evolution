"""Summarize and plot a retained pancreas WGCNA module."""

from collections import Counter, defaultdict
import math
import numpy as np
from .common import plt


def run(files):
    nodes = files.read("pancreas_network_nodes")
    edges = files.read("pancreas_network_edges")
    genes = {r["gene_id"]: r["gene"] for r in nodes}
    degree = Counter()
    strength = defaultdict(float)
    for e in edges:
        a, b, w = e["source_id"], e["target_id"], float(e["weight"])
        if w < 0.1 or a not in genes or b not in genes:
            raise ValueError("Invalid network edge")
        degree[a] += 1
        degree[b] += 1
        strength[a] += w
        strength[b] += w
    summary = sorted(
        [
            dict(gene_id=k, gene=v, degree=degree[k], weighted_degree=strength[k])
            for k, v in genes.items()
        ],
        key=lambda r: (-r["degree"], r["gene_id"]),
    )
    files.table("pancreas_network_degrees", summary)
    selected = [r["gene_id"] for r in summary[:24]]
    for r in summary:
        if (
            r["gene"]
            in [
                "PRSS1",
                "PRSS2",
                "CLPS",
                "CEL",
                "AMY1A",
                "AMY1B",
                "AMY1C",
                "AMY2A",
                "AMY2B",
            ]
            and r["gene_id"] not in selected
        ):
            selected.append(r["gene_id"])
    xy = {
        k: (math.cos(t), math.sin(t))
        for k, t in zip(
            selected, np.linspace(0, 2 * np.pi, len(selected), endpoint=False)
        )
    }
    fig, ax = plt.subplots(figsize=(7, 7))
    for e in edges:
        a, b = e["source_id"], e["target_id"]
        if a in xy and b in xy:
            ax.plot(
                [xy[a][0], xy[b][0]],
                [xy[a][1], xy[b][1]],
                color="#728b9a",
                alpha=0.4,
                linewidth=0.4 + float(e["weight"]) * 1.5,
            )
    for k, (x, y) in xy.items():
        ax.scatter(x, y, s=25 + degree[k] * 2, color="#286496", zorder=3)
        ax.text(x * 1.13, y * 1.13, genes[k], ha="center", va="center", fontsize=7)
    ax.set(xlim=(-1.4, 1.4), ylim=(-1.4, 1.4))
    ax.set_axis_off()
    files.figure("pancreas_coexpression_network", fig)

#!/usr/bin/env python3
"""
03_plot_tpm_distribution.py

Histogram of log10(TPM + 1) across all genes of one sample, with the median
and 95th percentile marked and selected genes highlighted.

Example
-------
python 03_plot_tpm_distribution.py \
    --tpm matrix/HG002MAT/gene_TPM_matrix.tsv --sample pancreas \
    --out-prefix pancreas_TPM_distribution

Input
-----
--tpm     Tab-delimited matrix with a ``gene_id`` column and one TPM column
          per sample.
--sample  TPM column to plot.
--genes   Genes to highlight as NAME=GENE_ID [PRSS genes, see DEFAULT_GENES].

Output: <out-prefix>.png and <out-prefix>.pdf
"""

import argparse
import sys
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns

# Gene IDs as annotated on the GRCh38 alt contig chr7_KI270803v1_alt (GENCODE)
DEFAULT_GENES = [
    "PRSS1=ENSG00000274247.4",
    "PRSS3P1=ENSG00000282295.1",
    "PRSS3P2=ENSG00000282667.1",
    "TRY7=ENSG00000282565.1",
    "PRSS2=ENSG00000282049.1",
]

HIST_FACE = "#A8C5D6"
MEDIAN_CLR = "#2E7D5B"
P95_CLR = "#6B6B6B"
GENE_CLR = "#C0392B"


def parse_args():
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--tpm", required=True, help="Gene TPM matrix")
    p.add_argument("--sample", default=None, help="Column to plot [first after gene_id]")
    p.add_argument("--samples", nargs="+", help="Sample columns for a multi-panel figure")
    p.add_argument("--titles", nargs="+", help="Panel titles in sample order")
    p.add_argument("--ncols", type=int, default=2, help="Columns in multi-panel output [2]")
    p.add_argument("--title", default=None, help="Plot title [Gene expression distribution — <sample>]")
    p.add_argument("--genes", nargs="+", default=DEFAULT_GENES, metavar="NAME=GENE_ID",
                   help="Genes to highlight")
    p.add_argument("--label-x-offsets", nargs="+", type=float, default=[0.0],
                   help="Horizontal offsets (log10 units) of the gene labels, in order of increasing "
                        "expression; recycled if shorter than the gene list [0]")
    p.add_argument("--label-y-frac", type=float, default=1e-4,
                   help="Label height as a fraction of the y-axis maximum (log scale) [1e-4]")
    p.add_argument("--xmax-quantile", type=float, default=0.995,
                   help="Truncate the x-axis at this quantile (extended to show highlighted genes) [0.995]")
    p.add_argument("--bins", type=int, default=100, help="Histogram bins [100]")
    p.add_argument("--out-prefix", default=None, help="Output prefix [<sample>_TPM_distribution]")
    p.add_argument("--dpi", type=int, default=600, help="Resolution [600]")
    args = p.parse_args()
    if args.sample and args.samples:
        p.error("Use --sample or --samples, not both")
    if args.ncols < 1:
        p.error("--ncols must be positive")
    if not 0 < args.xmax_quantile <= 1 or args.bins < 1:
        p.error("Require 0 < --xmax-quantile <= 1 and positive --bins")
    return args


def plot_sample(df, sample, title, args, ax):
    tpm = pd.to_numeric(df[sample], errors="raise")
    if tpm.isna().any() or (tpm < 0).any() or not np.isfinite(tpm).all():
        raise ValueError(f"Invalid TPM values in {sample}")
    logtpm = np.log10(tpm + 1)
    tpm_by_id = dict(zip(df["gene_id"], tpm))

    tpm_median, tpm_p95 = tpm.median(), tpm.quantile(0.95)

    # highlighted genes present in the matrix, sorted by expression
    records = []
    for spec in args.genes:
        name, gid = spec.split("=", 1)
        if gid in tpm_by_id:
            v = tpm_by_id[gid]
            records.append((name, v, np.log10(v + 1)))
        else:
            print(f"[WARN] {name} ({gid}) not in matrix", file=sys.stderr)
    records.sort(key=lambda r: r[2])

    sns.histplot(logtpm, bins=args.bins, color=HIST_FACE, edgecolor="white",
                 linewidth=0.15, alpha=0.9, ax=ax)

    # ---------------- axes ----------------
    x_min = 0
    x_max = np.ceil(logtpm.quantile(args.xmax_quantile) * 10) / 10
    if records:
        x_max = max(x_max, np.ceil((records[-1][2] + 0.3) * 10) / 10)
    ax.set_xlim(x_min, max(x_max, 0.3))
    x_max = max(x_max, 0.3)
    ax.set_yscale("log")
    ax.set_ylim(0.8, ax.get_ylim()[1] * 2.0)
    ylim_top = ax.get_ylim()[1]

    # ---------------- median / P95 ----------------
    for label, q, color, ls in [("Median", tpm_median, MEDIAN_CLR, "-"),
                                ("P95", tpm_p95, P95_CLR, "--")]:
        lq = np.log10(q + 1)
        if lq <= x_max:
            ax.axvline(lq, color=color, linestyle=ls, linewidth=1.6, alpha=0.9, zorder=3)
            ax.text(lq + 0.03, ylim_top * 0.65, f"{label}  TPM={q:.2f}", rotation=90,
                    color=color, ha="left", va="top", fontsize=11, fontweight="bold")

    # ---------------- highlighted genes ----------------
    point_y = 1.2
    offs = args.label_x_offsets
    margin = x_max * 0.025
    label_positions = [min(max(r[2] + offs[i % len(offs)], margin), x_max - margin)
                       for i, r in enumerate(records)]
    # Separate low-expression labels while retaining the actual point positions.
    gap = min(x_max * 0.065, (x_max - 2 * margin) / max(1, len(records) - 1))
    for i in range(1, len(label_positions)):
        label_positions[i] = max(label_positions[i], label_positions[i - 1] + gap)
    if label_positions and label_positions[-1] > x_max - margin:
        label_positions[-1] = x_max - margin
        for i in range(len(label_positions) - 2, -1, -1):
            label_positions[i] = min(label_positions[i], label_positions[i + 1] - gap)
    label_y = max(point_y * 2, ylim_top * args.label_y_frac)
    for i, (name, v, lt) in enumerate(records):
        if lt > x_max:
            continue
        ax.scatter(lt, point_y, color=GENE_CLR, edgecolor="white", linewidth=0.9, s=85, zorder=6)
        label_x = label_positions[i]
        ax.annotate(f"{name}\nTPM={v:.2f}", xy=(lt, point_y),
                    xytext=(label_x, label_y), textcoords="data",
                    ha="center", va="bottom", fontsize=11, fontweight="bold",
                    color=GENE_CLR, rotation=90,
                    arrowprops=dict(arrowstyle="-", color=GENE_CLR, lw=0.8, alpha=0.7),
                    zorder=7)

    ax.set_xlabel(r"$\log_{10}(\mathrm{TPM} + 1)$", fontsize=14)
    ax.set_ylabel("Gene count (log scale)", fontsize=14)
    ax.set_title(title, fontsize=14, fontweight="bold", pad=12)
    ax.tick_params(labelsize=12)
    ax.grid(axis="y", linestyle=":", alpha=0.45)
    sns.despine(ax=ax)


def main():
    args = parse_args()
    df = pd.read_csv(args.tpm, sep="\t")
    if "gene_id" not in df.columns or df.empty:
        sys.exit("[ERROR] A nonempty matrix with a gene_id column is required")
    if df["gene_id"].isna().any() or df["gene_id"].duplicated().any():
        sys.exit("[ERROR] gene_id must be nonmissing and unique")
    candidates = [c for c in df.columns if c != "gene_id"]
    samples = args.samples or ([args.sample] if args.sample else candidates[:1])
    if not samples or any(sample not in candidates for sample in samples):
        sys.exit(f"[ERROR] Unknown sample; available columns: {candidates}")
    if args.titles and len(args.titles) != len(samples):
        sys.exit("[ERROR] --titles must contain one title per sample")
    titles = args.titles or [args.title or x.replace("_", " ").title() for x in samples]
    out_prefix = args.out_prefix or (samples[0] + "_TPM_distribution" if len(samples) == 1 else "TPM_distribution_panels")
    Path(out_prefix).parent.mkdir(parents=True, exist_ok=True)
    # ---------------- style ----------------
    sns.set_style("ticks")
    plt.rcParams.update({
        "font.family": "sans-serif",
        "font.sans-serif": ["Arial", "Liberation Sans", "Helvetica", "DejaVu Sans"],
        "axes.edgecolor": "#333333",
        "axes.linewidth": 1.0,
        "pdf.fonttype": 42,
        "ps.fonttype": 42,
    })

    if len(samples) == 1:
        fig, ax = plt.subplots(figsize=(11, 6.5))
        axes = [ax]
    else:
        ncols = min(args.ncols, len(samples))
        nrows = (len(samples) + ncols - 1) // ncols
        fig, grid = plt.subplots(nrows, ncols, figsize=(7 * ncols, 5 * nrows), squeeze=False)
        axes = list(grid.flat)
    for sample, title, ax in zip(samples, titles, axes):
        plot_sample(df, sample, title, args, ax)
    for ax in axes[len(samples):]:
        ax.set_visible(False)
    fig.tight_layout()

    for ext in ("pdf", "png"):
        fig.savefig(f"{out_prefix}.{ext}", dpi=args.dpi, bbox_inches="tight")
    plt.close(fig)
    print(f"[INFO] wrote {out_prefix}.pdf/.png", file=sys.stderr)


if __name__ == "__main__":
    main()

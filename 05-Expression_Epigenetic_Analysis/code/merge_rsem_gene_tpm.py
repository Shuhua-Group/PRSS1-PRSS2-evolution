#!/usr/bin/env python3
"""
merge_rsem_gene_tpm.py

Merge the TPM column of RSEM ``*.genes.results`` files.

Example
-------
python merge_rsem_gene_tpm.py -i rsem/HG002MAT -o matrix/HG002MAT/gene_TPM_matrix.tsv
"""

import argparse
import sys
from pathlib import Path

import pandas as pd


def main():
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("-i", "--input", required=True, help="Directory with RSEM results")
    p.add_argument("-o", "--output", required=True, help="Output TSV")
    p.add_argument("--value", default="TPM", help="Column to merge (TPM, FPKM, expected_count) [TPM]")
    p.add_argument("--samples", nargs="+", help="Merge only these sample prefixes, in this order")
    args = p.parse_args()

    files = sorted(Path(args.input).rglob("*.genes.results"))
    if not files:
        sys.exit(f"[ERROR] no *.genes.results under {args.input}")

    if args.samples:
        if len(set(args.samples)) != len(args.samples):
            sys.exit("[ERROR] Duplicate names in --samples")
        selected = {}
        for f in files:
            name = f.name[:-len(".genes.results")]
            if name in args.samples:
                if name in selected:
                    sys.exit(f"[ERROR] Multiple results for sample {name}")
                selected[name] = f
        missing = set(args.samples) - selected.keys()
        if missing:
            sys.exit(f"[ERROR] Missing samples: {sorted(missing)}")
        files = [selected[name] for name in args.samples]

    cols = []
    for f in files:
        sample = f.name[: -len(".genes.results")]
        df = pd.read_csv(f, sep="\t", usecols=["gene_id", args.value], index_col="gene_id")
        if df.index.hasnans or not df.index.is_unique:
            sys.exit(f"[ERROR] Missing or duplicate gene_id in {f}")
        if sample in [col.name for col in cols]:
            sys.exit(f"[ERROR] Duplicate sample prefix: {sample}")
        cols.append(df[args.value].rename(sample))

    mat = pd.concat(cols, axis=1, join="outer").fillna(0)
    Path(args.output).parent.mkdir(parents=True, exist_ok=True)
    mat.index.name = "gene_id"
    mat.to_csv(args.output, sep="\t")
    print(f"[INFO] {mat.shape[0]} genes x {mat.shape[1]} samples -> {args.output}", file=sys.stderr)


if __name__ == "__main__":
    main()

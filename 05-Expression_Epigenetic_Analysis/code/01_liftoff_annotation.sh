#!/usr/bin/env bash
#
# 01_liftoff_annotation.sh
#
# Lift gene annotation from a source sequence (e.g. the GRCh38 alt contig
# chr7_KI270803v1_alt, which carries the PRSS locus) onto a target assembly.
#
# Dependencies: liftoff
#
# Usage:
#   bash 01_liftoff_annotation.sh -t target.fa -s source.fa -g source.gff3 -o out.gff3 [-p THREADS] [-c 0.95]
#
# Required:
#   -t FILE  Target assembly FASTA
#   -s FILE  Source/reference FASTA the annotation belongs to
#   -g FILE  Source annotation (GFF3/GTF)
#   -o FILE  Output GFF3
#
# Options:
#   -p INT    Threads [16]
#   -c FLOAT  Minimum sequence identity for additional copies (-sc) [0.95]
#   -h        Show this help
#
set -euo pipefail

usage() { sed -n '2,/^set -euo/p' "$0" | sed '$d' | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }
die()   { echo "[ERROR] $*" >&2; exit 1; }

TARGET=""; SOURCE=""; GFF=""; OUT=""; THREADS=16; SC=0.95
while getopts ":t:s:g:o:p:c:h" opt; do
    case "$opt" in
        t) TARGET="$OPTARG" ;;
        s) SOURCE="$OPTARG" ;;
        g) GFF="$OPTARG" ;;
        o) OUT="$OPTARG" ;;
        p) THREADS="$OPTARG" ;;
        c) SC="$OPTARG" ;;
        h) usage 0 ;;
        *) usage 1 ;;
    esac
done
[[ -n "$TARGET" && -n "$SOURCE" && -n "$GFF" && -n "$OUT" ]] || usage 1
for f in "$TARGET" "$SOURCE" "$GFF"; do [[ -f "$f" ]] || die "File not found: $f"; done
command -v liftoff >/dev/null 2>&1 || die "'liftoff' not found in PATH"

mkdir -p "$(dirname "$OUT")"
tmpdir="${OUT}.liftoff_tmp"
liftoff -g "$GFF" -o "$OUT" -dir "$tmpdir" -p "$THREADS" \
        -sc "$SC" -copies -polish \
        "$TARGET" "$SOURCE"

echo "[INFO] Done: $OUT (polished: ${OUT}_polished)" >&2

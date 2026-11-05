#!/usr/bin/env bash
#
# blastn_best_hit.sh
#
# Search query sequences (e.g. human PRSS gene copies) against a subject
# sequence (e.g. an NHP T2T locus) with BLASTN (megablast) and keep, for each
# query, the single hit with the highest bit score.
#
# Dependencies: blastn (NCBI BLAST+)
#
# Usage:
#   bash blastn_best_hit.sh [-e EVALUE] [-t THREADS] [-a ALL_HITS.tsv] <query.fa> <subject.fa> <output.tsv>
#
# Options:
#   -e FLOAT  E-value cutoff [1e-5]
#   -t INT    BLAST threads [1]
#   -a FILE   Also retain all reported BLAST HSPs
#   -h        Show this help
#
# Output: BLAST tabular format 6 (12 standard columns), one line per query,
#         sorted by query ID. Ties in bit score keep the first-reported hit.
#
set -euo pipefail

usage() { sed -n '2,/^set -euo/p' "$0" | sed '$d' | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }
die()   { echo "[ERROR] $*" >&2; exit 1; }

EVALUE="1e-5"; THREADS=1; ALL_HITS=""
while getopts ":e:t:a:h" opt; do
    case "$opt" in
        e) EVALUE="$OPTARG" ;;
        t) THREADS="$OPTARG" ;;
        a) ALL_HITS="$OPTARG" ;;
        h) usage 0 ;;
        *) usage 1 ;;
    esac
done
shift $((OPTIND - 1))
[[ $# -eq 3 ]] || usage 1

query="$1"; subject="$2"; out="$3"
[[ -f "$query"   ]] || die "Query file not found: $query"
[[ -f "$subject" ]] || die "Subject file not found: $subject"
[[ "$THREADS" =~ ^[1-9][0-9]*$ ]] || die "Threads must be a positive integer"
[[ -z "$ALL_HITS" || "$ALL_HITS" != "$out" ]] || die "All-hit and best-hit outputs must differ"
command -v blastn >/dev/null 2>&1 || die "'blastn' not found in PATH"

echo "[INFO] blastn: query=$query subject=$subject -> $out" >&2

mkdir -p "$(dirname "$out")"
[[ -z "$ALL_HITS" ]] || mkdir -p "$(dirname "$ALL_HITS")"
tmp_hits="$(mktemp)"
trap 'rm -f "$tmp_hits"' EXIT
blastn -query "$query" -subject "$subject" \
       -task megablast -evalue "$EVALUE" -num_threads "$THREADS" -outfmt 6 > "$tmp_hits"
[[ -z "$ALL_HITS" ]] || cp "$tmp_hits" "$ALL_HITS"

awk -F'\t' 'BEGIN{OFS="\t"}
    # $1 = query ID, $12 = bit score
    !($1 in best) || $12 + 0 > best[$1] { best[$1] = $12 + 0; line[$1] = $0 }
    END { for (q in line) print line[q] }' "$tmp_hits" \
| sort -k1,1 > "$out"

echo "[INFO] Done: $(wc -l < "$out") queries with hits" >&2

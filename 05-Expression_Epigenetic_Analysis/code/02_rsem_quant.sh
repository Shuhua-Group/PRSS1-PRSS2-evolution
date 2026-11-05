#!/usr/bin/env bash
#
# 02_rsem_quant.sh
#
# Short-read RNA-seq quantification against a custom reference.
#
# Dependencies: rsem, STAR, fastp, python3 (pandas)
#
# Usage:
#   bash 02_rsem_quant.sh -r genome.fa -a annotation.gff3 -n REF_NAME [options] SAMPLE [SAMPLE ...]
#
# Required:
#   -r FILE  Genome FASTA used to build the reference
#   -a FILE  Annotation GFF3 for the genome
#   -n STR   Reference name
#
# Options:
#   -i DIR   Input FASTQ directory [01_fastq]
#   -o DIR   Output root directory [.]
#   -S STR   Library strandedness for RSEM: none | forward | reverse [reverse]
#   -T       Inputs are already trimmed; skip fastp
#   -t INT   Threads [16]
#   -h       Show this help
#
set -euo pipefail

usage() { sed -n '2,/^set -euo/p' "$0" | sed '$d' | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }
log()   { echo "[$(date '+%F %T')] $*" >&2; }
die()   { echo "[ERROR] $*" >&2; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GENOME=""; GFF=""; REFNAME=""; FQ_DIR="01_fastq"; ROOT="."; STRAND="reverse"; TRIM=1; THREADS=16
while getopts ":r:a:n:i:o:S:Tt:h" opt; do
    case "$opt" in
        r) GENOME="$OPTARG" ;;
        a) GFF="$OPTARG" ;;
        n) REFNAME="$OPTARG" ;;
        i) FQ_DIR="$OPTARG" ;;
        o) ROOT="$OPTARG" ;;
        S) STRAND="$OPTARG" ;;
        T) TRIM=0 ;;
        t) THREADS="$OPTARG" ;;
        h) usage 0 ;;
        *) usage 1 ;;
    esac
done
shift $((OPTIND - 1))
[[ -n "$GENOME" && -n "$GFF" && -n "$REFNAME" && $# -ge 1 ]] || usage 1
for f in "$GENOME" "$GFF"; do [[ -f "$f" ]] || die "File not found: $f"; done
for t in rsem-prepare-reference rsem-calculate-expression python3; do
    command -v "$t" >/dev/null 2>&1 || die "'$t' not found in PATH"
done
case "$STRAND" in none|forward|reverse) ;; *) die "Invalid strandedness: $STRAND" ;; esac
[[ "$THREADS" =~ ^[1-9][0-9]*$ ]] || die "Threads must be a positive integer"
# Check every requested FASTQ before building an expensive reference.
for sample in "$@"; do
    [[ -f "${FQ_DIR}/${sample}.fastq.gz" ]] || die "FASTQ not found: ${FQ_DIR}/${sample}.fastq.gz"
done
[[ "$TRIM" -eq 0 ]] || command -v fastp >/dev/null 2>&1 || die "'fastp' not found in PATH"

STAR_OPT=()
[[ -n "${STAR_PATH:-}" ]] && STAR_OPT=(--star-path "$STAR_PATH")

REF_DIR="${ROOT}/rsem_ref/${REFNAME}"
REF_PREFIX="${REF_DIR}/${REFNAME}"
D_TRIM="${ROOT}/trimmed"
D_RSEM="${ROOT}/rsem/${REFNAME}"
D_MAT="${ROOT}/matrix/${REFNAME}"
mkdir -p "$REF_DIR" "$D_RSEM" "$D_MAT"

# 1. reference (built once)
if [[ ! -f "${REF_PREFIX}.grp" ]]; then
    log "Building RSEM/STAR reference: $REF_PREFIX"
    rsem-prepare-reference --gff3 "$GFF" --star "${STAR_OPT[@]}" -p "$THREADS" \
        "$GENOME" "$REF_PREFIX"
fi

for sample in "$@"; do
    log "Sample: $sample"
    raw="${FQ_DIR}/${sample}.fastq.gz"
    [[ -f "$raw" ]] || die "FASTQ not found: $raw"

    # 2. trimming
    if [[ "$TRIM" -eq 1 ]]; then
        mkdir -p "$D_TRIM"
        fq="${D_TRIM}/${sample}.trimmed.fastq.gz"
        fastp -i "$raw" -o "$fq" --thread "$THREADS" \
              --html "${D_TRIM}/${sample}.fastp.html" \
              --json "${D_TRIM}/${sample}.fastp.json"
    else
        fq="$raw"
    fi

    # 3. quantification
    mkdir -p "${D_RSEM}/${sample}"
    rsem-calculate-expression --strandedness "$STRAND" \
        --star "${STAR_OPT[@]}" --star-gzipped-read-file -p "$THREADS" \
        "$fq" "$REF_PREFIX" "${D_RSEM}/${sample}/${sample}"
done

# 4. merge gene-level TPM
python3 "${SCRIPT_DIR}/merge_rsem_gene_tpm.py" \
    -i "$D_RSEM" -o "${D_MAT}/gene_TPM_matrix.tsv" --samples "$@"

log "Done: ${D_MAT}/gene_TPM_matrix.tsv"

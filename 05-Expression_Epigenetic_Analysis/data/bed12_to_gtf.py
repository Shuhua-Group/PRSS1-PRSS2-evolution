#!/usr/bin/env python3

import sys

bed_file = sys.argv[1]
gtf_file = sys.argv[2]

with open(bed_file) as bed, open(gtf_file, "w") as out:
    for line in bed:
        if not line.strip() or line.startswith("#"):
            continue

        fields = line.rstrip("\n").split("\t")
        if len(fields) < 12:
            continue

        chrom = fields[0]
        tx_start = int(fields[1])
        tx_end = int(fields[2])
        name = fields[3]
        strand = fields[5]
        block_count = int(fields[9])
        block_sizes = [int(x) for x in fields[10].rstrip(",").split(",")]
        block_starts = [int(x) for x in fields[11].rstrip(",").split(",")]

        # BED name is used as a transcript identifier here.
        transcript_id = name
        gene_id = name

        attributes = (
            f'gene_id "{gene_id}"; '
            f'transcript_id "{transcript_id}";'
        )

        # Transcript-level feature
        out.write(
            f"{chrom}\tpaftools\ttranscript\t"
            f"{tx_start + 1}\t{tx_end}\t.\t{strand}\t.\t"
            f"{attributes}\n"
        )

        # Exon features
        for i, (size, start) in enumerate(zip(block_sizes, block_starts), 1):
            exon_start = tx_start + start + 1
            exon_end = exon_start + size - 1

            exon_attributes = (
                f'gene_id "{gene_id}"; '
                f'transcript_id "{transcript_id}"; '
                f'exon_number "{i}";'
            )

            out.write(
                f"{chrom}\tpaftools\texon\t"
                f"{exon_start}\t{exon_end}\t.\t{strand}\t.\t"
                f"{exon_attributes}\n"
            )
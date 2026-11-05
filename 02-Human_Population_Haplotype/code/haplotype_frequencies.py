"""Population structure and phased haplotype frequencies."""

from collections import Counter, defaultdict
import numpy as np
from .common import plt

GENES = ["PRSS1", "PRSS3P1", "PRSS3P2", "TRY7", "PRSS2"]


def alleles(files):
    rows = files.read("sample_haplotypes")
    if len({r["Sample"] for r in rows}) != len(rows):
        raise ValueError("Duplicate sample ID")
    result = []
    for r in rows:
        values = {
            k: r[k].split("|")
            for k in ["Copy Number", "Haplotype"] + [g + "_CDS" for g in GENES]
        }
        if any(len(v) != 2 for v in values.values()):
            raise ValueError("Incomplete phased annotation: " + r["Sample"])
        for i in range(2):
            copy = int(values["Copy Number"][i])
            if copy not in [3, 4, 5]:
                raise ValueError("Unexpected copy structure")
            result.append(
                dict(
                    sample_id=r["Sample"],
                    allele_index=i + 1,
                    project=r["Project"],
                    population=r["Population"],
                    superpopulation=r["Super population"],
                    copy_number=copy,
                    haplotype=values["Haplotype"][i],
                    **{g + "_CDS": values[g + "_CDS"][i] for g in GENES}
                )
            )
    return result


def run(files):
    data = alleles(files)
    result, haplotypes = [], []
    for grouping in ["population", "superpopulation", "project"]:
        grouped = defaultdict(list)
        for r in data:
            key = (
                (r["project"], r[grouping])
                if grouping == "population"
                else ("ALL", r[grouping])
            )
            grouped[key].append(r)
        for (project, label), rows in sorted(grouped.items()):
            c = Counter(r["copy_number"] for r in rows)
            result.append(
                dict(
                    grouping=grouping,
                    project=project,
                    group=label,
                    n_samples=len({r["sample_id"] for r in rows}),
                    n_alleles=len(rows),
                    n_copy3=c[3],
                    n_copy4=c[4],
                    n_copy5=c[5],
                    frequency_copy3=c[3] / len(rows),
                    frequency_copy4=c[4] / len(rows),
                    frequency_copy5=c[5] / len(rows),
                )
            )
            for (copy, hap), n in sorted(
                Counter((r["copy_number"], r["haplotype"]) for r in rows).items()
            ):
                haplotypes.append(
                    dict(
                        grouping=grouping,
                        project=project,
                        group=label,
                        copy_number=copy,
                        haplotype=hap,
                        allele_count=n,
                        all_alleles=len(rows),
                        frequency=n / len(rows),
                    )
                )
    files.table("structure_frequencies", result)
    files.table("haplotype_frequencies", haplotypes)
    rows = sorted(
        [r for r in result if r["grouping"] == "population"],
        key=lambda r: (r["project"], r["frequency_copy3"]),
    )
    fig, ax = plt.subplots(figsize=(13, 4))
    bottom = np.zeros(len(rows))
    for copy, color in [(5, "#286496"), (4, "#d6b355"), (3, "#bd5d4b")]:
        y = np.array([r["frequency_copy" + str(copy)] for r in rows])
        ax.bar(
            np.arange(len(y)), y, bottom=bottom, color=color, label=str(copy) + "-copy"
        )
        bottom += y
    ax.set_xticks(range(len(rows)), [r["group"] for r in rows], rotation=90, fontsize=7)
    ax.set(ylabel="Allele frequency", ylim=(0, 1))
    ax.legend(ncol=3, loc="upper left", bbox_to_anchor=(0, 1.17))
    files.figure("structure_frequencies", fig)

"""CLPS diploid copy-number frequencies in the retained population summaries."""

import numpy as np

from .common import plt


def run(files):
    rows = files.read("clps_population_copy_number")
    if len({row["population"] for row in rows}) != len(rows):
        raise ValueError("Duplicate CLPS population")
    results = []
    for row in rows:
        n = int(row["n_individuals"])
        values = np.array([float(row[f"frequency_copy{copy}"]) for copy in range(2, 7)])
        if (
            n <= 0
            or not np.isfinite(values).all()
            or (values < 0).any()
            or (values > 1).any()
        ):
            raise ValueError("Invalid CLPS copy-number frequency")
        counts = np.rint(values * n).astype(int)
        if (
            not np.isclose(values.sum(), 1, atol=1e-10, rtol=0)
            or counts.sum() != n
            or not np.allclose(counts / n, values, atol=1e-10, rtol=0)
        ):
            raise ValueError(
                "CLPS frequencies do not resolve to the stated sample size"
            )
        results.append(
            dict(
                population=row["population"],
                n_individuals=n,
                mean_diploid_copy_number=float(np.dot(counts, np.arange(2, 7)) / n),
                **{f"n_copy{copy}": int(counts[copy - 2]) for copy in range(2, 7)},
                **{
                    f"frequency_copy{copy}": float(counts[copy - 2] / n)
                    for copy in range(2, 7)
                },
            )
        )
    files.table("clps_population_copy_number_summary", results)
    fig, ax = plt.subplots(figsize=(10, 4))
    bottom = np.zeros(len(results))
    for copy, color in zip(
        range(2, 7), ["#286496", "#6c9eb3", "#d6b355", "#bd5d4b", "#79516a"]
    ):
        values = np.array([row[f"frequency_copy{copy}"] for row in results])
        ax.bar(
            range(len(results)),
            values,
            bottom=bottom,
            color=color,
            label=f"{copy} copies",
        )
        bottom += values
    ax.set_xticks(
        range(len(results)), [row["population"] for row in results], rotation=90
    )
    ax.set(ylabel="Individual genotype frequency", ylim=(0, 1))
    ax.legend(ncol=5, loc="upper left", bbox_to_anchor=(0, 1.18), fontsize=8)
    files.figure("clps_population_copy_number", fig)

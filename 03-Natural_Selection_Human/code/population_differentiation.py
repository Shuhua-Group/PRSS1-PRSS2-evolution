"""PRSS Fst and empirical population-differentiation comparisons."""

from itertools import combinations
import numpy as np
from .common import fst, tail, plt


def run(files):
    populations = {r["population"]: r for r in files.read("fst_populations")}
    comparisons = list(combinations(["YRI", "CEU", "CHB"], 2)) + [("YRI", "CEU", "CHB")]
    observed = {}
    scores = []
    for group in comparisons:
        key = "_".join(group) + "_FST"
        n = [float(populations[p]["n_individuals"]) for p in group]
        p = [float(populations[p]["long_form_frequency"]) for p in group]
        observed[key] = fst(n, p)
        scores.append(
            dict(comparison=key, FST=observed[key], FST_float_nc=fst(n, p, False))
        )
    files.table("prss_fst", scores)
    simulation = []
    for r in files.read("fst_simulation_frequencies"):
        scores = dict(ID=r["seed"])
        for group in comparisons:
            scores["_".join(group) + "_FST"] = fst(
                [float(populations[p]["n_individuals"]) for p in group],
                [float(r[p + "_freq"]) for p in group],
            )
        simulation.append(scores)
    files.table("simulated_fst", simulation)
    empirical = []
    for name, rows in [
        ("demographic_simulations", simulation),
        ("assembly_SVs", files.read("fst_assembly_background")),
    ]:
        for key, value in observed.items():
            if key in rows[0]:
                bg = [float(r[key]) for r in rows]
                empirical.append(
                    dict(
                        background=name,
                        comparison=key,
                        observed_FST=value,
                        q95=float(np.quantile(bg, 0.95)),
                        **tail(bg, value),
                    )
                )
    files.table("fst_background_comparisons", empirical)
    fig, axes = plt.subplots(1, 2, figsize=(9, 3.6))
    for ax, key in zip(axes, ["YRI_CEU_FST", "YRI_CHB_FST"]):
        ax.hist([r[key] for r in simulation], bins=35, density=True, color="#a3bac9")
        ax.axvline(observed[key], color="#bd5d4b", label="PRSS")
        ax.set(xlabel=key, ylabel="Density")
        ax.legend()
    files.figure("population_differentiation", fig)

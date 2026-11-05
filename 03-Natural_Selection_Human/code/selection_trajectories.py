"""Plot retained CLUES frequency-trajectory summaries."""

from .common import plt


def run(files):
    trajectories = files.read("clues_trajectories")
    fig, ax = plt.subplots(figsize=(7, 3.8))
    for pop, color in [("CHB", "#bd5d4b"), ("CEU", "#286496"), ("YRI", "#888888")]:
        rows = sorted(
            [r for r in trajectories if r["population"] == pop],
            key=lambda r: float(r["years_before_present"]),
        )
        if any(
            not (0 <= float(r["lower_frequency"]) <= float(r["upper_frequency"]) <= 1)
            for r in rows
        ):
            raise ValueError("Invalid trajectory frequency bounds")
        x = [float(r["years_before_present"]) / 1000 for r in rows]
        ax.plot(x, [float(r["frequency"]) for r in rows], color=color, label=pop)
        ax.fill_between(
            x,
            [float(r["lower_frequency"]) for r in rows],
            [float(r["upper_frequency"]) for r in rows],
            color=color,
            alpha=0.16,
        )
    ax.set(
        xlim=(100, 0),
        ylim=(0, 1),
        xlabel="Thousands of years before present",
        ylabel="Short-form frequency",
    )
    ax.legend()
    files.figure("frequency_trajectories", fig)

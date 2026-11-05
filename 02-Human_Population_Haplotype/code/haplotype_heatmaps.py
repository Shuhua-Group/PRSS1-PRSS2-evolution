"""Cluster and draw retained copy-specific haplotype allele matrices."""
from pathlib import Path
import argparse
import numpy as np
import pandas as pd
from scipy.cluster.hierarchy import linkage,leaves_list
from scipy.spatial.distance import pdist
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
plt.rcParams.update({"pdf.fonttype":42,"font.family":"DejaVu Sans"})
def main():
    root=Path(__file__).resolve().parents[1];ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--data-dir",type=Path,default=root/"data");ap.add_argument("--output-dir",type=Path,default=root/"results");args=ap.parse_args();args.output_dir.mkdir(parents=True,exist_ok=True)
    sources=sorted((args.data_dir/"heatmaps").glob("*.tsv"));summary=[]
    if len(sources)!=6:raise ValueError("Expected six retained haplotype heatmaps")
    for source in sources:
        data=pd.read_csv(source,sep="\t");cluster=pd.read_csv(args.data_dir/"clustering"/source.name,sep="\t").set_index("Sample_hap")
        if not {"Sample_hap","pos","TYPE"}.issubset(data) or data.duplicated(["Sample_hap","pos"]).any() or cluster.index.duplicated().any():raise ValueError("Invalid sample/marker keys")
        positions=data.pos.drop_duplicates().tolist();matrix=data.pivot(index="Sample_hap",columns="pos",values="TYPE")
        if set(cluster.index)!=set(matrix.index) or set(cluster.columns)!=set(positions):raise ValueError("Heatmap and cluster matrices describe different samples/markers")
        expected=cluster.loc[matrix.index,matrix.columns].to_numpy(dtype=float)
        if not np.array_equal(expected,matrix.to_numpy(dtype=float)):raise ValueError("Clustering allele matrix differs from plotted allele matrix")
        values=cluster.to_numpy(dtype=float)
        if not np.isfinite(values).all() or not set(np.unique(values)).issubset({0.,1.}):raise ValueError("Expected complete binary alleles")
        order=leaves_list(linkage(pdist(values,metric="euclidean"),method="average")) if len(cluster)>1 else np.array([0])
        samples=cluster.index[order].tolist();plot=matrix.loc[samples,positions].to_numpy(dtype=float)
        fig,ax=plt.subplots(figsize=(14,max(3.5,len(samples)*.055)))
        ax.imshow(plot,aspect="auto",interpolation="nearest",cmap=ListedColormap(["#cccccc","#111111"]),vmin=0,vmax=1)
        ticks=np.unique(np.linspace(0,len(positions)-1,min(18,len(positions)),dtype=int));ax.set_xticks(ticks,[positions[i] for i in ticks],rotation=90,fontsize=7)
        if len(samples)<=10:ax.set_yticks(range(len(samples)),samples,fontsize=8)
        else:ax.set_yticks([])
        group=source.stem.split("_maf_")[0].replace("_"," ");maf="0.01" if "001" in source.stem else "0.05"
        ax.set(xlabel="Retained marker",ylabel="Copy-specific haplotype",title=f"{group}; MAF {maf}; {len(samples)} haplotypes, {len(positions)} markers")
        fig.tight_layout()
        for ext in ["pdf","png"]:fig.savefig(args.output_dir/f"haplotypes_{source.stem}.{ext}",dpi=300,bbox_inches="tight")
        plt.close(fig)
        pd.DataFrame({"rank":range(1,len(samples)+1),"Sample_hap":samples}).to_csv(args.output_dir/f"haplotypes_{source.stem}_order.tsv",sep="\t",index=False)
        summary.append({"dataset":source.stem,"haplotypes":len(samples),"markers":len(positions),"clustering":"average_linkage_euclidean"})
    pd.DataFrame(summary).to_csv(args.output_dir/"haplotype_heatmap_summary.tsv",sep="\t",index=False);print("Haplotype heatmaps:",len(summary),"matched sample/marker matrices")
if __name__=="__main__":main()

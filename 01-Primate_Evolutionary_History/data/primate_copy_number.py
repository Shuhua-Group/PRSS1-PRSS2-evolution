"""Plot retained PRSS and CLPS copy-number measurements."""
from pathlib import Path
import argparse
import numpy as np
import pandas as pd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
plt.rcParams.update({"pdf.fonttype":42,"font.family":"DejaVu Sans"})
def draw(data,ranges,value,order,title,prefix,output):
    required={"sample","species",value}
    if not required.issubset(data) or not {"species",value}.issubset(ranges):raise ValueError("Unexpected copy-number columns")
    if data["sample"].duplicated().any():raise ValueError("Duplicate sample IDs")
    if not np.isfinite(data[value].to_numpy(dtype=float)).all():raise ValueError("Nonfinite copy number")
    if set(order)!=set(data.species):raise ValueError("Unexpected copy-number group")
    if set(ranges.species)!=set(order):raise ValueError("Sample and range groups differ")
    summaries=[];rng=np.random.default_rng(2026)
    fig,ax=plt.subplots(figsize=(9, max(3.5,len(order)*.37)))
    ape_colors={"Chimpanzee":"#eee66a","Bonobo":"#7c9c5e","Bonodo":"#7c9c5e","Gorilla":"#ce4c45","Orangutan":"#535c9d"}
    for i,group in enumerate(order):
        vals=data.loc[data.species==group,value].to_numpy(dtype=float)
        supplied=sorted(ranges.loc[ranges.species==group,value].astype(float).tolist())
        if len(supplied)!=2 or not np.allclose(supplied,[vals.min(),vals.max()],rtol=0,atol=1e-10):raise ValueError("Range table inconsistent with samples: "+group)
        ax.plot([vals.min(),vals.max()],[i,i],c="black",lw=1.1,zorder=1)
        jitter=rng.uniform(-.16,.16,len(vals));ax.scatter(vals,i+jitter,s=19 if len(vals)<100 else 9,c=ape_colors.get(group,"#7196ac"),edgecolors="#333333",linewidths=.3,alpha=.85,zorder=2)
        summaries.append({"group":group,"n":len(vals),"minimum":vals.min(),"median":np.median(vals),"maximum":vals.max()})
    labels=[("Bonobo" if s=="Bonodo" else s)+f" (n={sum(data.species==s)})" for s in order]
    ax.set_yticks(range(len(order)),labels);ax.invert_yaxis();ax.set(xlabel=title+" copy number",title=title+" copy-number distribution")
    if prefix=="clps_copy_number":ax.set_xlim(1,4);ax.set_xticks([1,2,3,4])
    ax.spines[["top","right"]].set_visible(False);ax.grid(axis="x",color=".92",zorder=0);fig.tight_layout()
    for ext in ["pdf","png"]:fig.savefig(output/f"{prefix}.{ext}",dpi=300,bbox_inches="tight")
    plt.close(fig);pd.DataFrame(summaries).to_csv(output/f"{prefix}_summary.tsv",sep="\t",index=False)
def main():
    root=Path(__file__).resolve().parents[1];ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--data-dir",type=Path,default=root/"data");ap.add_argument("--output-dir",type=Path,default=root/"results");args=ap.parse_args();args.output_dir.mkdir(parents=True,exist_ok=True)
    for gene in ["prss","clps"]:
        d=pd.read_csv(args.data_dir/f"{gene}_copy_number.tsv",sep="\t");r=pd.read_csv(args.data_dir/f"{gene}_copy_number_ranges.tsv",sep="\t")
        order=["Chimpanzee","Bonodo","Gorilla","Orangutan","Archaic hominin","African","European","East Asian","South Asian","American","Middle Eastern","Siberian","Melanesian","Oceanian"] if gene=="prss" else ["Chimpanzee","Bonobo","Gorilla","Orangutan"]
        draw(d,r,gene.upper()+"_copy",order,gene.upper(),gene+"_copy_number",args.output_dir)
        print(gene.upper(),len(d),"samples",d.species.nunique(),"groups")
if __name__=="__main__":main()

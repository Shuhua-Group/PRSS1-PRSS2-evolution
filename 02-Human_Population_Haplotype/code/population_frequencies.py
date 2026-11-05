"""Draw population frequency maps from processed frequency tables."""
from pathlib import Path
import argparse,json,math
import numpy as np
import pandas as pd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon,Wedge,Patch,Circle
plt.rcParams.update({"pdf.fonttype":42,"font.family":"DejaVu Sans"})

def layout(data,radii):
    # Move display centres only; leader lines retain the original geographic sites.
    order=sorted(range(len(data)),key=lambda i:(float(data.iloc[i]["long"]),float(data.iloc[i].lat),str(data.iloc[i].Pop)))
    placed={}
    for i in order:
        x=float(data.iloc[i]["long"]);y=float(data.iloc[i].lat);candidates=[(x,y)]
        for distance in [8,16,24,32,40,48]:
            candidates.extend((x+distance*math.cos(t),y+distance*math.sin(t)) for t in np.linspace(0,2*math.pi,24,endpoint=False))
        candidates=[(a,b) for a,b in candidates if -175<a<178 and -52<b<82]
        valid=[(a,b) for a,b in candidates if all(math.hypot(a-c,b-d)>radii[i]+radii[j]+2.5 for j,(c,d) in placed.items())]
        if not valid:raise ValueError("Cannot place population pies without overlap")
        placed[i]=min(valid,key=lambda q:(q[0]-x)**2+(q[1]-y)**2)
    return placed

def draw(source,categories,colors,name,rings,output):
    count_column="Sample_hap_nu" if name=="PRSS" else "Sample_nu"
    required={"Pop","lat","long",count_column,*categories}
    if not required.issubset(source) or source.Pop.duplicated().any():raise ValueError("Unexpected frequency table keys")
    values=source[categories].to_numpy(dtype=float)
    if not np.isfinite(values).all() or (values<0).any() or (values>1).any() or not np.allclose(values.sum(axis=1),1,atol=1e-8,rtol=0):raise ValueError("Invalid frequency denominator or values")
    counts=source[count_column].to_numpy(dtype=float)
    if not np.isfinite(counts).all() or (counts<=1).any():raise ValueError("Expected sample counts greater than one")
    is_reference=source.Pop.astype(str).str.fullmatch(r"\d+sample")
    references=source.loc[is_reference].copy()
    if name=="PRSS" and set(references.Pop)!={"10sample","100sample"}:raise ValueError("Expected the two recorded PRSS size-reference rows")
    if name=="CLPS" and len(references):raise ValueError("Unexpected CLPS size-reference rows")
    data=source.loc[~is_reference].reset_index(drop=True)
    sites=data[["lat","long"]].to_numpy(dtype=float)
    if not np.isfinite(sites).all() or (np.abs(sites[:,0])>90).any() or (np.abs(sites[:,1])>180).any():raise ValueError("Invalid geographic coordinates")
    radii=2*np.log10(data[count_column].to_numpy(dtype=float))
    centres=layout(data,radii);fig,ax=plt.subplots(figsize=(16,8))
    for ring in rings:ax.add_patch(Polygon(ring,closed=True,facecolor="#e5e5e5",edgecolor="none",zorder=0))
    display=[]
    for i,row in data.iterrows():
        x,y=centres[i];radius=float(radii[i]);longitude=float(row["long"]);latitude=float(row.lat)
        if math.hypot(x-longitude,y-latitude)>.1:ax.plot([longitude,x],[latitude,y],color=".4",lw=.5,zorder=1)
        ax.plot(longitude,latitude,".",color=".3",ms=2,zorder=2)
        angle=90.
        for value,color in zip(row[categories].astype(float),colors):
            if value>0:ax.add_patch(Wedge((x,y),radius,angle,angle+360*value,facecolor=color,edgecolor="white",linewidth=.25,zorder=3))
            angle+=360*value
        ax.text(x,y+radius+1.1,str(row.Pop),ha="center",va="bottom",fontsize=7.5,zorder=4)
        display.append({**row.to_dict(),"row_type":"population","display_longitude":x,"display_latitude":y,"display_radius":radius})
    if len(references):
        for i,(_,row) in enumerate(references.iterrows()):
            count=float(row[count_column]);radius=2*math.log10(count);x=-160+25*i;y=-31
            ax.add_patch(Circle((x,y),radius,facecolor="white",edgecolor=".35",lw=.7))
            ax.text(x,y+radius+2,f"{count:g} haplotypes",ha="center",va="bottom",fontsize=8)
        ax.text(-161,-43,"Pie radius: log10(haplotype count)",ha="left",fontsize=8)
    else:ax.text(-170,-43,"Pie radius: log10(individual count)",ha="left",fontsize=8)
    ax.set(xlim=(-180,180),ylim=(-58,88),aspect="equal",title=f"{name} population frequencies ({len(data)} populations)");ax.axis("off")
    ax.legend(handles=[Patch(facecolor=c,label=k) for k,c in zip(categories,colors)],loc="lower left",ncol=min(7,len(categories)),frameon=False,fontsize=9)
    fig.tight_layout()
    for ext in ["pdf","png"]:fig.savefig(output/f"{name.lower()}_population_frequencies.{ext}",dpi=300,bbox_inches="tight")
    plt.close(fig);pd.DataFrame(display).to_csv(output/f"{name.lower()}_map_sources.tsv",sep="\t",index=False)
    if len(references):references.assign(row_type="size_reference").to_csv(output/f"{name.lower()}_map_size_references.tsv",sep="\t",index=False)
    print(name,len(data),"populations;",len(references),"size-reference rows")

def main():
    root=Path(__file__).resolve().parents[1];ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--data-dir",type=Path,default=root/"data");ap.add_argument("--output-dir",type=Path,default=root/"results");args=ap.parse_args();args.output_dir.mkdir(parents=True,exist_ok=True)
    rings=json.loads((args.data_dir/"world_outlines.json").read_text(encoding="utf-8"))["rings"]
    for name,file,categories,colors in [("PRSS","prss_haplotype_frequencies.tsv",["H1","H2","H3","H4","H5","H.R","H.O"],["#f15757","#228bd1","#41b88f","#9b6bb1","#edb85e","#f3d879","#777777"]),("CLPS","clps_copy_frequencies.tsv",["copy2","copy3","copy4","copy5","copy6"],["#b94b48","#15a6bb","#f6bb59","#ab67b5","#61b95e"])]:
        data=pd.read_csv(args.data_dir/file,sep="\t").reset_index(drop=True);draw(data,categories,colors,name,rings,args.output_dir)
if __name__=="__main__":main()

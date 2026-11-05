#coding:utf-8
#2021-1-13
#source activate vcf-kit

import os 
import gzip


###001-get KGP diff pop's sample ID and C4_geno
ref_pop_path = "/picb/humpopg-bigdata/xiebo/NGS/HGSVC2_haplotype_resolved_genome/reference/KGP_sample_list.tsv"
ref_sample_path = "/picb/humpopg-bigdata/xiebo/NGS/HGSVC2_haplotype_resolved_genome/result/Phased_assembly_variant_discovery/PanGenie_results/pangenie-genotyping.PRJEB31736.2504.sample-list.txt"

ref_tmp_sample_dt = {}
with open(ref_sample_path) as file:
    for line in file:
        val = line.strip()
        sample = val.split("_")[0]
        ref_tmp_sample_dt[sample] = ""

ref_pop_dt = {}
ref_pop_list = []
ref_sample_pop_dt = {}
ref_sample_superpop_dt = {}
line_nu = 0
with open(ref_pop_path) as file:
    for line in file:
        line_nu += 1
        if line_nu == 1:
            pass
        else:
            j = line.strip().split()
            sample = j[0]
            pop = j[3]
            superpop = j[5]
            ref_sample_pop_dt[sample] = pop
            ref_sample_superpop_dt[sample] = superpop

def get_ancestral_state():
    ref_path = '/picb/humpopg-bigdata/xiebo/NGS/reference/KGP_refGRCh38_SNV_INDEL/ALL.chr7.shapeit2_integrated_snvindels_v2a_27022019.GRCh38.chr7-142770582-A-G.phased.vcf.gz'
    with gzip.open(ref_path) as file:
        for line in file:
            val = line.strip()
            if val.count("#") == 2:
                pass
            elif val.count("#") == 1:
                j = line.strip().split()
                ref_KGP_sample_dt = {}
                ref_KGP_sample_list = j[9:]

    ref_pop_dt = {}
    ref_pop_list = []
    for sample in ref_KGP_sample_list:
        pop = ref_sample_pop_dt[sample]
        if sample in ref_tmp_sample_dt:
            if pop not in ref_pop_dt:
                ref_pop_dt[pop] = []
                ref_pop_list.append(pop)
                ref_pop_dt[pop].append(sample)
            else:
                ref_pop_dt[pop].append(sample)

    fout_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/"

    fout_path = fout_prefix + "KGP.sample.poplabels"
    fout_file = open(fout_path,"w")
    result = ("sample","population","group","sex")
    fout_file.write("\t".join(result) + "\n")
    for sample in ref_KGP_sample_list:
        pop = ref_sample_pop_dt[sample]
        superpop = ref_sample_superpop_dt[sample]
        result = (sample,pop,superpop,"NA")
        fout_file.write("\t".join(result) + "\n")
    fout_file.close()

    for pop in ref_pop_list:
        fout_path = fout_prefix + pop + ".sample.poplabels"
        fout_file = open(fout_path,"w")
        result = ("sample","population","group","sex")
        fout_file.write("\t".join(result) + "\n")
        ref_tmp_sample_list = ref_pop_dt[pop]
        for sample in ref_tmp_sample_list:
            superpop = ref_sample_superpop_dt[sample]
            result = (sample,pop,superpop,"NA")
            fout_file.write("\t".join(result) + "\n")
        fout_file.close()




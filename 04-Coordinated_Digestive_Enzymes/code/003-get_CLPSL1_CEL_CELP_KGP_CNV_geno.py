#coding: utf-8
#2022-12-15

#修改一：之前只使用了欧亚群体的拷贝数，现在把非洲群体的结果加进去。

import os
import gzip
import numpy as np
from scipy.stats import pearsonr
import multiprocessing

###001-get KGP diff pop's sample ID and C4_geno
ref_pop_path = "/picb/humpopg-bigdata/xiebo/NGS/HGSVC2_haplotype_resolved_genome/reference/KGP_sample_list.tsv"
ref_sample_path = "/picb/humpopg-bigdata/xiebo/NGS/HGSVC2_haplotype_resolved_genome/result/Phased_assembly_variant_discovery/PanGenie_results/pangenie-genotyping.PRJEB31736.2504.sample-list.txt"

ref_KGP_sample_dt = {}
ref_KGP_sample_list = []
with open(ref_sample_path) as file:
    for line in file:
        sample = line.strip().split("_")[0]
        ref_KGP_sample_list.append(sample)
        ref_KGP_sample_dt[sample] = ""

ref_pop_dt = {}
ref_pop_list = []
ref_sample_list = []
ref_sample_pop_dt = {}
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
            root_path = "/picb/humpopg-bigdata5/wangyimin/root_hg38/" + sample + ".root"
            if os.path.exists(root_path):
                if sample in ref_KGP_sample_dt:
                    ref_sample_pop_dt[sample] = pop
                    ref_sample_list.append(sample)
                    if pop not in ref_pop_dt:
                        ref_pop_dt[pop] = []
                        ref_pop_dt[pop].append(sample)
                        ref_pop_list.append(pop)
                    else:
                        ref_pop_dt[pop].append(sample)

#ref_pop_list = []
#line_nu = 0
#ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/006-AMY/amy1-amy2_CNgeno-round-popu-cor-20220630updated.txt"
#with open(ref_path) as file:
    #for line in file:
        #line_nu += 1
        #if line_nu == 1:
            #pass
        #else:
            #j = line.strip().split()
            #sample = j[0]
            #ref_pop_list.append(sample)

#ref_sample_list = []
#for pop in ref_pop_list:
    #for sample in ref_pop_dt[pop]:
        #ref_sample_list.append(sample)

###fout CNV sample geno
fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/006-AMY/KGP.sample_CLPSL1_CEL_CELP_CNV_geno.txt"
fout_file = open(fout_path,"w")
result = ["CNV_region"] + ref_sample_list
fout_file.write("\t".join(result) + "\n")
ref_pop_CNV_dt = {}
ref_pop_CNV_copy_dt = {}
ref_CNV_sample_geno_dt = {}
for pop in ref_pop_list:
    ref_CNV_region_list = []
    ref_pop_CNV_dt[pop] = {}
    ref_pop_CNV_copy_dt[pop] = {}
    ref_tmp_sample_list = ref_pop_dt[pop]
    for sample in ref_tmp_sample_list:
        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/006-AMY/KGP_phase1_CNV/" + sample + ".KGP_phase1_CNV.txt"
        with open(ref_path) as file:
            for line in file:
                j = line.strip().split()
                CNV = j[1]
                geno = float(j[-2])
                if CNV not in ref_CNV_sample_geno_dt:
                    ref_CNV_sample_geno_dt[CNV] = {}
                    ref_CNV_sample_geno_dt[CNV][sample] = str(geno)
                else:
                    ref_CNV_sample_geno_dt[CNV][sample] = str(geno)

                if CNV not in ref_pop_CNV_dt[pop]:
                    ref_pop_CNV_dt[pop][CNV] = []
                    ref_pop_CNV_dt[pop][CNV].append(geno)
                else:
                    ref_pop_CNV_dt[pop][CNV].append(geno)
                
        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/006-AMY/KGP_phase1_CNV/" + sample + ".CLPS_Extend_CNV.txt"
        with open(ref_path) as file:
            for line in file:
                j = line.strip().split()
                CNV = j[1]
                geno = float(j[-2])
                if CNV not in ref_CNV_sample_geno_dt:
                    ref_CNV_sample_geno_dt[CNV] = {}
                    ref_CNV_sample_geno_dt[CNV][sample] = str(geno)
                else:
                    ref_CNV_sample_geno_dt[CNV][sample] = str(geno)
                if CNV not in ref_pop_CNV_dt[pop]:
                    ref_pop_CNV_dt[pop][CNV] = []
                    ref_pop_CNV_dt[pop][CNV].append(geno)
                else:
                    ref_pop_CNV_dt[pop][CNV].append(geno)

ref_CNV_list = ["chr6:35781265-35799376","chr6:35786859-35798675","chr9:133065676-133080813","chr9:133071235-133081235"]
for CNV in ref_CNV_list:
    result = [CNV]
    for sample in ref_sample_list:
        result.append(ref_CNV_sample_geno_dt[CNV][sample])
    fout_file.write("\t".join(result) + "\n")
fout_file.close()


###################################
###fout CLPS for worldmap
###################################
ref_sample_CLPS_CNV_dt = {}
ref_CLPS_CNV_class_dt = {}
ref_tmp_CLPS_CNV_class_list = []
for sample in ref_sample_list:
    CNV = "chr6:35786859-35798675"
    CNV_geno = str(int(float(ref_CNV_sample_geno_dt[CNV][sample]) + 0.5))
    ref_sample_CLPS_CNV_dt[sample] = CNV_geno
    if CNV_geno not in ref_CLPS_CNV_class_dt:
        ref_CLPS_CNV_class_dt[CNV_geno] = 1
        ref_tmp_CLPS_CNV_class_list.append(int(CNV_geno))
    else:
        ref_CLPS_CNV_class_dt[CNV_geno] += 1

ref_tmp_CLPS_CNV_class_list = sorted(ref_tmp_CLPS_CNV_class_list)
ref_CLPS_CNV_class_list = []
for CLPS in ref_tmp_CLPS_CNV_class_list:
    ref_CLPS_CNV_class_list.append(str(CLPS))

print(ref_CLPS_CNV_class_list)
fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/006-AMY/KGP.pop_CLPS.CNV_freq.txt"
fout_file = open(fout_path,"w")
result = ["pop","sample_nu"] + ref_CLPS_CNV_class_list
fout_file.write("\t".join(result) + "\n")

for pop in ref_pop_list:
    CNV = "chr6:35786859-35798675"
    tmp_copy_list = []
    for CNV_geno in ref_pop_CNV_dt[pop][CNV]:
        tmp_copy_list.append(str(int(float(CNV_geno) + 0.5)))
    result = [pop,str(len(tmp_copy_list))]
    for CNV_class in ref_CLPS_CNV_class_list:
        freq = float(tmp_copy_list.count(CNV_class))/len(tmp_copy_list)
        result.append(str(freq))
    fout_file.write("\t".join(result) + "\n")
fout_file.close()


###################################
###fout CEL for worldmap
###################################
ref_sample_CLPS_CNV_dt = {}
ref_CLPS_CNV_class_dt = {}
ref_tmp_CLPS_CNV_class_list = []
for sample in ref_sample_list:
    CNV = "chr9:133065676-133080813"
    CNV_geno = str(int(float(ref_CNV_sample_geno_dt[CNV][sample]) + 0.5))
    ref_sample_CLPS_CNV_dt[sample] = CNV_geno
    if CNV_geno not in ref_CLPS_CNV_class_dt:
        ref_CLPS_CNV_class_dt[CNV_geno] = 1
        ref_tmp_CLPS_CNV_class_list.append(int(CNV_geno))
    else:
        ref_CLPS_CNV_class_dt[CNV_geno] += 1

ref_tmp_CLPS_CNV_class_list = sorted(ref_tmp_CLPS_CNV_class_list)
ref_CLPS_CNV_class_list = []
for CLPS in ref_tmp_CLPS_CNV_class_list:
    ref_CLPS_CNV_class_list.append(str(CLPS))

print(ref_CLPS_CNV_class_list)
fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/006-AMY/KGP.pop_CEL.CNV_freq.txt"
fout_file = open(fout_path,"w")
result = ["pop","sample_nu"] + ref_CLPS_CNV_class_list
fout_file.write("\t".join(result) + "\n")

for pop in ref_pop_list:
    CNV = "chr9:133065676-133080813"
    tmp_copy_list = []
    for CNV_geno in ref_pop_CNV_dt[pop][CNV]:
        tmp_copy_list.append(str(int(float(CNV_geno) + 0.5)))
    result = [pop,str(len(tmp_copy_list))]
    for CNV_class in ref_CLPS_CNV_class_list:
        freq = float(tmp_copy_list.count(CNV_class))/len(tmp_copy_list)
        result.append(str(freq))
    fout_file.write("\t".join(result) + "\n")
fout_file.close()


###################################
###fout CNV pop geno (CLPS,CEL, CELP)
###################################
for CNV in ref_CNV_list:
    tmp_copy_list = ref_pop_CNV_dt[pop][CNV]
    mean_copy = np.mean(tmp_copy_list)
    ref_pop_CNV_copy_dt[pop][CNV] = mean_copy

fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/006-AMY/KGP.pop_CLPSL1_CEL_CELP_CNV_geno.txt"
fout_file = open(fout_path,"w")
result = ["CNV_region"] + ref_pop_list
fout_file.write("\t".join(result) + "\n")

for CNV in ref_CNV_list:
    result = [CNV]
    for pop in ref_pop_list:
        tmp_copy_list = ref_pop_CNV_dt[pop][CNV]
        mean_copy = np.mean(tmp_copy_list)
        result.append(str(mean_copy))
    fout_file.write("\t".join(result) + "\n")
fout_file.close()
















#coding: utf-8
#2022-12-15

import os
import gzip
import numpy as np
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
            if sample in ref_KGP_sample_dt:
                ref_sample_pop_dt[sample] = pop
                if pop not in ref_pop_dt:
                    ref_pop_dt[pop] = []
                    ref_pop_dt[pop].append(sample)
                    ref_pop_list.append(pop)
                else:
                    ref_pop_dt[pop].append(sample)


###prepare CNVnator input 
fout_line_list = []
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/006-AMY/1000G_phase1_cnv_genotypes_unphased_25Jul2014.CNV.hg38.bed"
with open(ref_path) as file:
    for line in file:
        j = line.strip().split()
        chr = j[0]
        start = j[1]
        end = j[2]
        line = chr + ":" + start + "-" + end + "\n"
        fout_line_list.append(line)

fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/006-AMY/1000G_phase1_cnv_genotypes_unphased_25Jul2014.CNV.hg38.CNVnator_input.txt"
fout_file = open(fout_path,"w")
for line in fout_line_list:
    fout_file.write(line)
fout_file.write("exit" + "\n")
fout_file.write("EOF" + "\n")
fout_file.close()

###run CNVnator
def run_CNVnator(sample):
    print(sample)
    ref_CNV_list = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/006-AMY/1000G_phase1_cnv_genotypes_unphased_25Jul2014.CNV.hg38.CNVnator_input.txt"
    root_path = "/picb/humpopg-bigdata5/wangyimin/root_hg38/" + sample + ".root"
    fout_sample_genotype_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/006-AMY/KGP_phase1_CNV/" + sample + ".KGP_phase1_CNV.txt"
    if os.path.exists(root_path):
        os.system("cnvnator -root %s -genotype 100 <%s >%s 2>/dev/null" %(root_path,ref_CNV_list,fout_sample_genotype_path))

def run_CLPS_CNVnator(sample):
    print(sample)
    ref_CNV_list = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/006-AMY/CLPS.hg38.CNVnator_input.txt"
    root_path = "/picb/humpopg-bigdata5/wangyimin/root_hg38/" + sample + ".root"
    fout_sample_genotype_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/006-AMY/KGP_phase1_CNV/" + sample + ".CLPS_CNV.txt"
    if os.path.exists(root_path):
        os.system("cnvnator -root %s -genotype 100 <%s >%s 2>/dev/null" %(root_path,ref_CNV_list,fout_sample_genotype_path))

def run_CLPS_Extend_CNVnator(sample):
    print(sample)
    ref_CNV_list = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/006-AMY/CLPS.Extend.GRCh38.CNVnator_input.txt"
    root_path = "/picb/humpopg-bigdata5/wangyimin/root_hg38/" + sample + ".root"
    fout_sample_genotype_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/006-AMY/KGP_phase1_CNV/" + sample + ".CLPS_Extend_CNV.txt"
    if os.path.exists(root_path):
        os.system("cnvnator -root %s -genotype 100 <%s >%s 2>/dev/null" %(root_path,ref_CNV_list,fout_sample_genotype_path))

def run_CLPS_CEL_CNVnator(sample):
    print(sample)
    ref_CNV_list = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/006-AMY/CLPS_CEL.GRCh38.CNVnator_input.txt"
    root_path = "/picb/humpopg-bigdata5/wangyimin/root_hg38/" + sample + ".root"
    fout_sample_genotype_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/006-AMY/KGP_phase1_CNV/" + sample + ".CLPS_CEL.txt"
    if os.path.exists(root_path):
        os.system("cnvnator -root %s -genotype 100 <%s >%s 2>/dev/null" %(root_path,ref_CNV_list,fout_sample_genotype_path))

ref_sample_list = []
for pop in ref_pop_list:
    for sample in ref_pop_dt[pop]:
        ref_sample_list.append(sample)

def get_KGP_CNV():
    ref_rerun_sample_list = []
    for sample in ref_sample_list:
        root_path = "/picb/humpopg-bigdata5/wangyimin/root_hg38/" + sample + ".root"
        fout_sample_genotype_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/006-AMY/KGP_phase1_CNV/" + sample + ".KGP_phase1_CNV.txt"
        if os.path.exists(root_path):
            if os.path.exists(fout_sample_genotype_path):
                line_nu = 0
                with open(fout_sample_genotype_path) as file:
                    for line in file:
                        line_nu += 1
                if line_nu != 8424:
                    ref_rerun_sample_list.append(sample)
            else:
                ref_rerun_sample_list.append(sample)

    print("KGP_rerun_sample_nu = " + str(len(ref_rerun_sample_list)))

    pool = multiprocessing.Pool(processes=20)
    pool.map(run_CNVnator,ref_rerun_sample_list)
    pool.close()
    pool.join()
    
#get_KGP_CNV()

#pool = multiprocessing.Pool(processes=20)
#pool.map(run_CLPS_CNVnator,ref_sample_list)
#pool.close()
#pool.join()

#pool = multiprocessing.Pool(processes=20)
#pool.map(run_CLPS_Extend_CNVnator,ref_sample_list)
#pool.close()
#pool.join()

pool = multiprocessing.Pool(processes=20)
pool.map(run_CLPS_CEL_CNVnator,ref_sample_list)
pool.close()
pool.join()
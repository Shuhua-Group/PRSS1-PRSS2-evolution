#coding:utf-8
#2023-4-26
#注意：该版本的使用了基因区间的突变
#建议在svr2上运行

import os 
import gzip

ref_pop_dt = {}
ref_pop_list = []
ref_sample_dt = {}
ref_sample_list = []
ref_sample_pop_dt = {}
line_nu = 0
ref_path = "/picb/humpopg-bigdata5/xiebo/SV_calling/result/Paragraph_test/reference/HGDP_SGDP/inxdepth/KGP_HGDP.sample_depth.txt"
with open(ref_path) as file:
    for line in file:
        line_nu += 1
        if line_nu == 1:
            pass
        else:
            j = line.strip().split()
            sample = j[0]
            pop = j[1]
            ref_sample_list.append(sample)
            ref_sample_dt[sample] = pop
            if pop not in ref_pop_dt:
                ref_pop_dt[pop] = []
                ref_pop_dt[pop].append(sample)
                ref_pop_list.append(pop)
            else:
                ref_pop_dt[pop].append(sample)

ref_pop_list = ['YRI', 'MSL', 'FIN', 'CEU', 'TSI', 'BEB', 'CHB','JPT', 'CHS', 'CDX', 'KHV', 'GIH', 'PJL', 'STU', 'MXL']
ref_CLPS_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/024-CLPS_CEL_TajimaD/reference/002-vcf/KGP.GRCh38.PASS.snps.biallelic.shapeit4.chr6.CLPS_extend_25Kb.ancestor.beta.gt.vcf.gz"
ref_CEL_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/024-CLPS_CEL_TajimaD/reference/002-vcf/KGP.GRCh38.PASS.snps.biallelic.shapeit4.chr9.CEL_extend_25Kb.ancestor.beta.gt.vcf.gz"
ref_CLPS_bed_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/024-CLPS_CEL_TajimaD/reference/003-target_region/CLPS_target_region.beta.bed"
ref_CEL_bed_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/024-CLPS_CEL_TajimaD/reference/003-target_region/CEL_target_region.beta.bed"

def cal_CLPS_TajimaD(pop,gene_copy):
    print(pop + "--CLPS-" + gene_copy)
    Theta_D_H = "/picb/humpopg-bigdata5/xiebo/software/Theta_D_H.Est/Theta_D_H.Est"
    ref_sample_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/024-CLPS_CEL_TajimaD/reference/001-pop/" + pop + ".txt"
    ref_hap_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/024-CLPS_CEL_TajimaD/reference/001-pop/000-hap_file/" + pop + ".CLPS." + gene_copy + ".hap.beta.txt"
    output = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/024-CLPS_CEL_TajimaD/results/001-Theta_D_F_H/" + pop + ".CLPS." + gene_copy + ".Theta_D_F_H.beta.txt"
    os.system("%s --gzvcf %s --region %s --samples %s --haps %s --outgroup Y --out %s" %(Theta_D_H,ref_CLPS_path,ref_CLPS_bed_path,ref_sample_path,ref_hap_path,output))

def cal_CEL_TajimaD(pop,gene_copy):
    print(pop + "--CEL-" + gene_copy)
    Theta_D_H = "/picb/humpopg-bigdata5/xiebo/software/Theta_D_H.Est/Theta_D_H.Est"
    ref_sample_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/024-CLPS_CEL_TajimaD/reference/001-pop/" + pop + ".txt"
    ref_hap_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/024-CLPS_CEL_TajimaD/reference/001-pop/000-hap_file/" + pop + ".CEL." + gene_copy + ".hap.beta.txt"
    output = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/024-CLPS_CEL_TajimaD/results/001-Theta_D_F_H/" + pop + ".CEL." + gene_copy + ".Theta_D_F_H.beta.txt"
    os.system("%s --gzvcf %s --region %s --samples %s --haps %s --outgroup Y --out %s" %(Theta_D_H,ref_CEL_path,ref_CEL_bed_path,ref_sample_path,ref_hap_path,output))


###CLPS
ref_pop_CLPS_copy_list = []
for pop in ref_pop_list:
    ref_CLPS_copy_class_list = ["REF","DUP","DUP2"]
    for CLPS_copy in ref_CLPS_copy_class_list:
        tmp_hap_nu = 0
        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/024-CLPS_CEL_TajimaD/reference/001-pop/000-hap_file/" + pop + ".CLPS." + CLPS_copy + ".hap.beta.txt"
        if os.path.exists(ref_path):
            with open(ref_path) as file:
                for line in file:
                    tmp_hap_nu += 1
            if tmp_hap_nu >= 10:
                pop_gene_copy = pop + "-" + CLPS_copy
                ref_pop_CLPS_copy_list.append(pop_gene_copy)
                cal_CLPS_TajimaD(pop,CLPS_copy)

###CEL
ref_pop_CEL_copy_list = []
for pop in ref_pop_list:
    ref_CEL_copy_class_list = ["REF","DEL","DUP","DUP2"]
    for CEL_copy in ref_CEL_copy_class_list:
        tmp_hap_nu = 0
        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/024-CLPS_CEL_TajimaD/reference/001-pop/000-hap_file/" + pop + ".CEL." + CEL_copy + ".hap.beta.txt"
        if os.path.exists(ref_path):
            with open(ref_path) as file:
                for line in file:
                    tmp_hap_nu += 1
            if tmp_hap_nu >= 10:
                pop_gene_copy = pop + "-" + CEL_copy
                ref_pop_CEL_copy_list.append(pop_gene_copy)
                cal_CEL_TajimaD(pop,CEL_copy)

###fout result
def fout_Theta_D_H_results():
    ref_pop_CLPS_copy_Hfaywu_dt = {}
    for pop_gene_copy in ref_pop_CLPS_copy_list:
        pop = pop_gene_copy.split("-")[0]
        gene_copy = pop_gene_copy.split("-")[1]
        line_nu = 0
        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/024-CLPS_CEL_TajimaD/results/001-Theta_D_F_H/" + pop + ".CLPS." + gene_copy + ".Theta_D_F_H.beta.txt.gz"
        with gzip.open(ref_path) as file:
            for line in file:
                line_nu += 1
                j = line.strip().split()
                if line_nu == 1:
                    for nu in range(len(j)):
                        if j[nu] == "Hfaywu":
                            Hfaywu_index = nu
                    fout_header_list = j[4:]
                else:
                    j = line.strip().split()
                    ref_pop_CLPS_copy_Hfaywu_dt[pop_gene_copy] = j[4:]

    ref_pop_CEL_copy_Hfaywu_dt = {}
    for pop_gene_copy in ref_pop_CEL_copy_list:
        pop = pop_gene_copy.split("-")[0]
        gene_copy = pop_gene_copy.split("-")[1]
        line_nu = 0
        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/024-CLPS_CEL_TajimaD/results/001-Theta_D_F_H/" + pop + ".CEL." + gene_copy + ".Theta_D_F_H.beta.txt.gz"
        with gzip.open(ref_path) as file:
            for line in file:
                line_nu += 1
                j = line.strip().split()
                if line_nu == 1:
                    for nu in range(len(j)):
                        if j[nu] == "Hfaywu":
                            Hfaywu_index = nu
                    fout_header_list = j[4:]
                else:
                    j = line.strip().split()
                    ref_pop_CEL_copy_Hfaywu_dt[pop_gene_copy] = j[4:]

    fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/024-CLPS_CEL_TajimaD/results/001-Theta_D_F_H/KGP.CLPS_CEL.Theta_D_F_H.beta.txt"
    fout_file = open(fout_path,"w")
    result = ["Pop","Gene_hap"] + fout_header_list
    fout_file.write("\t".join(result) + "\n")

    for pop_gene_copy in ref_pop_CLPS_copy_list:
        pop = pop_gene_copy.split("-")[0]
        gene_copy = pop_gene_copy.split("-")[1]
        result = [pop,"CLPS-"+gene_copy] + ref_pop_CLPS_copy_Hfaywu_dt[pop_gene_copy]
        fout_file.write("\t".join(result) + "\n")

    for pop_gene_copy in ref_pop_CEL_copy_list:
        pop = pop_gene_copy.split("-")[0]
        gene_copy = pop_gene_copy.split("-")[1]
        result = [pop,"CEL-"+ gene_copy] + ref_pop_CEL_copy_Hfaywu_dt[pop_gene_copy]
        fout_file.write("\t".join(result) + "\n")

    fout_file.close()

fout_Theta_D_H_results()

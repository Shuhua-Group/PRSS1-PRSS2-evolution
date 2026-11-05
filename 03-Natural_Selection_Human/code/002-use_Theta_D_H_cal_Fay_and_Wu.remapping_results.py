#coding:utf-8
#2022-2-17

import os 
import gzip

fout_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/"

###001-get KGP diff pop's sample ID and C4_geno
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
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/002-vcf/2023samp_remap_MQ50.PRSS1_PRSS3P1_PRSS2.refGRCh38.ancestor.BiAllele.phased.vcf.gz"
ref_bed_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/003-target_region/PRSS_target_region.bed"

def cal_PRSS_copy3(pop):
    print(pop + "--3-copy-PRSS")
    Theta_D_H = "/picb/humpopg-bigdata5/xiebo/software/Theta_D_H.Est/Theta_D_H.Est"
    ref_sample_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/" + pop + ".txt"
    ref_hap_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/" + pop +  ".PRSS_copy3.hap.txt"
    output = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/" + pop + ".PRSS_copy3.Theta_D_F_H.txt"
    os.system("%s --gzvcf %s --region %s --samples %s --haps %s --outgroup Y --out %s" %(Theta_D_H,ref_path,ref_bed_path,ref_sample_path,ref_hap_path,output))

def cal_PRSS_copy5(pop):
    print(pop + "--5-copy-PRSS")
    Theta_D_H = "/picb/humpopg-bigdata5/xiebo/software/Theta_D_H.Est/Theta_D_H.Est"
    ref_sample_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/" + pop + ".txt"
    ref_hap_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/" + pop +  ".PRSS_copy5.hap.txt"
    output = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/" + pop + ".PRSS_copy5.Theta_D_F_H.txt"
    os.system("%s --gzvcf %s --region %s --samples %s --haps %s --outgroup Y --out %s" %(Theta_D_H,ref_path,ref_bed_path,ref_sample_path,ref_hap_path,output))


for pop in ref_pop_list:
    cal_PRSS_copy3(pop)
    cal_PRSS_copy5(pop)


def fout_Fay_and_WU_results():
    ref_PRSS_copy_list = ["PRSS1_copy3","PRSS3P1_copy3","PRSS2_copy3","PRSS1_copy5","PRSS3P1_copy5","PRSS2_copy5"]
    ref_pop_PRSS_copy_Hfaywu_dt = {}
    for pop in ref_pop_list:
        ref_pop_PRSS_copy_Hfaywu_dt[pop] = {}
        line_nu = 0
        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/" + pop + ".PRSS_copy3.Theta_D_F_H.txt.gz"
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
                    Hfaywu = j[Hfaywu_index]
                    PRSS_copy = j[0] + "_copy3"
                    ref_pop_PRSS_copy_Hfaywu_dt[pop][PRSS_copy] = j[4:]

        line_nu = 0
        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/" + pop + ".PRSS_copy5.Theta_D_F_H.txt.gz"
        with gzip.open(ref_path) as file:
            for line in file:
                line_nu += 1
                j = line.strip().split()
                if line_nu == 1:
                    for nu in range(len(j)):
                        if j[nu] == "Hfaywu":
                            Hfaywu_index = nu
                else:
                    j = line.strip().split()
                    Hfaywu = j[Hfaywu_index]
                    PRSS_copy = j[0] + "_copy5"
                    ref_pop_PRSS_copy_Hfaywu_dt[pop][PRSS_copy] = j[4:]
    fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/KGP.PRSS.Theta_D_F_H.remapping.txt"
    fout_file = open(fout_path,"w")
    result = ["Pop","PRSS_copy"] + fout_header_list
    fout_file.write("\t".join(result) + "\n")

    for PRSS_copy in ref_PRSS_copy_list:
        for pop in ref_pop_list:
            result = [pop,PRSS_copy] + ref_pop_PRSS_copy_Hfaywu_dt[pop][PRSS_copy]
            fout_file.write("\t".join(result) + "\n")
    fout_file.close()

fout_Fay_and_WU_results()

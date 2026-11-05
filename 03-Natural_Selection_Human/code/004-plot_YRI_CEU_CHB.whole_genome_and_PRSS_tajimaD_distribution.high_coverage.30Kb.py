#coding:utf-8
#2022-2-7
#修改一：现在支持对PRSS1_PRSS3P1_PRSS2区域计算Theta_D_H

import os


###001-get whole genome TajimaD
ref_pop_list = ["YRI", "CEU", "CHB"]
ref_pop_dt = {"YRI":"AFR","CEU":"EUR","CHB":"EAS"}
for pop in ref_pop_list:
    print(pop  + " = " + str(ref_pop_dt[pop]))
ref_pop_Ffuli_dt = {}
ref_pop_Dfuli_dt = {}
ref_pop_Hfaywu_dt = {}
ref_pop_tajimad_dt = {}
ref_pop_norm_Hfaywu_dt = {}
for pop in ref_pop_list:
    ref_pop_Ffuli_dt[pop] = []
    ref_pop_Dfuli_dt[pop] = []
    ref_pop_Hfaywu_dt[pop] = []
    ref_pop_tajimad_dt[pop] = []
    ref_pop_norm_Hfaywu_dt[pop] = []

line_nu = 0
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/KGP.GRCh38_chr7.Theta_D_F_H.beta.txt"
with open(ref_path) as file:
    for line in file:
        line_nu += 1
        if line_nu == 1:
            pass
        else:
            j = line.strip().split()
            pop = j[0]
            segregating = j[1]
            Hfaywu = j[2]
            norm_Hfaywu = j[3]
            Ffuli = j[4]
            Dfuli = j[5]
            Dtajima = j[6]
            if pop in ref_pop_dt:
                ref_pop_Hfaywu_dt[pop].append(Hfaywu)
                ref_pop_norm_Hfaywu_dt[pop].append(norm_Hfaywu)
                ref_pop_Ffuli_dt[pop].append(Ffuli)
                ref_pop_Dfuli_dt[pop].append(Dfuli)
                ref_pop_tajimad_dt[pop].append(Dtajima)

def prepare_sign_value(ref_sele_list):
    tmp_sele_list = []
    for sele in ref_sele_list:
        tmp_sele_list.append(float(sele))
    tmp_sorted_sele_list = sorted(tmp_sele_list)
    small_sign_nu = int(len(tmp_sorted_sele_list)*0.05)
    large_sign_nu = int(len(tmp_sorted_sele_list)*0.95)
    small_sign_sele = float(tmp_sorted_sele_list[small_sign_nu])
    large_sign_sele = float(tmp_sorted_sele_list[large_sign_nu])
    result = [small_sign_sele,large_sign_sele]
    return(result)

ref_pop_sign_Ffuli_dt = {}
ref_pop_sign_Dfuli_dt = {}
ref_pop_sign_Hfaywu_dt = {}
ref_pop_sign_tajimad_dt = {}
ref_pop_sign_norm_Hfaywu_dt = {}
for pop in ref_pop_list:
    ref_sele_list = ref_pop_Ffuli_dt[pop]
    ref_pop_sign_Ffuli_dt[pop] = prepare_sign_value(ref_sele_list)

    ref_sele_list = ref_pop_Dfuli_dt[pop]
    ref_pop_sign_Dfuli_dt[pop] = prepare_sign_value(ref_sele_list)

    ref_sele_list = ref_pop_Hfaywu_dt[pop]
    ref_pop_sign_Hfaywu_dt[pop] = prepare_sign_value(ref_sele_list)

    ref_sele_list = ref_pop_tajimad_dt[pop]
    ref_pop_sign_tajimad_dt[pop] = prepare_sign_value(ref_sele_list)
    tajimaD_small_sign_nu = ref_pop_sign_tajimad_dt[pop][0]
    print(pop + "-tajimaD_small_sign_nu=" + str(tajimaD_small_sign_nu))

    ref_sele_list = ref_pop_norm_Hfaywu_dt[pop]
    ref_pop_sign_norm_Hfaywu_dt[pop] = prepare_sign_value(ref_sele_list)


fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/YRI_CEU_CHB.whole_genome_Theta_D_F_H.chr7.Bin_30Kb.high_coverage.beta.txt"
fout_file = open(fout_path,"w")
result = ("pop","Continent","PRSS","Dtajima")
fout_file.write("\t".join(result) + "\n")
for pop in ref_pop_list:
    continent = ref_pop_dt[pop]
    PRSS = "PRSS1_PRSS3P1_PRSS2" 
    for nu in range(len(ref_pop_Ffuli_dt[pop])):
        Ffuli = ref_pop_Dfuli_dt[pop][nu]
        Dfuli = ref_pop_Dfuli_dt[pop][nu]
        Hfaywu = ref_pop_Hfaywu_dt[pop][nu]
        tajimad = ref_pop_tajimad_dt[pop][nu]
        norm_Hfaywu = ref_pop_norm_Hfaywu_dt[pop][nu]
        result = [pop,continent,PRSS,tajimad]
        fout_file.write("\t".join(result) + "\n")
fout_file.close()

###001-get PRSS copy TajimaD
def compare_sele(sele,sign_sele):
    small_sign_sele = sign_sele[0]
    large_sign_sele = sign_sele[1]
    if float(sele) <= small_sign_sele:
        sele_linetype = "solid"
    elif float(sele) >= large_sign_sele:
        sele_linetype = "solid"
    else:   
        sele_linetype = "dashed"
    return(sele_linetype)

def get_result(pop,ref_list):
    Hfaywu = ref_list[0]
    norm_Hfaywu = ref_list[1]
    Ffuli = ref_list[2]
    Dfuli = ref_list[3]
    Dtajima = ref_list[4]
    sign_Hfaywu = ref_pop_sign_Hfaywu_dt[pop]
    sign_norm_Hfaywu = ref_pop_sign_norm_Hfaywu_dt[pop]
    sign_Ffuli = ref_pop_sign_Ffuli_dt[pop]
    sign_Dfuli = ref_pop_sign_Dfuli_dt[pop]
    sign_Dtajima = ref_pop_sign_tajimad_dt[pop]

    Hfaywu_linetype = compare_sele(Hfaywu,sign_Hfaywu)
    norm_Hfaywu_linetype = compare_sele(norm_Hfaywu,sign_norm_Hfaywu)
    Ffuli_linetype = compare_sele(Ffuli,sign_Ffuli)
    Dfuli_linetype = compare_sele(Dfuli,sign_Dfuli)
    Dtajima_linetype = compare_sele(Dtajima,sign_Dtajima)
    result = (Dtajima,Dtajima_linetype)
    return(result)

def run():
    ref_PRSS_copy_Theta_D_F_H_dt = {}
    for pop in ref_pop_list:
        ref_PRSS_copy_Theta_D_F_H_dt[pop] = {}
    line_nu = 0
    ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/KGP.PRSS.Theta_D_F_H.remapping.beta.txt"
    with open(ref_path) as file:
        for line in file:
            line_nu += 1
            j = line.strip().split()
            if line_nu == 1:
                for nu in range(len(j)):
                    if j[nu] == "Hfaywu":
                        Hfaywu_index = nu
                    if j[nu] == "norm_Hfaywu":
                        norm_Hfaywu_index = nu
                    if j[nu] == "Ffuli":
                        Ffuli_index = nu
                    if j[nu] == "Dfuli":
                        Dfuli_index = nu
                    if j[nu] == "Dtajima":
                        Dtajima_inex = nu
            else:
                pop = j[0]
                PRSS_copy = j[1]
                Hfaywu = j[Hfaywu_index]
                norm_Hfaywu = j[norm_Hfaywu_index]
                Ffuli = j[Ffuli_index]
                Dfuli = j[Dfuli_index]
                Dtajima = j[Dtajima_inex]
                result = [Hfaywu,norm_Hfaywu,Ffuli,Dfuli,Dtajima]
                if pop in ref_pop_dt:
                    ref_PRSS_copy_Theta_D_F_H_dt[pop][PRSS_copy] = result

    fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/YRI_CEU_CHB.PRSS_3copy_Theta_D_F_H.PRSS_split.high_coverage.bin_30Kb.beta.txt"
    fout_file = open(fout_path,"w")
    result = ("pop","continent","PRSS","Dtajima","Dtajima_LineType")
    fout_file.write("\t".join(result) + "\n")
    for pop in ref_pop_list:
        continent = ref_pop_dt[pop]
        PRSS = "PRSS1_PRSS3P1_PRSS2" 
        result = [pop,continent,PRSS]
        PRSS_copy = PRSS + "_copy3"
        ref_list = ref_PRSS_copy_Theta_D_F_H_dt[pop][PRSS_copy]
        result += get_result(pop,ref_list)
        fout_file.write("\t".join(result) + "\n")
    fout_file.close()

    fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/YRI_CEU_CHB.PRSS_5copy_Theta_D_F_H.PRSS_split.high_coverage.bin_30Kb.beta.txt"
    fout_file = open(fout_path,"w")
    result = ("pop","continent","PRSS","Dtajima","Dtajima_LineType")
    fout_file.write("\t".join(result) + "\n")
    for pop in ref_pop_list:
        continent = ref_pop_dt[pop]
        PRSS = "PRSS1_PRSS3P1_PRSS2" 
        result = [pop,continent,PRSS]
        PRSS_copy = PRSS + "_copy5"
        ref_list = ref_PRSS_copy_Theta_D_F_H_dt[pop][PRSS_copy]
        result += get_result(pop,ref_list)
        fout_file.write("\t".join(result) + "\n")
    fout_file.close()

run()
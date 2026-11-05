#coding:utf-8
#2022-4-14

import os


def cal_Fst(nu_1,DEL_frq_1,nu_2,DEL_frq_2):
    if (DEL_frq_1 == 0) and (DEL_frq_2 == 0):
        Fst = "0"
    else:
        nu = nu_1 + nu_2
        if (nu - 2) <= 0:
            Fst = "0"
        else:
            nc = (2*nu_1*nu_2)/(nu_1 + nu_2)
            MSG = (nu_1*DEL_frq_1*(1-DEL_frq_1) + nu_2*DEL_frq_2*(1-DEL_frq_2))/(nu_1+nu_2-2)
            DEL_frq_hat = (nu_1*DEL_frq_1 + nu_2*DEL_frq_2)/(nu_1 + nu_2) 
            MSP = nu_1*((DEL_frq_1 - DEL_frq_hat)**2)+ nu_2*((DEL_frq_2 - DEL_frq_hat)**2)
            #print("MSG=" + str(MSG))
            #print("MSP=" + str(MSP))
            if (MSP+(nc-1)*MSG) == 0:
                Fst = "0"
            elif (MSP+(nc-1)*MSG) != 0:
                Fst=(MSP-MSG)/(MSP+(nc-1)*MSG)
                #print("Fst=" + str(Fst))
                if Fst <= 0:
                    Fst = "0"
                elif Fst > 0:
                    Fst = str(Fst)
    return(Fst)

def cal_Fst_3pop(n1,p1,n2,p2,n3,p3):
    if (p1 + p2 + p3 == 0):
        Fst = "0"
    else:
        nu = n1 + n2 + n3
        if (nu - 3) <= 0:
            Fst = "0"
        else:
            r=3
            aver_freq=float(n1*p1+n2*p2+n3*p3)/(n1+n2+n3)
            nc=float((n1+n2+n3)-(float(n1**2+n2**2+n3**2)/(n1+n2+n3)))/(r-1)
            MSG=(n1*p1*(1-p1)+n2*p2*(1-p2)+n3*p3*(1-p3))/(n1-1+n2-1+n3-1)
            MSP=float(n1*((p1-aver_freq)**2)+n2*((p2-aver_freq)**2)+n3*((p3-aver_freq)**2))/(r-1)
            if (MSP+(nc-1)*MSG) == 0:
                Fst = "0"
            elif (MSP+(nc-1)*MSG) != 0:
                Fst=(MSP-MSG)/(MSP+(nc-1)*MSG)
                if Fst <= 0:
                    Fst = "0"
                elif Fst > 0:
                    Fst = str(Fst)
    return(Fst)
###001-PRSS_FST
YRI_nu = 108
CEU_nu = 99
CHB_nu = 103
YRI_freq = 0.847222222222
CEU_freq = 0.580808080808
CHB_freq = 0.266990291262
PRSS_YRI_CEU_FST = cal_Fst(YRI_nu,YRI_freq,CEU_nu,CEU_freq)
PRSS_YRI_CHB_FST = cal_Fst(YRI_nu,YRI_freq,CHB_nu,CHB_freq)
PRSS_CEU_CHB_FST = cal_Fst(CEU_nu,CEU_freq,CHB_nu,CHB_freq)
PRSS_YRI_CEU_CHB_FST = cal_Fst_3pop(YRI_nu,YRI_freq,CEU_nu,CEU_freq,CHB_nu,CHB_freq)
print("PRSS_YRI_CEU_FST =" + str(PRSS_YRI_CEU_FST))
print("PRSS_YRI_CHB_FST =" + str(PRSS_YRI_CHB_FST))
print("PRSS_CEU_CHB_FST =" + str(PRSS_CEU_CHB_FST))
print("PRSS_YRI_CEU_CHB_FST =" + str(PRSS_YRI_CEU_CHB_FST))


###002-stdpopsim_rpss_hap
ref_seed_dt = {}
ref_seed_list = []
line_nu = 0
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/014-stdpopsim/results/007-summary_Theta_D_F_H/YRI_CEU_CHB.stdpopsim_PRSS_ancestral_and_derived_hap.Theta_D_F_H.txt"
with open(ref_path) as file:
    for line in file:
        line_nu += 1
        if line_nu == 1:
            pass
        else:
            j = line.strip().split()
            pop = j[0]
            hap_state = j[1]
            pop_hap_state = pop + "--" + hap_state
            seed = j[2].split("-")[1]
            hap_nu = j[6]
            if seed not in ref_seed_dt:
                ref_seed_dt[seed] = {}
                ref_seed_dt[seed][pop_hap_state] = hap_nu
                ref_seed_list.append(seed)
            else:
                ref_seed_dt[seed][pop_hap_state] = hap_nu


ref_pop_list = ["YRI","CEU","CHB"]
ref_hap_state_list = ["Ancestral","Derived"]
ref_confindent_seed_list = []
for seed in ref_seed_list:
    confindent_nu = 0
    for pop in ref_pop_list:
        for hap_state in ref_hap_state_list:
            pop_hap_state = pop + "--" + hap_state
            if pop_hap_state in ref_seed_dt[seed]:
                confindent_nu += 1
    if confindent_nu == 6:
        ref_confindent_seed_list.append(seed)

ref_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/results/"
fout_result_list = []
for seed in ref_confindent_seed_list:
    YRI_Ancestral_hap = ref_seed_dt[seed]["YRI--Ancestral"]
    CEU_Ancestral_hap = ref_seed_dt[seed]["CEU--Ancestral"]
    CHB_Ancestral_hap = ref_seed_dt[seed]["CHB--Ancestral"]
    YRI_Derived_hap = ref_seed_dt[seed]["YRI--Derived"]
    CEU_Derived_hap = ref_seed_dt[seed]["CEU--Derived"]
    CHB_Derived_hap = ref_seed_dt[seed]["CHB--Derived"]
    YRI_freq = float(YRI_Derived_hap)/(float(YRI_Ancestral_hap) + float(YRI_Derived_hap))
    CEU_freq = float(CEU_Derived_hap)/(float(CEU_Ancestral_hap) + float(CEU_Derived_hap))
    CHB_freq = float(CHB_Derived_hap)/(float(CHB_Ancestral_hap) + float(CHB_Derived_hap))
    result = (seed,str(YRI_freq),str(CEU_freq),str(CHB_freq))
    fout_result_list.append(result)

fout_path = ref_prefix + "stdpopsim_PRSS_hap.YRI_CEU_CHB_freq.txt"
fout_file = open(fout_path,"w")
result = ("seed","YRI_freq","CEU_freq","CHB_freq")
fout_file.write("\t".join(result) + "\n")
for result in fout_result_list[:1000]:
    fout_file.write("\t".join(result) + "\n")
fout_file.close()

fout_result_list = []
stdpopsim_YRI_CEU_FST_list = []
stdpopsim_YRI_CHB_FST_list = []
stdpopsim_CEU_CHB_FST_list = []
stdpopsim_YRI_CEU_CHB_FST_list = []
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/results/stdpopsim_PRSS_hap.YRI_CEU_CHB_freq.txt"
line_nu = 0
with open(ref_path) as file:
    for line in file:
        line_nu += 1
        if line_nu == 1:
            pass
        else:
            j = line.strip().split()
            YRI_freq = float(j[1])
            CEU_freq = float(j[2])
            CHB_freq = float(j[3])
            total_freq = YRI_freq + CEU_freq + CHB_freq 
            if total_freq > 0:
                YRI_CEU_FST = cal_Fst(YRI_nu,YRI_freq,CEU_nu,CEU_freq)
                YRI_CHB_FST = cal_Fst(YRI_nu,YRI_freq,CHB_nu,CHB_freq)
                CEU_CHB_FST = cal_Fst(CEU_nu,CEU_freq,CHB_nu,CHB_freq)
                YRI_CEU_CHB_FST = cal_Fst_3pop(YRI_nu,YRI_freq,CEU_nu,CEU_freq,CHB_nu,CHB_freq)
                stdpopsim_YRI_CEU_FST_list.append(float(YRI_CEU_FST))
                stdpopsim_YRI_CHB_FST_list.append(float(YRI_CHB_FST))
                stdpopsim_CEU_CHB_FST_list.append(float(CEU_CHB_FST))
                stdpopsim_YRI_CEU_CHB_FST_list.append(float(YRI_CEU_CHB_FST))
                fout_result_list.append([j[0],str(YRI_CEU_FST),str(YRI_CHB_FST),str(CEU_CHB_FST),str(YRI_CEU_CHB_FST)])

sign_YRI_CEU_FST_nu = int(len(stdpopsim_YRI_CEU_FST_list)*0.05)
sign_YRI_CHB_FST_nu = int(len(stdpopsim_YRI_CHB_FST_list)*0.05)
sign_CEU_CHB_FST_nu = int(len(stdpopsim_CEU_CHB_FST_list)*0.05)
sign_YRI_CEU_CHB_FST_nu = int(len(stdpopsim_YRI_CEU_CHB_FST_list)*0.05)
stdpopsim_YRI_CEU_FST_sorted_list = sorted(stdpopsim_YRI_CEU_FST_list,reverse=True)
stdpopsim_YRI_CHB_FST_sorted_list = sorted(stdpopsim_YRI_CHB_FST_list,reverse=True) 
stdpopsim_CEU_CHB_FST_sorted_list = sorted(stdpopsim_CEU_CHB_FST_list,reverse=True) 
stdpopsim_YRI_CEU_CHB_FST_sorted_list = sorted(stdpopsim_YRI_CEU_CHB_FST_list,reverse=True) 
print("stdpopsim_sign_YRI_CEU_FST = " + str(stdpopsim_YRI_CEU_FST_sorted_list[sign_YRI_CEU_FST_nu]))
print("stdpopsim_sign_YRI_CHB_FST = " + str(stdpopsim_YRI_CHB_FST_sorted_list[sign_YRI_CHB_FST_nu]))
print("stdpopsim_sign_CEU_CHB_FST = " + str(stdpopsim_CEU_CHB_FST_sorted_list[sign_CEU_CHB_FST_nu]))
print("stdpopsim_sign_YRI_CEU_CHB_FST = " + str(stdpopsim_YRI_CEU_CHB_FST_sorted_list[sign_YRI_CEU_CHB_FST_nu]))
fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/results/stdpopsim_PRSS_hap.YRI_CEU_CHB.FST.txt"
fout_file = open(fout_path,"w")
result = ("ID","YRI_CEU_FST","YRI_CHB_FST","CEU_CHB_FST","YRI_CEU_CHB_FST")
fout_file.write("\t".join(result) + "\n")
for result in fout_result_list:
    fout_file.write("\t".join(result) + "\n")
fout_file.close()

for nu in range(len(stdpopsim_YRI_CHB_FST_sorted_list)):
    freq = stdpopsim_YRI_CHB_FST_sorted_list[nu]
    if float(freq) < 0.506273779283:
        print("stdpopsim-YRI-CHB-PRSS_FST_rank =" + str(float(nu)/len(stdpopsim_YRI_CHB_FST_sorted_list)))
        break

###002-stdpopsim_rpss_hap N30 
ref_seed_dt = {}
ref_seed_list = []
line_nu = 0
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/014-stdpopsim/results/007-summary_Theta_D_F_H/YRI_CEU_CHB.stdpopsim_PRSS_ancestral_and_derived_hap.Theta_D_F_H.N30.txt"
with open(ref_path) as file:
    for line in file:
        line_nu += 1
        if line_nu == 1:
            pass
        else:
            j = line.strip().split()
            pop = j[0]
            hap_state = j[1]
            pop_hap_state = pop + "--" + hap_state
            seed = j[2].split("-")[1]
            hap_nu = j[6]
            if seed not in ref_seed_dt:
                ref_seed_dt[seed] = {}
                ref_seed_dt[seed][pop_hap_state] = hap_nu
                ref_seed_list.append(seed)
            else:
                ref_seed_dt[seed][pop_hap_state] = hap_nu


ref_pop_list = ["YRI","CEU","CHB"]
ref_hap_state_list = ["Ancestral","Derived"]
ref_confindent_seed_list = []
for seed in ref_seed_list:
    confindent_nu = 0
    for pop in ref_pop_list:
        for hap_state in ref_hap_state_list:
            pop_hap_state = pop + "--" + hap_state
            if pop_hap_state in ref_seed_dt[seed]:
                confindent_nu += 1
    if confindent_nu == 6:
        ref_confindent_seed_list.append(seed)

ref_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/results/"
fout_result_list = []
for seed in ref_confindent_seed_list:
    YRI_Ancestral_hap = ref_seed_dt[seed]["YRI--Ancestral"]
    CEU_Ancestral_hap = ref_seed_dt[seed]["CEU--Ancestral"]
    CHB_Ancestral_hap = ref_seed_dt[seed]["CHB--Ancestral"]
    YRI_Derived_hap = ref_seed_dt[seed]["YRI--Derived"]
    CEU_Derived_hap = ref_seed_dt[seed]["CEU--Derived"]
    CHB_Derived_hap = ref_seed_dt[seed]["CHB--Derived"]
    YRI_freq = float(YRI_Derived_hap)/(float(YRI_Ancestral_hap) + float(YRI_Derived_hap))
    CEU_freq = float(CEU_Derived_hap)/(float(CEU_Ancestral_hap) + float(CEU_Derived_hap))
    CHB_freq = float(CHB_Derived_hap)/(float(CHB_Ancestral_hap) + float(CHB_Derived_hap))
    result = (seed,str(YRI_freq),str(CEU_freq),str(CHB_freq))
    fout_result_list.append(result)

fout_path = ref_prefix + "stdpopsim_PRSS_hap.YRI_CEU_CHB_freq.N30.txt"
fout_file = open(fout_path,"w")
result = ("seed","YRI_freq","CEU_freq","CHB_freq")
fout_file.write("\t".join(result) + "\n")
for result in fout_result_list[:1000]:
    fout_file.write("\t".join(result) + "\n")
fout_file.close()

fout_result_list = []
stdpopsim_YRI_CEU_FST_list = []
stdpopsim_YRI_CHB_FST_list = []
stdpopsim_CEU_CHB_FST_list = []
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/results/stdpopsim_PRSS_hap.YRI_CEU_CHB_freq.N30.txt"
line_nu = 0
with open(ref_path) as file:
    for line in file:
        line_nu += 1
        if line_nu == 1:
            pass
        else:
            j = line.strip().split()
            YRI_freq = float(j[1])
            CEU_freq = float(j[2])
            CHB_freq = float(j[3])
            total_freq = YRI_freq + CEU_freq + CHB_freq 
            if total_freq > 0:
                YRI_CEU_FST = cal_Fst(YRI_nu,YRI_freq,CEU_nu,CEU_freq)
                YRI_CHB_FST = cal_Fst(YRI_nu,YRI_freq,CHB_nu,CHB_freq)
                CEU_CHB_FST = cal_Fst(CEU_nu,CEU_freq,CHB_nu,CHB_freq)
                stdpopsim_YRI_CEU_FST_list.append(float(YRI_CEU_FST))
                stdpopsim_YRI_CHB_FST_list.append(float(YRI_CHB_FST))
                stdpopsim_CEU_CHB_FST_list.append(float(CEU_CHB_FST))
                fout_result_list.append([j[0],str(YRI_CEU_FST),str(YRI_CHB_FST),str(CEU_CHB_FST)])

sign_YRI_CEU_FST_nu = int(len(stdpopsim_YRI_CEU_FST_list)*0.05)
sign_YRI_CHB_FST_nu = int(len(stdpopsim_YRI_CHB_FST_list)*0.05)
sign_CEU_CHB_FST_nu = int(len(stdpopsim_CEU_CHB_FST_list)*0.05)
stdpopsim_YRI_CEU_FST_sorted_list = sorted(stdpopsim_YRI_CEU_FST_list,reverse=True)
stdpopsim_YRI_CHB_FST_sorted_list = sorted(stdpopsim_YRI_CHB_FST_list,reverse=True) 
stdpopsim_CEU_CHB_FST_sorted_list = sorted(stdpopsim_CEU_CHB_FST_list,reverse=True) 
print("stdpopsim_sign_YRI_CEU_FST = " + str(stdpopsim_YRI_CEU_FST_sorted_list[sign_YRI_CEU_FST_nu]))
print("stdpopsim_sign_YRI_CHB_FST = " + str(stdpopsim_YRI_CHB_FST_sorted_list[sign_YRI_CHB_FST_nu]))
print("stdpopsim_sign_CEU_CHB_FST = " + str(stdpopsim_CEU_CHB_FST_sorted_list[sign_CEU_CHB_FST_nu]))
fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/results/stdpopsim_PRSS_hap.YRI_CEU_CHB.FST.N30.txt"
fout_file = open(fout_path,"w")
result = ("ID","YRI_CEU_FST","YRI_CHB_FST","CEU_CHB_FST")
fout_file.write("\t".join(result) + "\n")
for result in fout_result_list:
    fout_file.write("\t".join(result) + "\n")
fout_file.close()

for nu in range(len(stdpopsim_YRI_CHB_FST_sorted_list)):
    freq = stdpopsim_YRI_CHB_FST_sorted_list[nu]
    if float(freq) < 0.506273779283:
        print("stdpopsim-YRI-CHB-PRSS_FST_rank =" + str(float(nu)/len(stdpopsim_YRI_CHB_FST_sorted_list)))
        break
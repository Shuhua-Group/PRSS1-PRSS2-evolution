#coding:utf-8
#2022-4-4

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


##############################
###002-pangenie_FST###
##############################
fout_result_list = []
pangenie_YRI_CEU_FST_list = []
pangenie_YRI_CHB_FST_list = []
pangenie_YRI_CEU_CHB_FST_list = []
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/reference/pangenie_merged_bi_SVs.YRI_CEU_CHB_freq.txt"
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
                YRI_CEU_CHB_FST = cal_Fst_3pop(YRI_nu,YRI_freq,CEU_nu,CEU_freq,CHB_nu,CHB_freq)
                pangenie_YRI_CEU_FST_list.append(float(YRI_CEU_FST))
                pangenie_YRI_CHB_FST_list.append(float(YRI_CHB_FST))
                pangenie_YRI_CEU_CHB_FST_list.append(float(YRI_CEU_CHB_FST))
                fout_result_list.append([j[0],str(YRI_CEU_FST),str(YRI_CHB_FST)])

sign_YRI_CEU_FST_nu = int(len(pangenie_YRI_CEU_FST_list)*0.05)
sign_YRI_CHB_FST_nu = int(len(pangenie_YRI_CHB_FST_list)*0.05)
pangenie_YRI_CEU_FST_sorted_list = sorted(pangenie_YRI_CEU_FST_list,reverse=True)
pangenie_YRI_CHB_FST_sorted_list = sorted(pangenie_YRI_CHB_FST_list,reverse=True) 
print("pangenie_sign_YRI_CEU_FST = " + str(pangenie_YRI_CEU_FST_sorted_list[sign_YRI_CEU_FST_nu]))
print("pangenie_sign_YRI_CHB_FST = " + str(pangenie_YRI_CHB_FST_sorted_list[sign_YRI_CHB_FST_nu]))
fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/results/pangenie_SVs.YRI_CEU_CHB.FST.txt"
fout_file = open(fout_path,"w")
result = ("ID","YRI_CEU_FST","YRI_CHB_FST")
fout_file.write("\t".join(result) + "\n")
for result in fout_result_list:
    fout_file.write("\t".join(result) + "\n")
fout_file.close()


#HWE filtered
fout_result_list = []
pangenie_YRI_CEU_FST_list = []
pangenie_YRI_CHB_FST_list = []
pangenie_YRI_CEU_CHB_FST_list = []
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/reference/pangenie_merged_bi_SVs.YRI_CEU_CHB_freq.filtered.txt"
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
                YRI_CEU_CHB_FST = cal_Fst_3pop(YRI_nu,YRI_freq,CEU_nu,CEU_freq,CHB_nu,CHB_freq)
                pangenie_YRI_CEU_FST_list.append(float(YRI_CEU_FST))
                pangenie_YRI_CHB_FST_list.append(float(YRI_CHB_FST))
                pangenie_YRI_CEU_CHB_FST_list.append(float(YRI_CEU_CHB_FST))
                fout_result_list.append([j[0],str(YRI_CEU_FST),str(YRI_CHB_FST),str(YRI_CEU_CHB_FST)])

sign_YRI_CEU_FST_nu = int(len(pangenie_YRI_CEU_FST_list)*0.05)
sign_YRI_CHB_FST_nu = int(len(pangenie_YRI_CHB_FST_list)*0.05)
sign_YRI_CEU_CHB_FST_nu = int(len(pangenie_YRI_CEU_CHB_FST_list)*0.05)
pangenie_YRI_CEU_FST_sorted_list = sorted(pangenie_YRI_CEU_FST_list,reverse=True)
pangenie_YRI_CHB_FST_sorted_list = sorted(pangenie_YRI_CHB_FST_list,reverse=True) 
pangenie_YRI_CEU_CHB_FST_sorted_list = sorted(pangenie_YRI_CEU_CHB_FST_list,reverse=True) 
print("pangenie_sign_filtered_YRI_CEU_FST = " + str(pangenie_YRI_CEU_FST_sorted_list[sign_YRI_CEU_FST_nu]))
print("pangenie_sign_filtered_YRI_CHB_FST = " + str(pangenie_YRI_CHB_FST_sorted_list[sign_YRI_CHB_FST_nu]))
print("pangenie_sign_filtered_YRI_CEU_CHB_FST = " + str(pangenie_YRI_CEU_CHB_FST_sorted_list[sign_YRI_CEU_CHB_FST_nu]))
fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/results/pangenie_SVs.YRI_CEU_CHB.FST.filtered.txt"
fout_file = open(fout_path,"w")
result = ("ID","YRI_CEU_FST","YRI_CHB_FST","YRI_CEU_CHB_FST")
fout_file.write("\t".join(result) + "\n")
for result in fout_result_list:
    fout_file.write("\t".join(result) + "\n")
fout_file.close()

for nu in range(len(pangenie_YRI_CEU_FST_sorted_list)):
    freq = pangenie_YRI_CEU_FST_sorted_list[nu]
    if float(freq) < 0.153897378156:
        print("YRI-CEU-PRSS_FST_rank =" + str(float(nu)/len(pangenie_YRI_CEU_FST_sorted_list)))
        break

for nu in range(len(pangenie_YRI_CHB_FST_sorted_list)):
    freq = pangenie_YRI_CHB_FST_sorted_list[nu]
    if float(freq) < 0.506273779283:
        print("YRI-CHB-PRSS_FST_rank =" + str(float(nu)/len(pangenie_YRI_CHB_FST_sorted_list)))
        break

for nu in range(len(pangenie_YRI_CEU_CHB_FST_sorted_list)):
    freq = pangenie_YRI_CEU_CHB_FST_sorted_list[nu]
    if float(freq) < 0.307386125493:
        print("YRI-CEU-CHB-PRSS_FST_rank =" + str(float(nu)/len(pangenie_YRI_CEU_CHB_FST_sorted_list)))
        break

#SV gt 10Kb
fout_result_list = []
pangenie_YRI_CEU_FST_list = []
pangenie_YRI_CHB_FST_list = []
pangenie_CEU_CHB_FST_list = []
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/reference/pangenie_merged_bi_SVs.YRI_CEU_CHB_freq.filtered.gt10Kb.txt"
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
                pangenie_YRI_CEU_FST_list.append(float(YRI_CEU_FST))
                pangenie_YRI_CHB_FST_list.append(float(YRI_CHB_FST))
                pangenie_CEU_CHB_FST_list.append(float(CEU_CHB_FST))
                fout_result_list.append([j[0],str(YRI_CEU_FST),str(YRI_CHB_FST),str(CEU_CHB_FST)])

sign_YRI_CEU_FST_nu = int(len(pangenie_YRI_CEU_FST_list)*0.05)
sign_YRI_CHB_FST_nu = int(len(pangenie_YRI_CHB_FST_list)*0.05)
sign_CEU_CHB_FST_nu = int(len(pangenie_CEU_CHB_FST_list)*0.05)
pangenie_YRI_CEU_FST_sorted_list = sorted(pangenie_YRI_CEU_FST_list,reverse=True)
pangenie_YRI_CHB_FST_sorted_list = sorted(pangenie_YRI_CHB_FST_list,reverse=True) 
pangenie_CEU_CHB_FST_sorted_list = sorted(pangenie_CEU_CHB_FST_list,reverse=True) 
print("pangenie_sign_filtered_gt10Kb_YRI_CEU_FST = " + str(pangenie_YRI_CEU_FST_sorted_list[sign_YRI_CEU_FST_nu]))
print("pangenie_sign_filtered_gt10Kb_YRI_CHB_FST = " + str(pangenie_YRI_CHB_FST_sorted_list[sign_YRI_CHB_FST_nu]))
print("pangenie_sign_filtered_gt10Kb_CEU_CHB_FST = " + str(pangenie_CEU_CHB_FST_sorted_list[sign_CEU_CHB_FST_nu]))
fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/results/pangenie_SVs.YRI_CEU_CHB.FST.filtered.gt10Kb.txt"
fout_file = open(fout_path,"w")
result = ("ID","YRI_CEU_FST","YRI_CHB_FST","CEU_CHB_FST")
fout_file.write("\t".join(result) + "\n")
for result in fout_result_list:
    fout_file.write("\t".join(result) + "\n")
fout_file.close()

for nu in range(len(pangenie_YRI_CEU_FST_sorted_list)):
    freq = pangenie_YRI_CEU_FST_sorted_list[nu]
    if float(freq) < 0.153897378156:
        print("YRI-CEU-PRSS_FST_rank =" + str(float(nu)/len(pangenie_YRI_CEU_FST_sorted_list)))
        break

for nu in range(len(pangenie_YRI_CHB_FST_sorted_list)):
    freq = pangenie_YRI_CHB_FST_sorted_list[nu]
    if float(freq) < 0.506273779283:
        print("YRI-CHB-PRSS_FST_rank =" + str(float(nu)/len(pangenie_YRI_CHB_FST_sorted_list)))
        break


#YRI freq_0.05_0.15
fout_result_list = []
pangenie_YRI_CEU_FST_list = []
pangenie_YRI_CHB_FST_list = []
pangenie_CEU_CHB_FST_list = []
pangenie_YRI_CEU_CHB_FST_list = []
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/reference/pangenie_merged_bi_SVs.YRI_CEU_CHB_freq.filtered.txt"
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
            if 0.05 <= YRI_freq <= 0.15:
                YRI_CEU_FST = cal_Fst(YRI_nu,YRI_freq,CEU_nu,CEU_freq)
                YRI_CHB_FST = cal_Fst(YRI_nu,YRI_freq,CHB_nu,CHB_freq)
                CEU_CHB_FST = cal_Fst(CEU_nu,CEU_freq,CHB_nu,CHB_freq)
                YRI_CEU_CHB_FST = cal_Fst_3pop(YRI_nu,YRI_freq,CEU_nu,CEU_freq,CHB_nu,CHB_freq)
                pangenie_YRI_CEU_FST_list.append(float(YRI_CEU_FST))
                pangenie_YRI_CHB_FST_list.append(float(YRI_CHB_FST))
                pangenie_CEU_CHB_FST_list.append(float(CEU_CHB_FST))
                pangenie_YRI_CEU_CHB_FST_list.append(float(YRI_CEU_CHB_FST))
                fout_result_list.append([j[0],str(YRI_CEU_FST),str(YRI_CHB_FST),str(CEU_CHB_FST),str(YRI_CEU_CHB_FST)])

sign_YRI_CEU_FST_nu = int(len(pangenie_YRI_CEU_FST_list)*0.05)
sign_YRI_CHB_FST_nu = int(len(pangenie_YRI_CHB_FST_list)*0.05)
sign_CEU_CHB_FST_nu = int(len(pangenie_CEU_CHB_FST_list)*0.05)
sign_YRI_CEU_CHB_FST_nu = int(len(pangenie_YRI_CEU_CHB_FST_list)*0.05)
pangenie_YRI_CEU_FST_sorted_list = sorted(pangenie_YRI_CEU_FST_list,reverse=True)
pangenie_YRI_CHB_FST_sorted_list = sorted(pangenie_YRI_CHB_FST_list,reverse=True) 
pangenie_CEU_CHB_FST_sorted_list = sorted(pangenie_CEU_CHB_FST_list,reverse=True) 
pangenie_YRI_CEU_CHB_FST_sorted_list = sorted(pangenie_YRI_CEU_CHB_FST_list,reverse=True) 
print("pangenie_sign_filtered_YRI_0.05_0.15_YRI_CEU_FST = " + str(pangenie_YRI_CEU_FST_sorted_list[sign_YRI_CEU_FST_nu]))
print("pangenie_sign_filtered_YRI_0.05_0.15_YRI_CHB_FST = " + str(pangenie_YRI_CHB_FST_sorted_list[sign_YRI_CHB_FST_nu]))
print("pangenie_sign_filtered_YRI_0.05_0.15_CEU_CHB_FST = " + str(pangenie_CEU_CHB_FST_sorted_list[sign_CEU_CHB_FST_nu]))
print("pangenie_sign_filtered_YRI_0.05_0.15_YRI_CEU_CHB_FST = " + str(pangenie_YRI_CEU_CHB_FST_sorted_list[sign_YRI_CEU_CHB_FST_nu]))
fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/results/pangenie_SVs.YRI_CEU_CHB.FST.filtered.freq_0.05_0.15.txt"
fout_file = open(fout_path,"w")
result = ("ID","YRI_CEU_FST","YRI_CHB_FST","CEU_CHB_FST","YRI_CEU_CHB_FST")
fout_file.write("\t".join(result) + "\n")
for result in fout_result_list:
    fout_file.write("\t".join(result) + "\n")
fout_file.close()

for nu in range(len(pangenie_YRI_CEU_CHB_FST_sorted_list)):
    freq = pangenie_YRI_CEU_CHB_FST_sorted_list[nu]
    if float(freq) < 0.307386125493:
        print("pangenie_sign_filtered_0.05_0.15-YRI-CEU-CHB-PRSS_FST_rank =" + str(float(nu)/len(pangenie_YRI_CEU_CHB_FST_sorted_list)))
        break

#CEU freq_0.37_0.47
fout_result_list = []
pangenie_YRI_CEU_FST_list = []
pangenie_YRI_CHB_FST_list = []
pangenie_CEU_CHB_FST_list = []
pangenie_YRI_CEU_CHB_FST_list = []
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/reference/pangenie_merged_bi_SVs.YRI_CEU_CHB_freq.filtered.txt"
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
            if 0.37 <= CEU_freq <= 0.47:
                YRI_CEU_FST = cal_Fst(YRI_nu,YRI_freq,CEU_nu,CEU_freq)
                YRI_CHB_FST = cal_Fst(YRI_nu,YRI_freq,CHB_nu,CHB_freq)
                CEU_CHB_FST = cal_Fst(CEU_nu,CEU_freq,CHB_nu,CHB_freq)
                YRI_CEU_CHB_FST = cal_Fst_3pop(YRI_nu,YRI_freq,CEU_nu,CEU_freq,CHB_nu,CHB_freq)
                pangenie_YRI_CEU_FST_list.append(float(YRI_CEU_FST))
                pangenie_YRI_CHB_FST_list.append(float(YRI_CHB_FST))
                pangenie_CEU_CHB_FST_list.append(float(CEU_CHB_FST))
                pangenie_YRI_CEU_CHB_FST_list.append(float(YRI_CEU_CHB_FST))
                fout_result_list.append([j[0],str(YRI_CEU_FST),str(YRI_CHB_FST),str(CEU_CHB_FST),str(YRI_CEU_CHB_FST)])

sign_YRI_CEU_FST_nu = int(len(pangenie_YRI_CEU_FST_list)*0.05)
sign_YRI_CHB_FST_nu = int(len(pangenie_YRI_CHB_FST_list)*0.05)
sign_CEU_CHB_FST_nu = int(len(pangenie_CEU_CHB_FST_list)*0.05)
sign_YRI_CEU_CHB_FST_nu = int(len(pangenie_YRI_CEU_CHB_FST_list)*0.05)
pangenie_YRI_CEU_FST_sorted_list = sorted(pangenie_YRI_CEU_FST_list,reverse=True)
pangenie_YRI_CHB_FST_sorted_list = sorted(pangenie_YRI_CHB_FST_list,reverse=True) 
pangenie_CEU_CHB_FST_sorted_list = sorted(pangenie_CEU_CHB_FST_list,reverse=True) 
pangenie_YRI_CEU_CHB_FST_sorted_list = sorted(pangenie_YRI_CEU_CHB_FST_list,reverse=True) 
print("pangenie_sign_filtered_CEU_freq_0.37_0.47_YRI_CEU_FST = " + str(pangenie_YRI_CEU_FST_sorted_list[sign_YRI_CEU_FST_nu]))
print("pangenie_sign_filtered_CEU_freq_0.37_0.47_YRI_CHB_FST = " + str(pangenie_YRI_CHB_FST_sorted_list[sign_YRI_CHB_FST_nu]))
print("pangenie_sign_filtered_CEU_freq_0.37_0.47_CEU_CHB_FST = " + str(pangenie_CEU_CHB_FST_sorted_list[sign_CEU_CHB_FST_nu]))
print("pangenie_sign_filtered_CEU_freq_0.37_0.47_YRI_CEU_CHB_FST = " + str(pangenie_YRI_CEU_CHB_FST_sorted_list[sign_YRI_CEU_CHB_FST_nu]))
fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/results/pangenie_SVs.YRI_CEU_CHB.FST.filtered.CEU_freq_0.37_0.47.txt"
fout_file = open(fout_path,"w")
result = ("ID","YRI_CEU_FST","YRI_CHB_FST","CEU_CHB_FST","YRI_CEU_CHB_FST")
fout_file.write("\t".join(result) + "\n")
for result in fout_result_list:
    fout_file.write("\t".join(result) + "\n")
fout_file.close()

for nu in range(len(pangenie_YRI_CEU_FST_sorted_list)):
    freq = pangenie_YRI_CEU_FST_sorted_list[nu]
    if float(freq) < 0.153897378156:
        print("YRI-CEU-PRSS_FST_rank =" + str(float(nu)/len(pangenie_YRI_CEU_FST_sorted_list)))
        break

for nu in range(len(pangenie_YRI_CHB_FST_sorted_list)):
    freq = pangenie_YRI_CHB_FST_sorted_list[nu]
    if float(freq) < 0.506273779283:
        print("YRI-CHB-PRSS_FST_rank =" + str(float(nu)/len(pangenie_YRI_CHB_FST_sorted_list)))
        break

#CHB freq_0.68_0.78
fout_result_list = []
pangenie_YRI_CEU_FST_list = []
pangenie_YRI_CHB_FST_list = []
pangenie_CEU_CHB_FST_list = []
pangenie_YRI_CEU_CHB_FST_list = []
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/reference/pangenie_merged_bi_SVs.YRI_CEU_CHB_freq.filtered.txt"
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
            if 0.68 <= CHB_freq <= 0.78:
                YRI_CEU_FST = cal_Fst(YRI_nu,YRI_freq,CEU_nu,CEU_freq)
                YRI_CHB_FST = cal_Fst(YRI_nu,YRI_freq,CHB_nu,CHB_freq)
                CEU_CHB_FST = cal_Fst(CEU_nu,CEU_freq,CHB_nu,CHB_freq)
                YRI_CEU_CHB_FST = cal_Fst_3pop(YRI_nu,YRI_freq,CEU_nu,CEU_freq,CHB_nu,CHB_freq)
                pangenie_YRI_CEU_FST_list.append(float(YRI_CEU_FST))
                pangenie_YRI_CHB_FST_list.append(float(YRI_CHB_FST))
                pangenie_CEU_CHB_FST_list.append(float(CEU_CHB_FST))
                pangenie_YRI_CEU_CHB_FST_list.append(float(YRI_CEU_CHB_FST))
                fout_result_list.append([j[0],str(YRI_CEU_FST),str(YRI_CHB_FST),str(CEU_CHB_FST),str(YRI_CEU_CHB_FST)])

sign_YRI_CEU_FST_nu = int(len(pangenie_YRI_CEU_FST_list)*0.05)
sign_YRI_CHB_FST_nu = int(len(pangenie_YRI_CHB_FST_list)*0.05)
sign_CEU_CHB_FST_nu = int(len(pangenie_CEU_CHB_FST_list)*0.05)
sign_YRI_CEU_CHB_FST_nu = int(len(pangenie_YRI_CEU_CHB_FST_list)*0.05)
pangenie_YRI_CEU_FST_sorted_list = sorted(pangenie_YRI_CEU_FST_list,reverse=True)
pangenie_YRI_CHB_FST_sorted_list = sorted(pangenie_YRI_CHB_FST_list,reverse=True) 
pangenie_CEU_CHB_FST_sorted_list = sorted(pangenie_CEU_CHB_FST_list,reverse=True) 
pangenie_YRI_CEU_CHB_FST_sorted_list = sorted(pangenie_YRI_CEU_CHB_FST_list,reverse=True) 
print("pangenie_sign_filtered_CHB_freq_0.68_0.78_YRI_CEU_FST = " + str(pangenie_YRI_CEU_FST_sorted_list[sign_YRI_CEU_FST_nu]))
print("pangenie_sign_filtered_CHB_freq_0.68_0.78_YRI_CHB_FST = " + str(pangenie_YRI_CHB_FST_sorted_list[sign_YRI_CHB_FST_nu]))
print("pangenie_sign_filtered_CHB_freq_0.68_0.78_CEU_CHB_FST = " + str(pangenie_CEU_CHB_FST_sorted_list[sign_CEU_CHB_FST_nu]))
print("pangenie_sign_filtered_CHB_freq_0.68_0.78_YRI_CEU_CHB_FST = " + str(pangenie_YRI_CEU_CHB_FST_sorted_list[sign_YRI_CEU_CHB_FST_nu]))
fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/results/pangenie_SVs.YRI_CEU_CHB.FST.filtered.CHB_freq_0.68_0.78.txt"
fout_file = open(fout_path,"w")
result = ("ID","YRI_CEU_FST","YRI_CHB_FST","CEU_CHB_FST","YRI_CEU_CHB_FST")
fout_file.write("\t".join(result) + "\n")
for result in fout_result_list:
    fout_file.write("\t".join(result) + "\n")
fout_file.close()

for nu in range(len(pangenie_YRI_CEU_FST_sorted_list)):
    freq = pangenie_YRI_CEU_FST_sorted_list[nu]
    if float(freq) < 0.153897378156:
        print("YRI-CEU-PRSS_FST_rank =" + str(float(nu)/len(pangenie_YRI_CEU_FST_sorted_list)))
        break

for nu in range(len(pangenie_YRI_CHB_FST_sorted_list)):
    freq = pangenie_YRI_CHB_FST_sorted_list[nu]
    if float(freq) < 0.506273779283:
        print("YRI-CHB-PRSS_FST_rank =" + str(float(nu)/len(pangenie_YRI_CHB_FST_sorted_list)))
        break

#CHB freq_0.68_0.78
fout_result_list = []
pangenie_YRI_CEU_FST_list = []
pangenie_YRI_CHB_FST_list = []
pangenie_CEU_CHB_FST_list = []
pangenie_YRI_CEU_CHB_FST_list = []
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/reference/pangenie_merged_bi_SVs.YRI_CEU_CHB_freq.filtered.txt"
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
            if  (0.37 <= CEU_freq <= 0.47) and (0.68 <= CHB_freq <= 0.78):
                YRI_CEU_FST = cal_Fst(YRI_nu,YRI_freq,CEU_nu,CEU_freq)
                YRI_CHB_FST = cal_Fst(YRI_nu,YRI_freq,CHB_nu,CHB_freq)
                CEU_CHB_FST = cal_Fst(CEU_nu,CEU_freq,CHB_nu,CHB_freq)
                YRI_CEU_CHB_FST = cal_Fst_3pop(YRI_nu,YRI_freq,CEU_nu,CEU_freq,CHB_nu,CHB_freq)
                pangenie_YRI_CEU_FST_list.append(float(YRI_CEU_FST))
                pangenie_YRI_CHB_FST_list.append(float(YRI_CHB_FST))
                pangenie_CEU_CHB_FST_list.append(float(CEU_CHB_FST))
                pangenie_YRI_CEU_CHB_FST_list.append(float(YRI_CEU_CHB_FST))
                fout_result_list.append([j[0],str(YRI_CEU_FST),str(YRI_CHB_FST),str(CEU_CHB_FST),str(YRI_CEU_CHB_FST)])

sign_YRI_CEU_FST_nu = int(len(pangenie_YRI_CEU_FST_list)*0.05)
sign_YRI_CHB_FST_nu = int(len(pangenie_YRI_CHB_FST_list)*0.05)
sign_CEU_CHB_FST_nu = int(len(pangenie_CEU_CHB_FST_list)*0.05)
sign_YRI_CEU_CHB_FST_nu = int(len(pangenie_YRI_CEU_CHB_FST_list)*0.05)
pangenie_YRI_CEU_FST_sorted_list = sorted(pangenie_YRI_CEU_FST_list,reverse=True)
pangenie_YRI_CHB_FST_sorted_list = sorted(pangenie_YRI_CHB_FST_list,reverse=True) 
pangenie_CEU_CHB_FST_sorted_list = sorted(pangenie_CEU_CHB_FST_list,reverse=True) 
pangenie_YRI_CEU_CHB_FST_sorted_list = sorted(pangenie_YRI_CEU_CHB_FST_list,reverse=True) 
print("pangenie_sign_filtered_CEU_freq_0.37_0.47.CHB_freq_0.68_0.78_YRI_CEU_FST = " + str(pangenie_YRI_CEU_FST_sorted_list[sign_YRI_CEU_FST_nu]))
print("pangenie_sign_filtered_CEU_freq_0.37_0.47.CHB_freq_0.68_0.78_YRI_CHB_FST = " + str(pangenie_YRI_CHB_FST_sorted_list[sign_YRI_CHB_FST_nu]))
print("pangenie_sign_filtered_CEU_freq_0.37_0.47.CHB_freq_0.68_0.78_CEU_CHB_FST = " + str(pangenie_CEU_CHB_FST_sorted_list[sign_CEU_CHB_FST_nu]))
print("pangenie_sign_filtered_CEU_freq_0.37_0.47.CHB_freq_0.68_0.78_YRI_CEU_CHB_FST = " + str(pangenie_YRI_CEU_CHB_FST_sorted_list[sign_YRI_CEU_CHB_FST_nu]))
fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/results/pangenie_SVs.YRI_CEU_CHB.FST.filtered.CEU_freq_0.37_0.47.CHB_freq_0.68_0.78.txt"
fout_file = open(fout_path,"w")
result = ("ID","YRI_CEU_FST","YRI_CHB_FST","CEU_CHB_FST","YRI_CEU_CHB_FST")
fout_file.write("\t".join(result) + "\n")
for result in fout_result_list:
    fout_file.write("\t".join(result) + "\n")
fout_file.close()

for nu in range(len(pangenie_YRI_CEU_FST_sorted_list)):
    freq = pangenie_YRI_CEU_FST_sorted_list[nu]
    if float(freq) < 0.153897378156:
        print("YRI-CEU-PRSS_FST_rank =" + str(float(nu)/len(pangenie_YRI_CEU_FST_sorted_list)))
        break

for nu in range(len(pangenie_YRI_CHB_FST_sorted_list)):
    freq = pangenie_YRI_CHB_FST_sorted_list[nu]
    if float(freq) < 0.506273779283:
        print("YRI-CHB-PRSS_FST_rank =" + str(float(nu)/len(pangenie_YRI_CHB_FST_sorted_list)))
        break

##############################
#003-stdpopsim_FST######
##############################
###stdpopsim ALL variants
fout_result_list = []
stdpopsim_YRI_CEU_FST_list = []
stdpopsim_YRI_CHB_FST_list = []
stdpopsim_YRI_CEU_CHB_FST_list = []
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/reference/stdpopsim_SVs.YRI_CEU_CHB_freq.txt"
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
                YRI_CEU_CHB_FST = cal_Fst_3pop(YRI_nu,YRI_freq,CEU_nu,CEU_freq,CHB_nu,CHB_freq)
                stdpopsim_YRI_CEU_FST_list.append(float(YRI_CEU_FST))
                stdpopsim_YRI_CHB_FST_list.append(float(YRI_CHB_FST))
                stdpopsim_YRI_CEU_CHB_FST_list.append(float(YRI_CEU_CHB_FST))
                fout_result_list.append([j[0],str(YRI_CEU_FST),str(YRI_CHB_FST)])

sign_YRI_CEU_FST_nu = int(len(stdpopsim_YRI_CEU_FST_list)*0.05)
sign_YRI_CHB_FST_nu = int(len(stdpopsim_YRI_CHB_FST_list)*0.05)
sign_YRI_CEU_CHB_FST_nu = int(len(stdpopsim_YRI_CEU_CHB_FST_list)*0.05)
stdpopsim_YRI_CEU_FST_sorted_list = sorted(stdpopsim_YRI_CEU_FST_list,reverse=True)
stdpopsim_YRI_CHB_FST_sorted_list = sorted(stdpopsim_YRI_CHB_FST_list,reverse=True) 
stdpopsim_YRI_CEU_CHB_FST_sorted_list = sorted(stdpopsim_YRI_CEU_CHB_FST_list,reverse=True) 
print("stdpopsim_sign_YRI_CEU_FST = " + str(stdpopsim_YRI_CEU_FST_sorted_list[sign_YRI_CEU_FST_nu]))
print("stdpopsim_sign_YRI_CHB_FST = " + str(stdpopsim_YRI_CHB_FST_sorted_list[sign_YRI_CHB_FST_nu]))
print("stdpopsim_sign_YRI_CEU_CHB_FST = " + str(stdpopsim_YRI_CEU_CHB_FST_sorted_list[sign_YRI_CEU_CHB_FST_nu]))
fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/results/stdpopsim_SVs.YRI_CEU_CHB.FST.txt"
fout_file = open(fout_path,"w")
result = ("ID","YRI_CEU_FST","YRI_CHB_FST")
fout_file.write("\t".join(result) + "\n")
for result in fout_result_list:
    fout_file.write("\t".join(result) + "\n")
fout_file.close()

for nu in range(len(stdpopsim_YRI_CHB_FST_sorted_list)):
    freq = stdpopsim_YRI_CHB_FST_sorted_list[nu]
    if float(freq) < 0.506273779283:
        print("stdpopsim-YRI-CHB-PRSS_FST_rank =" + str(float(nu)/len(stdpopsim_YRI_CHB_FST_sorted_list)))
        break
rank_nu = int(len(stdpopsim_YRI_CHB_FST_sorted_list)*0.01)
print("stdpopsim-YRI-CHB-rank0.01_FST =" + str(stdpopsim_YRI_CHB_FST_sorted_list[rank_nu]))

###stdpopsim freq 0.8-0.9
fout_result_list = []
stdpopsim_YRI_CEU_FST_list = []
stdpopsim_YRI_CHB_FST_list = []
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/reference/stdpopsim_SVs.YRI_CEU_CHB_freq.txt"
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
            if 0.8 <= YRI_freq <= 0.9:
                YRI_CEU_FST = cal_Fst(YRI_nu,YRI_freq,CEU_nu,CEU_freq)
                YRI_CHB_FST = cal_Fst(YRI_nu,YRI_freq,CHB_nu,CHB_freq)
                stdpopsim_YRI_CEU_FST_list.append(float(YRI_CEU_FST))
                stdpopsim_YRI_CHB_FST_list.append(float(YRI_CHB_FST))
                fout_result_list.append([j[0],str(YRI_CEU_FST),str(YRI_CHB_FST)])

sign_YRI_CEU_FST_nu = int(len(stdpopsim_YRI_CEU_FST_list)*0.05)
sign_YRI_CHB_FST_nu = int(len(stdpopsim_YRI_CHB_FST_list)*0.05)
stdpopsim_YRI_CEU_FST_sorted_list = sorted(stdpopsim_YRI_CEU_FST_list,reverse=True)
stdpopsim_YRI_CHB_FST_sorted_list = sorted(stdpopsim_YRI_CHB_FST_list,reverse=True) 
print("stdpopsim_freq_0.8_0.9_sign_YRI_CEU_FST = " + str(stdpopsim_YRI_CEU_FST_sorted_list[sign_YRI_CEU_FST_nu]))
print("stdpopsim_freq_0.8_0.9_sign_YRI_CHB_FST = " + str(stdpopsim_YRI_CHB_FST_sorted_list[sign_YRI_CHB_FST_nu]))
fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/results/stdpopsim_SVs.YRI_CEU_CHB.FST.freq_0.8_0.9.txt"
fout_file = open(fout_path,"w")
result = ("ID","YRI_CEU_FST","YRI_CHB_FST")
fout_file.write("\t".join(result) + "\n")
for result in fout_result_list:
    fout_file.write("\t".join(result) + "\n")
fout_file.close()

###stdpopsim freq 0.05-0.15
fout_result_list = []
stdpopsim_YRI_CEU_FST_list = []
stdpopsim_YRI_CHB_FST_list = []
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/reference/stdpopsim_SVs.YRI_CEU_CHB_freq.txt"
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
            if 0.05 <= YRI_freq <= 0.15:
                YRI_CEU_FST = cal_Fst(YRI_nu,YRI_freq,CEU_nu,CEU_freq)
                YRI_CHB_FST = cal_Fst(YRI_nu,YRI_freq,CHB_nu,CHB_freq)
                stdpopsim_YRI_CEU_FST_list.append(float(YRI_CEU_FST))
                stdpopsim_YRI_CHB_FST_list.append(float(YRI_CHB_FST))
                fout_result_list.append([j[0],str(YRI_CEU_FST),str(YRI_CHB_FST)])

sign_YRI_CEU_FST_nu = int(len(stdpopsim_YRI_CEU_FST_list)*0.05)
sign_YRI_CHB_FST_nu = int(len(stdpopsim_YRI_CHB_FST_list)*0.05)
stdpopsim_YRI_CEU_FST_sorted_list = sorted(stdpopsim_YRI_CEU_FST_list,reverse=True)
stdpopsim_YRI_CHB_FST_sorted_list = sorted(stdpopsim_YRI_CHB_FST_list,reverse=True) 
print("stdpopsim_freq_0.05_0.15_sign_YRI_CEU_FST = " + str(stdpopsim_YRI_CEU_FST_sorted_list[sign_YRI_CEU_FST_nu]))
print("stdpopsim_freq_0.05_0.15_sign_YRI_CHB_FST = " + str(stdpopsim_YRI_CHB_FST_sorted_list[sign_YRI_CHB_FST_nu]))
fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/016-PRSS_Fst/results/stdpopsim_SVs.YRI_CEU_CHB.FST.freq_0.05_0.15.txt"
fout_file = open(fout_path,"w")
result = ("ID","YRI_CEU_FST","YRI_CHB_FST")
fout_file.write("\t".join(result) + "\n")
for result in fout_result_list:
    fout_file.write("\t".join(result) + "\n")
fout_file.close()

for nu in range(len(stdpopsim_YRI_CHB_FST_sorted_list)):
    freq = stdpopsim_YRI_CHB_FST_sorted_list[nu]
    if float(freq) < 0.506273779283:
        print("stdpopsim-freq_0.05_0.15-YRI-CHB-PRSS_FST_rank =" + str(float(nu)/len(stdpopsim_YRI_CHB_FST_sorted_list)))
        break
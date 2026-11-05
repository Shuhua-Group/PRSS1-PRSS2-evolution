#coding:utf-8
#2021-1-13
#source activate py36
import os 
import egglib
import subprocess
import multiprocessing

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

def use_egglib(ref_path):
    aln1 = egglib.io.from_fasta(ref_path, labels=True, alphabet = egglib.alphabets.DNA)
    struct = egglib.struct_from_labels(aln1)
    cs = egglib.stats.ComputeStats()
    cs.set_structure(struct)
    cs.add_stats('S', 'thetaW', 'Pi', 'D', 'lseff', 'nseff')
    stats = cs.process_align(aln1)
    TajimaD = stats["D"]
    return(TajimaD)

fout_result_list = []
ref_pop_tajimad_dt = {} 
for pop in ref_pop_list:
    print(pop)
    sample_nu = len(ref_pop_dt[pop])
    if sample_nu > 50:
        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/" + pop + ".PRSS_copy3.PRSS1.remapping.fasta"
        PRSS1_copy3_tajimad = use_egglib(ref_path)

        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/" + pop + ".PRSS_copy3.PRSS3P1.remapping.fasta"
        PRSS3P1_copy3_tajimad = use_egglib(ref_path)

        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/" + pop + ".PRSS_copy3.PRSS2.remapping.fasta"
        PRSS2_copy3_tajimad = use_egglib(ref_path)

        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/" + pop + ".PRSS_copy3.PRSS1_PRSS3P1_PRSS2.remapping.fasta"
        PRSS_copy3_tajimad = use_egglib(ref_path)

        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/" + pop + ".PRSS_copy5.PRSS1.remapping.fasta"
        PRSS1_copy5_tajimad = use_egglib(ref_path)

        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/" + pop + ".PRSS_copy5.PRSS3P1.remapping.fasta"
        PRSS3P1_copy5_tajimad = use_egglib(ref_path)

        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/" + pop + ".PRSS_copy5.PRSS3P2.remapping.fasta"
        PRSS3P2_copy5_tajimad = use_egglib(ref_path)

        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/" + pop + ".PRSS_copy5.TRY7.remapping.fasta"
        TRY7_copy5_tajimad = use_egglib(ref_path)

        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/" + pop + ".PRSS_copy5.PRSS2.remapping.fasta"
        PRSS2_copy5_tajimad = use_egglib(ref_path)

        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/" + pop + ".PRSS_copy5.PRSS1_PRSS3P1_PRSS2.remapping.fasta"
        PRSS_copy5_tajimad = use_egglib(ref_path)

        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/" + pop + ".PRSS_copy5.PRSS1_PRSS3P1_PRSS3P2_TRY7_PRSS2.remapping.fasta"
        PRSS_copy5_tajimad_beta = use_egglib(ref_path)

        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/" + pop + ".PRSS_copy3_copy5.remapping.fasta"
        PRSS_copy3_copy5_tajimad = use_egglib(ref_path)

        result = (pop,str(len(ref_pop_dt[pop])),str(PRSS1_copy3_tajimad),str(PRSS3P1_copy3_tajimad),str(PRSS2_copy3_tajimad),str(PRSS_copy3_tajimad),str(PRSS1_copy5_tajimad),str(PRSS3P1_copy5_tajimad),str(PRSS3P2_copy5_tajimad),str(TRY7_copy5_tajimad),str(PRSS2_copy5_tajimad),str(PRSS_copy5_tajimad),str(PRSS_copy5_tajimad_beta),str(PRSS_copy3_copy5_tajimad))
        fout_result_list.append(result)
        ref_pop_tajimad_dt[pop] = [str(PRSS_copy3_tajimad),str(PRSS_copy5_tajimad)]


fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/KGP_diff_pop.PRSS_copy3_copy5.TajimaD.remapping.txt"
fout_file = open(fout_path,"w")
result = ("pop","sample_nu","PRSS1_copy3_tajimad","PRSS3P1_copy3_tajimad","PRSS2_copy3_tajimad","3-copy-PRSS(PRSS1_PRSS3P1_PRSS2)","PRSS1_copy5_tajimad","PRSS3P1_copy5_tajimad","PRSS3P2_copy5_tajimad","TRY7_copy5_tajimad","PRSS2_copy5_tajimad","5-copy-PRSS(PRSS1_PRSS3P1_PRSS2)","5-copy-PRSS(PRSS1_PRSS3P1_PRSS3P2_TRY7_PRSS2)","3_5-copy-PRSS(PRSS1_PRSS3P1_PRSS2)")
fout_file.write("\t".join(result) + "\n")
for result in fout_result_list:
    fout_file.write("\t".join(result) + "\n")
fout_file.close()


fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/KGP_diff_pop.PRSS_copy3.TajimaD.geom_point.txt"
fout_file = open(fout_path,"w")
result = ("Pop","TajimaD","Pop_PRSS_copy")
fout_file.write("\t".join(result) + "\n")
ref_pop_list = ['YRI', 'MSL', 'FIN', 'CEU', 'BEB', 'CDX', 'CHB', 'CHS', 'GIH', 'JPT', 'KHV', 'MXL', 'PJL', 'STU', 'TSI']
for pop in ref_pop_list:
    PRSS_copy3_tajimad = ref_pop_tajimad_dt[pop][0]
    result = (pop,PRSS_copy3_tajimad,pop+"--PRSS_copy3")
    fout_file.write("\t".join(result) + "\n")
fout_file.close()


fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/KGP_diff_pop.PRSS_copy5.TajimaD.geom_point.txt"
fout_file = open(fout_path,"w")
result = ("Pop","TajimaD","Pop_PRSS_copy")
fout_file.write("\t".join(result) + "\n")
ref_pop_list = ['YRI', 'MSL', 'FIN', 'CEU', 'BEB', 'CDX', 'CHB', 'CHS', 'GIH', 'JPT', 'KHV', 'MXL', 'PJL', 'STU', 'TSI']
for pop in ref_pop_list:
    PRSS_copy5_tajimad = ref_pop_tajimad_dt[pop][1]
    result = (pop,PRSS_copy5_tajimad,pop+"--PRSS_copy5")
    fout_file.write("\t".join(result) + "\n")
fout_file.close()
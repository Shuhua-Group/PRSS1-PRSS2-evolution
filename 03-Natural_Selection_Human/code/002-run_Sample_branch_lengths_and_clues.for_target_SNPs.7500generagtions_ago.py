#coding:utf-8

import os 
import numpy as np
import multiprocessing


ref_pop_list = ["CHB","CEU","YRI"]
ref_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/"
branchLengths_script = "/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh"
inference_script = "/picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py"

def run_branch_length(snp_cbind,random_nu):
    pos = snp_cbind.split("-")[1]
    pop = "CHB"
    input_path = ref_prefix + pop + "_popsize.relate_input"
    output_path = ref_prefix + "/001-Targe_SNP/" + snp_cbind + "/" + pop + "_popsize.relate_input." + snp_cbind + ".random_" + str(random_nu)
    coal_path = ref_prefix + pop + "_popsize.relate_input.coal"
    os.system("%s -i %s -o %s -m 1.25e-8 --coal %s --format b --num_samples 100 --first_bp %s --last_bp %s" %(branchLengths_script,input_path,output_path,coal_path,pos,pos))

    pop = "CEU"
    input_path = ref_prefix + pop + "_popsize.relate_input"
    output_path = ref_prefix + "/001-Targe_SNP/" + snp_cbind + "/" + pop + "_popsize.relate_input." + snp_cbind + ".random_" + str(random_nu)
    coal_path = ref_prefix + pop + "_popsize.relate_input.coal"
    os.system("%s -i %s -o %s -m 1.25e-8 --coal %s --format b --num_samples 100 --first_bp %s --last_bp %s" %(branchLengths_script,input_path,output_path,coal_path,pos,pos))

    pop = "YRI"
    input_path = ref_prefix + pop + "_popsize.relate_input"
    output_path = ref_prefix + "/001-Targe_SNP/" + snp_cbind + "/" + pop + "_popsize.relate_input." + snp_cbind + ".random_" + str(random_nu)
    coal_path = ref_prefix + pop + "_popsize.relate_input.coal"
    os.system("%s -i %s -o %s -m 1.25e-8 --coal %s --format b --num_samples 100 --first_bp %s --last_bp %s" %(branchLengths_script,input_path,output_path,coal_path,pos,pos))

def run_clues(snp_cbind,random_nu):
    pop = "CHB"
    input_path = ref_prefix + "/001-Targe_SNP/" + snp_cbind + "/" + pop + "_popsize.relate_input." + snp_cbind + ".random_" + str(random_nu)
    output_path = ref_prefix + "/001-Targe_SNP/" + snp_cbind + "/" + pop + "_popsize.relate_input." + snp_cbind + ".tCutoff_7500.random_" + str(random_nu) + ".selection_clues_out"
    os.system("/picb/humpopg/xiebo/conda/envs/py36/bin/python %s --times %s --tCutoff 7500 --out %s &" %(inference_script,input_path,output_path)) 

    pop = "CEU"
    input_path = ref_prefix + "/001-Targe_SNP/" + snp_cbind + "/" + pop + "_popsize.relate_input." + snp_cbind + ".random_" + str(random_nu)
    output_path = ref_prefix + "/001-Targe_SNP/" + snp_cbind + "/" + pop + "_popsize.relate_input." + snp_cbind + ".tCutoff_7500.random_" + str(random_nu) + ".selection_clues_out"
    os.system("/picb/humpopg/xiebo/conda/envs/py36/bin/python %s --times %s --tCutoff 7500 --out %s & " %(inference_script,input_path,output_path)) 

    pop = "YRI"
    input_path = ref_prefix + "/001-Targe_SNP/" + snp_cbind + "/" + pop + "_popsize.relate_input." + snp_cbind + ".random_" + str(random_nu)
    output_path = ref_prefix + "/001-Targe_SNP/" + snp_cbind + "/" + pop + "_popsize.relate_input." + snp_cbind + ".tCutoff_7500.random_" + str(random_nu) + ".selection_clues_out"
    os.system("/picb/humpopg/xiebo/conda/envs/py36/bin/python %s --times %s --tCutoff 7500 --out %s &" %(inference_script,input_path,output_path)) 

def get_clues_freq(snp_cbind,random_nu):
    pop = "CHB"
    get_freq_script = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/tools/003-manage_freq_traj.py"
    ref_path = ref_prefix + "/001-Targe_SNP/" + snp_cbind + "/" + pop + "_popsize.relate_input." + snp_cbind + ".tCutoff_7500.random_" + str(random_nu) + ".selection_clues_out"
    fout_path = ref_prefix + "/001-Targe_SNP/" + snp_cbind + "/" + pop + "_popsize.relate_input." + snp_cbind + ".tCutoff_7500.random_" + str(random_nu) + ".selection_clues_out"
    os.system("/picb/humpopg/xiebo/conda/envs/py27/bin/python %s %s %s" %(get_freq_script,ref_path,fout_path))
    pop = "CEU"
    get_freq_script = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/tools/003-manage_freq_traj.py"
    ref_path = ref_prefix + "/001-Targe_SNP/" + snp_cbind + "/" + pop + "_popsize.relate_input." + snp_cbind + ".tCutoff_7500.random_" + str(random_nu) + ".selection_clues_out"
    fout_path = ref_prefix + "/001-Targe_SNP/" + snp_cbind + "/" + pop + "_popsize.relate_input." + snp_cbind + ".tCutoff_7500.random_" + str(random_nu) + ".selection_clues_out"
    os.system("/picb/humpopg/xiebo/conda/envs/py27/bin/python %s %s %s" %(get_freq_script,ref_path,fout_path))
    pop = "YRI"
    get_freq_script = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/tools/003-manage_freq_traj.py"
    ref_path = ref_prefix + "/001-Targe_SNP/" + snp_cbind + "/" + pop + "_popsize.relate_input." + snp_cbind + ".tCutoff_7500.random_" + str(random_nu) + ".selection_clues_out"
    fout_path = ref_prefix + "/001-Targe_SNP/" + snp_cbind + "/" + pop + "_popsize.relate_input." + snp_cbind + ".tCutoff_7500.random_" + str(random_nu) + ".selection_clues_out"
    os.system("/picb/humpopg/xiebo/conda/envs/py27/bin/python %s %s %s" %(get_freq_script,ref_path,fout_path))

def prepare_input_for_geom_ribbon(pop,snp_cbind):
    ref_generation_list = []
    ref_generation_freq_dt = {}
    random_nu = 1
    line_nu = 0
    ref_path = ref_prefix + "/001-Targe_SNP/" + snp_cbind + "/" + pop + "_popsize.relate_input." + snp_cbind + ".tCutoff_7500.random_" + str(random_nu) + ".selection_clues_out.epochs_maxpost_freq.txt"
    with open(ref_path) as file:
        for line in file:
                line_nu += 1
                if line_nu == 1:
                    pass
                else:
                    j = line.strip().split()
                    generation = j[0]
                    taget_freq = str(1- float(j[1]))
                    lower_freq = str(1- float(j[2]))
                    upper_Freq = str(1- float(j[3]))
                    if generation not in ref_generation_freq_dt:
                        ref_generation_freq_dt[generation] = [taget_freq,lower_freq,upper_Freq]
                        ref_generation_freq_dt[generation]
                        ref_generation_list.append(generation)

    fout_path = ref_prefix + "/001-Targe_SNP/000-merge_result/" + pop + "." + snp_cbind + ".clues_freq.tCutoff_7500.geom_ribbon_input.txt"
    fout_file = open(fout_path,"w")
    result = ("Years_ago","target_freq","min_freq","max_freq")
    fout_file.write("\t".join(result) + "\n")
    for generation in ref_generation_list:
        years_ago = str(int(generation)*28*(-1))
        tmp_freq_list = ref_generation_freq_dt[generation]
        target_freq = tmp_freq_list[0]
        min_freq = tmp_freq_list[1]
        max_freq = tmp_freq_list[2]
        result = (years_ago,str(target_freq),str(min_freq),str(max_freq))
        fout_file.write("\t".join(result) + "\n")
    fout_file.close()

def run(snp_cbind):
    ref_random_result_list = []
    for nu in range(100):
        random_nu = nu + 1
        result = [snp_cbind,random_nu]
        ref_random_result_list.append(result)

    random_nu = 1
    #run_branch_length(snp_cbind,random_nu)
    #run_clues(snp_cbind,random_nu)
    get_clues_freq(snp_cbind,random_nu)


    prepare_input_for_geom_ribbon("CHB",snp_cbind)
    prepare_input_for_geom_ribbon("CEU",snp_cbind)
    prepare_input_for_geom_ribbon("YRI",snp_cbind)

run("chr7-142770582-A-G")

 

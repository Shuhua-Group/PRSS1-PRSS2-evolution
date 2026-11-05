#coding:utf-8
#2021-1-13
#source activate vcf-kit

import os 
import gzip
import subprocess
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
                    ref_pop_list.append(pop)
                    ref_pop_dt[pop].append(sample)
                else:
                    ref_pop_dt[pop].append(sample)


###002-prepare diff KGP pop vcf
for pop in ref_pop_list:
    fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/" + pop + ".txt"
    fout_file = open(fout_path,"w")
    for sample in ref_pop_dt[pop]:
        fout_file.write(sample + "\n")
    fout_file.close()

#ln -s /picb/humpopg-bigdata/archive/20200308-KGPp3-GRCh38/vcf_PASS_SNP_biallelic/CCDG_13607_B01_GRM_WGS_2019-02-19_chr7.recalibrated_variants.PASS.snps.biallelic.vcf.gz /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/CCDG_13607_B01_GRM_WGS_2019-02-19_chr7.recalibrated_variants.PASS.snps.biallelic.vcf.gz
#tabix -p vcf CCDG_13607_B01_GRM_WGS_2019-02-19_chr7.recalibrated_variants.PASS.snps.biallelic.vcf.gz
#tabix -h CCDG_13607_B01_GRM_WGS_2019-02-19_chr7.recalibrated_variants.PASS.snps.biallelic.vcf.gz chr7:142746720-142778572 > CCDG_13607_B01_GRM_WGS_2019-02-19_chr7.recalibrated_variants.PASS.snps.biallelic.chr7-142746720-142778572.vcf
#bgzip CCDG_13607_B01_GRM_WGS_2019-02-19_chr7.recalibrated_variants.PASS.snps.biallelic.chr7-142746720-142778572.vcf
#tabix -p vcf CCDG_13607_B01_GRM_WGS_2019-02-19_chr7.recalibrated_variants.PASS.snps.biallelic.chr7-142746720-142778572.vcf.gz

#ln -s /picb/humpopg-bigdata/archive/20200308-KGPp3-GRCh38/vcf_PASS_SNP_biallelic_shapeit4/KGP.GRCh38.PASS.snps.biallelic.shapeit4.chr7.vcf.gz /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/KGP.GRCh38.PASS.snps.biallelic.shapeit4.chr7.vcf.gz
#tabix -p vcf KGP.GRCh38.PASS.snps.biallelic.shapeit4.chr7.vcf.gz
#tabix -h KGP.GRCh38.PASS.snps.biallelic.shapeit4.chr7.vcf.gz chr7:142746720-142778572 > KGP.GRCh38.PASS.snps.biallelic.shapeit4.chr7-142746720-142778572.vcf
#bgzip KGP.GRCh38.PASS.snps.biallelic.shapeit4.chr7-142746720-142778572.vcf
#tabix -p vcf KGP.GRCh38.PASS.snps.biallelic.shapeit4.chr7-142746720-142778572.vcf.gz

#ln -s /picb/humpopg-bigdata/archive/20200308-KGPp3-GRCh38/vcf_PASS_SNP_biallelic_shapeit4/KGP.GRCh38.PASS.snps.biallelic.shapeit4.chr7.vcf.gz /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/KGP.GRCh38.PASS.snps.biallelic.shapeit4.chr7.vcf.gz
#tabix -p vcf KGP.GRCh38.PASS.snps.biallelic.shapeit4.chr7.vcf.gz
#tabix -h KGP.GRCh38.PASS.snps.biallelic.shapeit4.chr7.vcf.gz chr7:142746720-142778572 > KGP.GRCh38.PASS.snps.biallelic.shapeit4.chr7-142746720-142778572.vcf
#bgzip KGP.GRCh38.PASS.snps.biallelic.shapeit4.chr7-142746720-142778572.vcf
#tabix -p vcf KGP.GRCh38.PASS.snps.biallelic.shapeit4.chr7-142746720-142778572.vcf.gz

ref_chr_list = []
for i in range(1,23):
    chr = "chr" + str(i)
    ref_chr_list.append(chr)

def prepare_phased_vcf(pop):
    print(pop)
    for chr in ref_chr_list:
        ref_vcf_path = "/picb/humpopg-bigdata/archive/20200308-KGPp3-GRCh38/vcf_PASS_SNP_biallelic_shapeit4/KGP.GRCh38.PASS.snps.biallelic.shapeit4." + chr + ".vcf.gz"
        ref_sample_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/" + pop + ".txt"
        fout_vcf_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/002-vcf/" + pop + ".GRCh38.PASS.snps.biallelic.shapeit4." + chr + ".vcf.gz"
        os.system("bcftools view --force-samples -S %s --threads 20 %s |bgzip -@20 -c > %s" %(ref_sample_path,ref_vcf_path,fout_vcf_path))

#pool = multiprocessing.Pool(processes=26)
#pool.map(prepare_phased_vcf,ref_pop_list)
#pool.close()
#pool.join()


def cal_TajimaD_30Kb(pop):
    print(pop)
    binsize = "30000"
    for chr in ref_chr_list:
        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/002-vcf/" + pop + ".GRCh38.PASS.snps.biallelic.shapeit4." + chr + ".vcf.gz"
        fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/002-vcf/" + pop + ".GRCh38.PASS.snps.biallelic.shapeit4." + chr 
        fout_log = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/002-vcf/" + pop + ".GRCh38.PASS.snps.biallelic.shapeit4." + chr + ".logerr"
        os.system("vcftools --gzvcf %s --TajimaD %s --out %s >& %s" %(ref_path,binsize,fout_path,fout_log))

#pool = multiprocessing.Pool(processes=26)
#pool.map(cal_TajimaD_30Kb,ref_pop_list)
#pool.close()
#pool.join()

def cal_TajimaD_vk(pop):
    print(pop)
    binsize = "30000"
    for chr in ref_chr_list:
        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/002-vcf/" + pop + ".GRCh38.PASS.snps.biallelic.shapeit4." + chr + ".vcf.gz"
        fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/002-vcf/" + pop + ".GRCh38.PASS.snps.biallelic.shapeit4." + chr + ".vk.TajimaD"
        os.system("/picb/humpopg/xiebo/conda/envs/vcf-kit/bin/vk tajima 30000 10000 %s > %s" %(ref_path,fout_path))

#pool = multiprocessing.Pool(processes=12)
#pool.map(cal_TajimaD_vk,ref_pop_list)
#pool.close()
#pool.join()

def cal_TajimaD_10Kb(pop):
    print(pop)
    binsize = "10000"
    for chr in ref_chr_list:
        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/002-vcf/" + pop + ".GRCh38.PASS.snps.biallelic.shapeit4." + chr + ".vcf.gz"
        fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/002-vcf/" + pop + ".GRCh38.PASS.snps.biallelic.shapeit4." + chr + ".Bin_10Kb" 
        fout_log = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/002-vcf/" + pop + ".GRCh38.PASS.snps.biallelic.shapeit4." + chr + ".Bin_10Kb.logerr"
        os.system("vcftools --gzvcf %s --TajimaD %s --out %s >& %s" %(ref_path,binsize,fout_path,fout_log))

#pool = multiprocessing.Pool(processes=12)
#pool.map(cal_TajimaD_10Kb,ref_pop_list)
#pool.close()
#pool.join()


def run():
    fout_result_list = []
    ref_pop_list = ["YRI","LWK","ESN","MSL","GWD","TSI","IBS","CEU","GBR","FIN","MXL","ASW","PUR","ACB","CLM","PEL","PJL","CHB","JPT","CDX","KHV","CHS","BEB","STU","ITU","GIH"]
    for pop in ref_pop_list:
        for chr in ref_chr_list:
            line_nu = 0
            ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/" + pop + ".GRCh38.PASS.snps.biallelic.shapeit4." + chr + ".Tajima.D"
            with open(ref_path) as file:
                for line in file:
                    line_nu += 1
                    if line_nu == 1:
                        pass
                    else:
                        j = line.strip().split()
                        if j[-1] != "nan":
                            tajimad = float(j[-1])
                            fout_result_list.append([pop,str(tajimad)])

    fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/KGP_diff_pop.whole_genome_TajimaD.txt"
    fout_file = open(fout_path,"w")
    result = ("Pop","TajimaD")
    fout_file.write("\t".join(result) + "\n")

    for result in fout_result_list:
        fout_file.write("\t".join(result) + "\n")
    fout_file.close()
#run()


def run_beta():
    fout_result_list = []
    ref_pop_list = ["YRI","LWK","ESN","MSL","GWD","TSI","IBS","CEU","GBR","FIN","MXL","ASW","PUR","ACB","CLM","PEL","PJL","CHB","JPT","CDX","KHV","CHS","BEB","STU","ITU","GIH"]
    for pop in ref_pop_list:
        tmp_tajimad_list = []
        line_nu = 0
        ref_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/" + pop + ".GRCh38.PASS.snps.biallelic.shapeit4.chr7.Bin_10Kb.Tajima.D"
        with open(ref_path) as file:
            for line in file:
                line_nu += 1
                if line_nu == 1:
                    pass
                else:
                    j = line.strip().split()
                    if j[-1] != "nan":
                        tajimad = float(j[-1])
                        fout_result_list.append([pop,str(tajimad)])
                        tmp_tajimad_list.append(float(tajimad))
        tmp_sorted_tajimad_list = sorted(tmp_tajimad_list)
        sign_nu = int(len(tmp_sorted_tajimad_list)*0.05)
        print(pop + '--sign_tajimaD_nu = ' + str(tmp_sorted_tajimad_list[sign_nu]))

    fout_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/KGP_diff_pop.whole_genome_TajimaD.chr7.Bin_10Kb.high_covergae.beta.txt"
    fout_file = open(fout_path,"w")
    result = ("Pop","TajimaD")
    fout_file.write("\t".join(result) + "\n")

    for result in fout_result_list:
        fout_file.write("\t".join(result) + "\n")
    fout_file.close()
run_beta()


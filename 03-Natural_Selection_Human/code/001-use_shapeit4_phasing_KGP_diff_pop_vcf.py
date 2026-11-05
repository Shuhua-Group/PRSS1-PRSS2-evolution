#coding:utf-8
#2021-12-23

import os 
import gzip
import subprocess
import multiprocessing


ref_chr_list = []
for i in range(1,23):
    chr = "chr" + str(i)
    ref_chr_list.append(chr)

ref_pop_path = "/picb/humpopg-bigdata/xiebo/NGS/HGSVC2_haplotype_resolved_genome/reference/KGP_sample_list.tsv"
ref_sample_path = "/picb/humpopg-bigdata/xiebo/NGS/HGSVC2_haplotype_resolved_genome/result/Phased_assembly_variant_discovery/PanGenie_results/pangenie-genotyping.PRJEB31736.2504.sample-list.txt"

ref_KGP_sample_dt = {}
ref_KGP_sample_list = []
with open(ref_sample_path) as file:
    for line in file:
        sample = line.strip().split("_")[0]
        ref_KGP_sample_list.append(sample)
        ref_KGP_sample_dt[sample] = ""


###001-get KGP sample extra geno
ref_gene_copy_list = ["PRSS1","PRSS3P1","PRSS3P2","TRY7","PRSS2"]
ref_pop_list = []
ref_pop_dt = {}
ref_sample_list = []
ref_sample_pop_dt = {}
ref_sample_gene_copy_geno_dt = {}
line_nu = 0
ref_path = "/picb/humpopg-bigdata/xiebo/NGS/reference/PRSS_bam/PRSS_copy/KGP_HGDP.PRSS1_5copy.genotype.refGRCH38_ALT.remapping.bedcov.beta.txt"
with open(ref_path) as file:
    for line in file:
        line_nu += 1
        if line_nu == 1:
            pass
        else:
            j = line.strip().split()
            sample = j[0]
            pop = j[1]
            gene_copy = j[2]
            geno = j[-1]
            if sample in ref_KGP_sample_dt:
                if gene_copy == "PRSS1":
                    ref_sample_list.append(sample)
                    if pop not in ref_pop_dt:
                        ref_pop_dt[pop] = []
                        ref_pop_dt[pop].append(sample)
                        ref_pop_list.append(pop)
                    else:
                        ref_pop_dt[pop].append(sample)
                if sample not in ref_sample_gene_copy_geno_dt:
                    ref_sample_gene_copy_geno_dt[sample] = {}
                    ref_sample_gene_copy_geno_dt[sample][gene_copy] = int(geno)
                else:
                    ref_sample_gene_copy_geno_dt[sample][gene_copy] = int(geno)
print(ref_pop_list)
print("KGP_pop_nu = " + str(len(ref_pop_list)))
ref_sample_geno_dt = {}
for pop in ref_pop_list:
    ref_tmp_sample_list = ref_pop_dt[pop]
    for sample in ref_tmp_sample_list:
        PRSS1_copy = ref_sample_gene_copy_geno_dt[sample]["PRSS1"]
        PRSS3P1_copy = ref_sample_gene_copy_geno_dt[sample]["PRSS3P1"]
        PRSS3P2_copy = ref_sample_gene_copy_geno_dt[sample]["PRSS3P2"]
        TRY7_copy = ref_sample_gene_copy_geno_dt[sample]["TRY7"]
        PRSS2_copy = ref_sample_gene_copy_geno_dt[sample]["PRSS2"]
        if (PRSS1_copy == 1) or (PRSS3P1_copy == 1) or (PRSS2_copy == 1):
            pass
        else:
            if (PRSS3P2_copy == 0) and (TRY7_copy == 0):
                ref_sample_geno_dt[sample] = "0/0"
            elif (PRSS3P2_copy == 1) and (TRY7_copy == 1):
                ref_sample_geno_dt[sample] = "0/1"
            elif (PRSS3P2_copy == 2) and (TRY7_copy == 2):
                ref_sample_geno_dt[sample] = "1/1"

fout_result_list = []
for pop in ref_pop_list:
    ref_tmp_sample_list = ref_pop_dt[pop]
    for sample in ref_tmp_sample_list:
        if sample in ref_sample_geno_dt:
            geno = ref_sample_geno_dt[sample]
            result = (sample,pop,geno)
            fout_result_list.append(result)


def prepare_vcf(pop):
    print(pop)
    for chr in ref_chr_list:
        ref_vcf_path = "/picb/humpopg-bigdata/archive/20200308-KGPp3-GRCh38/vcf_PASS/CCDG_13607_B01_GRM_WGS_2019-02-19_" + chr + ".recalibrated_variants.PASS.vcf.gz"
        ref_sample_path = "/picb/humpopg-bigdata/xiebo/NGS/reference/PRSS_bam/KGP_variants/tmp_file/" + pop + ".txt"
        fout_vcf_path = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/008-PRSS_ihs/reference/" + pop + "." + chr + ".recalibrated_variants.PASS.vcf.gz"
        os.system("bcftools view -m2 -M2 --force-samples -S %s --threads 20 %s |bgzip -@20 -c > %s" %(ref_sample_path,ref_vcf_path,fout_vcf_path))


#pool = multiprocessing.Pool(processes=15)
#pool.map(prepare_vcf,ref_pop_list)
#pool.close()
#pool.join()



def add_PRSS_vcf(pop):
    print(pop)
    ref_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/008-PRSS_ihs/reference/"
    fout_line_list = []
    ref_sample_index_dt = {}
    ref_vcf_path = ref_prefix + pop + ".chr7.recalibrated_variants.PASS.vcf.gz"
    with gzip.open(ref_vcf_path) as file:
        for line in file:
            val = line.strip()
            if val.count("#") == 2:
                fout_line_list.append(line)
            elif val.count("#") == 1:
                j = line.strip().split()
                fout_line_list.append(line)
                tmp_sample_list = j[9:]
                tmp_PRSS_geno_list = []
                for sample in tmp_sample_list:
                    geno = ref_sample_geno_dt[sample]
                    tmp_PRSS_geno_list.append(geno)
            else:
                j = line.strip().split()
                chr = j[0]
                pos = j[1]
                ref = j[3]
                alt = j[4]
                if pos == "142767932":
                    result = ["chr7","142767940","chr7-142767940-PRSS","G","T",".",".",".","GT"] + tmp_PRSS_geno_list
                    fout_line_list.append("\t".join(result) + "\n")
                else:
                    tmp_geno_list = []
                    for geno in j[9:]:
                        geno = geno.split(":")[0]
                        tmp_geno_list.append(geno)
                    if (tmp_geno_list.count("0/1") + tmp_geno_list.count("1/1")) > 0:
                        if (len(ref) == len(alt)) and (len(alt) == 1):
                            ID = chr + "-" + pos + "-SNP"
                        else:
                            ID = chr + "-" + pos + "-INDEL"
                        j[2] = ID 
                        fout_line_list.append("\t".join(j) + "\n")

    fout_path = ref_prefix + pop + ".chr7.recalibrated_variants.add_PRSS_geno.PASS.vcf"
    fout_file = open(fout_path,"w")
    for line in fout_line_list:
        fout_file.write(line)
    fout_file.close()
    os.system("bgzip %s" %(fout_path))
    os.system("tabix -p vcf %s.gz" %(fout_path))

#add_PRSS_vcf("CHB")
#pool = multiprocessing.Pool(processes=15)
#pool.map(add_PRSS_vcf,ref_pop_list)
#pool.close()
#pool.join()

def add_PRSS_vcf_beta(pop):
    print(pop)
    add_PRSS_nu = 0
    ref_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/008-PRSS_ihs/reference/"
    fout_line_list = []
    ref_sample_index_dt = {}
    ref_vcf_path = ref_prefix + pop + ".chr7.recalibrated_variants.PASS.vcf.gz"
    with gzip.open(ref_vcf_path) as file:
        for line in file:
            val = line.strip()
            if val.count("#") == 2:
                fout_line_list.append(line)
            elif val.count("#") == 1:
                j = line.strip().split()
                fout_line_list.append(line)
                tmp_sample_list = j[9:]
                tmp_PRSS_geno_list = []
                for sample in tmp_sample_list:
                    geno = ref_sample_geno_dt[sample]
                    tmp_PRSS_geno_list.append(geno)
            else:
                j = line.strip().split()
                chr = j[0]
                pos = j[1]
                ref = j[3]
                alt = j[4]
                if 142746720 <= int(pos) <= 142778572:
                    if add_PRSS_nu == 0:
                        result = ["chr7","142767940","chr7-142767940-PRSS","G","T",".",".",".","GT"] + tmp_PRSS_geno_list
                        fout_line_list.append("\t".join(result) + "\n")
                        add_PRSS_nu += 1 
                else:
                    tmp_geno_list = []
                    for geno in j[9:]:
                        geno = geno.split(":")[0]
                        tmp_geno_list.append(geno)
                    if (tmp_geno_list.count("0/1") + tmp_geno_list.count("1/1")) > 0:
                        if (len(ref) == len(alt)) and (len(alt) == 1):
                            ID = chr + "-" + pos + "-SNP"
                        else:
                            ID = chr + "-" + pos + "-INDEL"
                        j[2] = ID 
                        fout_line_list.append("\t".join(j) + "\n")

    fout_path = ref_prefix + pop + ".chr7.recalibrated_variants.add_PRSS_geno.PASS.beta.vcf"
    fout_file = open(fout_path,"w")
    for line in fout_line_list:
        fout_file.write(line)
    fout_file.close()
    os.system("bgzip %s" %(fout_path))
    os.system("tabix -p vcf %s.gz" %(fout_path))

pool = multiprocessing.Pool(processes=15)
pool.map(add_PRSS_vcf_beta,ref_pop_list)
pool.close()
pool.join()


###run shapeit4
def run_chr7_shapeit4_beta(pop):
    print(pop)
    chr = "chr7"
    ref_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/008-PRSS_ihs/reference/"
    ref_input_map = "/picb/humpopg-bigdata5/wangyimin/resource/genetic_map_hg38/genetic_map_GRCh38_" + chr
    ref_input_vcf = ref_prefix + pop + "." + chr + ".recalibrated_variants.add_PRSS_geno.PASS.beta.vcf.gz"
    fout_vcf = ref_prefix + pop + ".chr7.recalibrated_variants.add_PRSS_geno.PASS.phased.beta.vcf.gz"
    fout_log = ref_prefix + pop + ".chr7.recalibrated_variants.add_PRSS_geno.PASS.phased.beta.log"
    os.system("shapeit4 --input %s --map %s --region %s --thread 20 --output %s --sequencing > %s" %(ref_input_vcf,ref_input_map,chr,fout_vcf,fout_log))

pool = multiprocessing.Pool(processes=15)
pool.map(run_chr7_shapeit4_beta,ref_pop_list)
pool.close()
pool.join()

def run_shapeit4(pop):
    print(pop)
    ref_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/008-PRSS_ihs/reference/"
    for chr in ref_chr_list:
        ref_input_map = "/picb/humpopg-bigdata5/wangyimin/resource/genetic_map_hg38/genetic_map_GRCh38_" + chr
        if chr == "chr7":
            ref_input_vcf = ref_prefix + pop + "." + chr + ".recalibrated_variants.add_PRSS_geno.PASS.vcf.gz"
            fout_vcf = ref_prefix + pop + ".chr7.recalibrated_variants.add_PRSS_geno.PASS.phased.vcf.gz"
            fout_log = ref_prefix + pop + ".chr7.recalibrated_variants.add_PRSS_geno.PASS.phased.log"
            os.system("shapeit4 --input %s --map %s --region %s --thread 20 --output %s --sequencing > %s" %(ref_input_vcf,ref_input_map,chr,fout_vcf,fout_log))
        else:
            ref_input_vcf = ref_prefix + pop + "." + chr + ".recalibrated_variants.PASS.vcf.gz"
            if os.path.exists(ref_input_vcf + ".tbi"):
                pass
            else:
                os.system("tabix -p vcf %s" %(ref_input_vcf))
            fout_vcf = ref_prefix + pop + "." + chr + ".recalibrated_variants.PASS.phased.vcf.gz"
            fout_log = ref_prefix + pop + "." + chr + ".recalibrated_variants.PASS.phased.log"
            os.system("shapeit4 --input %s --map %s --region %s --thread 20 --output %s --sequencing > %s" %(ref_input_vcf,ref_input_map,chr,fout_vcf,fout_log))

#run_shapeit4("CHB")
#pool = multiprocessing.Pool(processes=15)
#pool.map(run_shapeit4,ref_pop_list)
#pool.close()
#pool.join()


#prepare rehh vcf
def prepare_PRSS_extend_vcf(pop):
    print(pop)
    ref_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/008-PRSS_ihs/reference/"
    PRSS_extend_area = "chr7:142650000-142860000"
    ref_path = ref_prefix + pop + ".chr7.recalibrated_variants.add_PRSS_geno.PASS.phased.vcf.gz"
    ref_tbi_path = ref_prefix + pop + ".chr7.recalibrated_variants.add_PRSS_geno.PASS.phased.vcf.gz.tbi"
    if os.path.exists(ref_tbi_path):
        pass
    else:
        os.system("tabix -p vcf %s" %(ref_path))
    fout_path = ref_prefix + pop + ".chr7.recalibrated_variants.add_PRSS_geno.chr7-142650000-142860000.PASS.phased.vcf"
    os.system("tabix -h %s %s > %s" %(ref_path,PRSS_extend_area,fout_path))
    os.system("bgzip %s" %(fout_path))
    os.system("tabix -p vcf %s.gz" %(fout_path))

#pool = multiprocessing.Pool(processes=10)
#pool.map(prepare_PRSS_extend_vcf,ref_pop_list)
#pool.close()
#pool.join()



def prepare_PRSS_extend_vcf_beta(pop):
    print(pop)
    ref_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/008-PRSS_ihs/reference/"
    PRSS_extend_area = "chr7:142650000-142860000"
    ref_path = ref_prefix + pop + ".chr7.recalibrated_variants.add_PRSS_geno.PASS.phased.beta.vcf.gz"
    ref_tbi_path = ref_prefix + pop + ".chr7.recalibrated_variants.add_PRSS_geno.PASS.phased.beta.vcf.gz.tbi"
    if os.path.exists(ref_tbi_path):
        pass
    else:
        os.system("tabix -p vcf %s" %(ref_path))
    fout_path = ref_prefix + pop + ".chr7.recalibrated_variants.add_PRSS_geno.chr7-142650000-142860000.PASS.phased.beta.vcf"
    os.system("tabix -h %s %s > %s" %(ref_path,PRSS_extend_area,fout_path))
    os.system("bgzip %s" %(fout_path))
    os.system("tabix -p vcf %s.gz" %(fout_path))

pool = multiprocessing.Pool(processes=10)
pool.map(prepare_PRSS_extend_vcf_beta,ref_pop_list)
pool.close()
pool.join()

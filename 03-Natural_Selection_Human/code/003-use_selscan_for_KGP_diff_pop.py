#coding:utf-8
#2021-12-23

import os 
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

def use_chr7_selscan(pop):
    print(pop)
    ref_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/008-PRSS_ihs/reference/"
    fout_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/008-PRSS_ihs/results/"
    ref_vcf = ref_prefix + pop + ".chr7.recalibrated_variants.add_PRSS_geno.PASS.phased.vcf.gz"
    ref_map = ref_prefix + pop + ".chr7.map.gz"
    out_ihs = fout_prefix + pop + ".chr7"
    out_log = fout_prefix + pop + ".chr7.logerr"
    os.system("selscan --ihs --vcf %s --map %s --out %s --threads 50 >& %s" %(ref_vcf,ref_map,out_ihs,out_log))
    os.system("norm --ihs --files %s.ihs.out" %(out_ihs))

def use_chr7_selscan_beta(pop):
    print(pop)
    ref_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/008-PRSS_ihs/reference/"
    fout_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/008-PRSS_ihs/results/" + pop + "/beta/"
    os.system("mkdir -p %s" %(fout_prefix))
    ref_vcf = ref_prefix + pop + ".chr7.recalibrated_variants.add_PRSS_geno.PASS.phased.beta.vcf.gz"
    ref_map = ref_prefix + pop + ".chr7.beta.map.gz"
    out_ihs = fout_prefix + pop + ".chr7"
    out_log = fout_prefix + pop + ".chr7.logerr"
    os.system("selscan --ihs --vcf %s --map %s --out %s --threads 20 >& %s" %(ref_vcf,ref_map,out_ihs,out_log))
    os.system("norm --ihs --files %s.ihs.out" %(out_ihs))

pool = multiprocessing.Pool(processes=15)
pool.map(use_chr7_selscan_beta,ref_pop_list)
pool.close()
pool.join()

def use_selscan(pop):
    print(pop)
    for chr in ref_chr_list:
        ref_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/008-PRSS_ihs/reference/"
        fout_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/008-PRSS_ihs/results/" + pop + "/"
        if os.path.exists(fout_prefix):
            pass
        else:
            os.system("mkdir -p %s" %(fout_prefix))
        if chr == "chr7":
            ref_vcf = ref_prefix + pop + "." + chr + ".recalibrated_variants.add_PRSS_geno.PASS.phased.vcf.gz"
        else:
            ref_vcf = ref_prefix + pop + "." + chr + ".recalibrated_variants.PASS.phased.vcf.gz"
        ref_map = ref_prefix + pop + "." + chr + ".map.gz"
        out_ihs = fout_prefix + pop + "." + chr
        out_log = fout_prefix + pop + "." + chr + ".logerr"
        os.system("selscan --ihs --vcf %s --map %s --out %s --threads 20 >& %s" %(ref_vcf,ref_map,out_ihs,out_log))
    #os.system("norm --ihs --files %s*.ihs.out" %(fout_prefix))

#use_selscan("CHB")
#pool = multiprocessing.Pool(processes=15)
#pool.map(use_selscan,ref_pop_list)
#pool.close()
#pool.join()

#selscan --ihs --vcf %s --map %s --out %s --threads 20 >&
#norm --ihs --files *.ihs.out

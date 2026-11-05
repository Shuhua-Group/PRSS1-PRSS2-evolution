#coding:utf-8
#2021-12-23


import os 
import gzip
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

def prepare_chr7_map(pop):
    print(pop)
    chr = "chr7"
    ref_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/008-PRSS_ihs/reference/"
    run_script = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/tools/10Tujia_40Han_iHS/cal.gen.dis.py"
    ref_vcf = ref_prefix + pop + ".chr7.recalibrated_variants.add_PRSS_geno.PASS.phased.vcf.gz"
    ref_genetic_map = "/picb/humpopg-bigdata5/wangyimin/resource/genetic_map_hg38/genetic_map_GRCh38_chr7"
    fout_map = ref_prefix + pop + ".chr7.map.gz"
    if os.path.exists(fout_map):
        os.system("rm %s" %(fout_map))
    os.system("/picb/humpopg/xiebo/conda/envs/py36/bin/python %s %s %s %s %s" %(run_script,ref_vcf,ref_genetic_map,fout_map,chr))

def prepare_chr7_map_beta(pop):
    print(pop)
    chr = "chr7"
    ref_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/008-PRSS_ihs/reference/"
    run_script = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/tools/10Tujia_40Han_iHS/cal.gen.dis.py"
    ref_vcf = ref_prefix + pop + ".chr7.recalibrated_variants.add_PRSS_geno.PASS.phased.beta.vcf.gz"
    ref_genetic_map = "/picb/humpopg-bigdata5/wangyimin/resource/genetic_map_hg38/genetic_map_GRCh38_chr7"
    fout_map = ref_prefix + pop + ".chr7.beta.map.gz"
    if os.path.exists(fout_map):
        os.system("rm %s" %(fout_map))
    os.system("/picb/humpopg/xiebo/conda/envs/py36/bin/python %s %s %s %s %s" %(run_script,ref_vcf,ref_genetic_map,fout_map,chr))

pool = multiprocessing.Pool(processes=10)
pool.map(prepare_chr7_map_beta,ref_pop_list)
pool.close()
pool.join()


def prepare_map_v1(pop):
    print(pop)
    for chr in ref_chr_list:
        ref_prefix = "/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/008-PRSS_ihs/reference/"
        if chr == "chr7":
            ref_path = ref_prefix + pop + "." + chr + ".recalibrated_variants.add_PRSS_geno.PASS.phased.vcf.gz"
        else:
            ref_path = ref_prefix + pop + "." + chr + ".recalibrated_variants.PASS.phased.vcf.gz"
        fout_map = ref_prefix + pop + "." + chr + ".map"
        if os.path.exists(fout_map + ".gz"):
            os.system("rm %s.gz" %(fout_map))
        fout_file = open(fout_map,"w")
        with gzip.open(ref_path) as file:
            for line in file:
                val = line.strip()
                if val.count("#") != 0:
                    pass
                else:
                    j = line.strip().split()
                    chr = j[0]
                    pos = j[1]
                    ID = j[2]
                    genetic_pos = float(pos)/1000000
                    result = (chr,ID+":"+pos,str(genetic_pos),pos)
                    fout_file.write("\t".join(result) + "\n")
        fout_file.close()
        os.system("bgzip %s" %(fout_map))

#prepare_map_v1("CHB")
#pool = multiprocessing.Pool(processes=10)
#pool.map(prepare_map_v1,ref_pop_list)
#pool.close()
#pool.join()



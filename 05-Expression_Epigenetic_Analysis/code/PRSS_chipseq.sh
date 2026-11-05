025-下载hicpro NA12878 GM biological replicate 数据
####################################################################
数据网址：https://www.ncbi.nlm.nih.gov/sra/?term=hichip+gm12878
数据下载路径：/picb/humpopg-bigdata/xiebo/NGS/reference/HiC_data/hicpro/NA12878/GM_biological_replicate/

使用命令
##############
nohup wget -c https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR3467178/SRR3467178 & (gate2)
nohup wget -c https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR3467177/SRR3467177 & (gate2)
nohup wget -c https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR3467176/SRR3467176 & (gate1)
nohup wget -c https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR3467175/SRR3467175 & (gate1)

pfastq-dump -t 16 -s SRR3467175.sra --split-3 --gzip -O ./ 
pfastq-dump -t 16 -s SRR3467176.sra --split-3 --gzip -O ./ 
pfastq-dump -t 16 -s SRR3467177.sra --split-3 --gzip -O ./ 
pfastq-dump -t 16 -s SRR3467178.sra --split-3 --gzip -O ./ 


026-下载NA07037 和 NA20540 的chipseq数据
####################################################################
数据网址：https://www.ebi.ac.uk/arrayexpress/experiments/E-MTAB-3657/samples/?full=true&s_sortby=col_7&s_sortorder=ascending&s_page=1&s_pagesize=25
数据下载路径：/picb/humpopg-bigdata/xiebo/NGS/reference/Chipseq/

样本信息：wget -c --no-check-certificate https://www.ebi.ac.uk/arrayexpress/files/E-MTAB-3657/E-MTAB-3657.sdrf.txt

NA07037 chip-seq (gate2.icb.ac.cn)
###################
H3K27ac: nohup wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR318/007/ERR3189097/ERR3189097.fastq.gz &
H3K4me1: nohup wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR318/008/ERR3189098/ERR3189098.fastq.gz &
H3K4me3: nohup wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR318/009/ERR3189099/ERR3189099.fastq.gz &    
PU.1: nohup wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR318/000/ERR3189100/ERR3189100.fastq.gz &
RPB2: nohup wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR318/001/ERR3189101/ERR3189101.fastq.gz &    

NA12287 chip-seq (gate1.icb.ac.cn)
###################
H3K27ac: nohup wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR318/007/ERR3189247/ERR3189247.fastq.gz &
H3K4me1: nohup wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR318/008/ERR3189248/ERR3189248.fastq.gz &
H3K4me3: nohup wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR318/009/ERR3189249/ERR3189249.fastq.gz &
PU.1: nohup wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR318/000/ERR3189250/ERR3189250.fastq.gz &
RPB2: nohup wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR318/001/ERR3189251/ERR3189251.fastq.gz &


027-下载NA12878 的chia-pet数据
####################################################################
数据网址：https://www.ncbi.nlm.nih.gov/sra/?term=chia-pet+gm12878
数据路径：/picb/humpopg-bigdata/xiebo/NGS/reference/chia-pet/NA12878/

nohup wget -c https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR8659674/SRR8659674 & (gate1)
nohup wget -c https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR8659672/SRR8659672 & (gate1)
nohup wget -c https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR8659673/SRR8659673 & (gate2)
nohup wget -c https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR8659594/SRR8659594 & (gate2)
nohup wget -c https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR8659593/SRR8659593 & (gate2)


pfastq-dump -t 16 -s SRR8659593.sra --split-3 --gzip -O ./
pfastq-dump -t 12 -s SRR8659594.sra --split-3 --gzip -O ./
pfastq-dump -t 16 -s SRR8659672.sra --split-3 --gzip -O ./
pfastq-dump -t 16 -s SRR8659673.sra --split-3 --gzip -O ./
pfastq-dump -t 16 -s SRR8659674.sra --split-3 --gzip -O ./

029-下载Het_3_5_copy、Hom_3copy、Hom_5copy的样本的chipseq数据（各五个样本）
##############################################################################
############################
Het_3_5_copy chipseq (gate1)
############################
NA06985 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA06985.H3K27ac.sh &
nohup sh NA06985.H3K4me1.sh &
nohup sh NA06985.H3K4me3.sh &

NA06986 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA06986.H3K27ac.sh &
nohup sh NA06986.H3K4me1.sh &
nohup sh NA06986.H3K4me3.sh &

NA06994 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA06994.H3K27ac.sh &
nohup sh NA06994.H3K4me1.sh &
nohup sh NA06994.H3K4me3.sh &

NA07357 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA07357.H3K27ac.sh &
nohup sh NA07357.H3K4me1.sh &
nohup sh NA07357.H3K4me3.sh &

NA10847 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA10847.H3K27ac.sh &
nohup sh NA10847.H3K4me1.sh &
nohup sh NA10847.H3K4me3.sh &

############################
Hom_3copy chipseq (gate2)
############################
NA11829 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA11829.H3K27ac.sh &
nohup sh NA11829.H3K4me1.sh &
nohup sh NA11829.H3K4me3.sh &

NA11918 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA11918.H3K27ac.sh &
nohup sh NA11918.H3K4me1.sh &
nohup sh NA11918.H3K4me3.sh &

NA12812 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA12812.H3K27ac.sh &
nohup sh NA12812.H3K4me1.sh &
nohup sh NA12812.H3K4me3.sh &

NA20502 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA20502.H3K27ac.sh &
nohup sh NA20502.H3K4me1.sh &
nohup sh NA20502.H3K4me3.sh &

NA20519 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA20519.H3K27ac.sh &
nohup sh NA20519.H3K4me1.sh &
nohup sh NA20519.H3K4me3.sh &

NA20521 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA20521.H3K27ac.sh &
nohup sh NA20521.H3K4me1.sh &
nohup sh NA20521.H3K4me3.sh &

NA20540 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA20540.H3K27ac.sh &
nohup sh NA20540.H3K4me1.sh &
nohup sh NA20540.H3K4me3.sh &

############################
Hom_3copy chipseq (gate1、gate2)
############################
NA07048 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA07048.H3K27ac.sh &
nohup sh NA07048.H3K4me1.sh &
nohup sh NA07048.H3K4me3.sh &

NA07051 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA07051.H3K27ac.sh &
nohup sh NA07051.H3K4me1.sh &
nohup sh NA07051.H3K4me3.sh &

NA07056 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA07056.H3K27ac.sh &
nohup sh NA07056.H3K4me1.sh &
nohup sh NA07056.H3K4me3.sh &

NA10851 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA10851.H3K27ac.sh &
nohup sh NA10851.H3K4me1.sh &
nohup sh NA10851.H3K4me3.sh &

NA11830 (H3K27ac、H3K4me1、H3K4me3)
###############
nohup sh NA11830.H3K27ac.sh &
nohup sh NA11830.H3K4me1.sh &
nohup sh NA11830.H3K4me3.sh &


030-使用mummer比对CHM13和GRCh38 primary ，NA12878和GRCh38 ALT
####################################################################
结果目录
##########
CHM13: /picb/humpopg-bigdata/xiebo/NGS/EAGLE_test/CHM13/CHM13_add_PRSS1_pathogenic_snps/reference/mummer
NA12878: /picb/humpopg-bigdata/xiebo/NGS/EAGLE_test/NA12878/NA12878_add_PRSS1_pathogenic_snps/reference/mummer


CHM13
##############################
CHM13 : chr7:144082438-144154290
GRCh38 : 7:142726720-142798572

samtools faidx /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/reference/CHM13/chm13.draft_v1.1.fasta chr7:144082438-144154290 > chm13.PRSS_extend.fasta
samtools faidx /picb/humpopg-bigdata5/xiebo/SV_calling/reference/b38_No_ALT/Homo_sapiens.GRCh38.dna.primary_assembly.fa 7:142726720-142798572 > GRCh38.PRSS_extend.fasta

samtools faidx chm13.PRSS_extend.fasta
samtools faidx GRCh38.PRSS_extend.fasta

nucmer chm13.PRSS_extend.fasta GRCh38.PRSS_extend.fasta -p CHM13.refGRCh38_primary.extend
mummerplot -postscript -p CHM13.refGRCh38_primary.extend CHM13.refGRCh38_primary.extend.delta
gnuplot CHM13.refGRCh38_primary.extend.gp

nucmer GRCh38.PRSS_extend.fasta chm13.PRSS_extend.fasta -p GRCh38_primary.ref_CHM13.extend
mummerplot -postscript -p GRCh38_primary.ref_CHM13.extend GRCh38_primary.ref_CHM13.extend.delta
gnuplot GRCh38_primary.ref_CHM13.extend.gp


NA12878
##############################
NA12878 : CM009453.1:143508012-143560162
GRCh38 ALT PRSS：chr7_KI270803v1_alt:749409-801557

samtools faidx /picb/humpopg-bigdata/xiebo/NGS/EAGLE_test/reference/NA12878/GCA_002077035.3_NA12878_prelim_3.0_genomic.fna CM009453.1:143488012-143580162 > NA12878.PRSS_extend.fasta

samtools faidx /picb/humpopg-bigdata5/AAGC/bundle/02.reference_genomes/GRCh38_full_analysis_set_plus_decoy_hla.fa chr7_KI270803v1_alt:729409-821557 > GRCh38_ALT.PRSS_extend.fasta

samtools faidx NA12878.PRSS_extend.fasta
samtools faidx GRCh38_ALT.PRSS_extend.fasta

nucmer GRCh38_ALT.PRSS_extend.fasta NA12878.PRSS_extend.fasta -p GRCh38_ALT.ref_NA12878.extend
delta-filter -i 95 -l 1000 -1 GRCh38_ALT.ref_NA12878.extend.delta > GRCh38_ALT.ref_NA12878.extend.flt.delta
mummerplot -postscript -p GRCh38_ALT.ref_NA12878.extend GRCh38_ALT.ref_NA12878.extend.flt.delta
gnuplot GRCh38_ALT.ref_NA12878.extend.gp

####GRCh38_ALT NA12878
nucmer GRCh38_ALT.PRSS_extend.fasta NA12878.PRSS_extend.fasta -p GRCh38_ALT.ref_NA12878.extend
delta-filter -i 95 -l 1000 -1 GRCh38_ALT.ref_NA12878.extend.delta > GRCh38_ALT.ref_NA12878.extend.flt.delta
mummerplot -postscript -p GRCh38_ALT.ref_NA12878.extend GRCh38_ALT.ref_NA12878.extend.flt.delta
gnuplot GRCh38_ALT.ref_NA12878.extend.gp


####NA12878 CHM13
nucmer NA12878.PRSS_extend.fasta chm13.PRSS_extend.fasta -p NA12878.ref_CHM13.extend
delta-filter -1 NA12878.ref_CHM13.extend.delta > NA12878.ref_CHM13.extend.flt.delta
show-coords -cdlqoTH NA12878.ref_CHM13.extend.flt.delta > NA12878.ref_CHM13.extend.flt.coords
show-coords -cdlqoTH NA12878.ref_CHM13.extend.delta > NA12878.ref_CHM13.extend.coords
mummerplot -postscript -p NA12878.ref_CHM13.extend.flt NA12878.ref_CHM13.extend.flt.delta
gnuplot NA12878.ref_CHM13.extend.flt.gp


####GRCh38_primary GRCh38_ALT
nucmer GRCh38.PRSS_extend.fasta GRCh38_ALT.PRSS_extend.fasta -p GRCh38_primary.GRCh38_ALT.extend
delta-filter -1 GRCh38_primary.GRCh38_ALT.extend.delta > GRCh38_primary.GRCh38_ALT.extend.flt.delta
show-coords -cdlqoTH GRCh38_primary.GRCh38_ALT.extend.flt.delta > GRCh38_primary.GRCh38_ALT.extend.flt.coords
mummerplot -postscript -p GRCh38_primary.GRCh38_ALT.extend.flt GRCh38_primary.GRCh38_ALT.extend.flt.delta
gnuplot GRCh38_primary.GRCh38_ALT.extend.flt.gp

####GRCh38_ALT GRCh38_primary
nucmer GRCh38_ALT.PRSS_extend.fasta GRCh38.PRSS_extend.fasta  -p GRCh38_ALT.GRCh38_primary.extend
delta-filter -1 GRCh38_ALT.GRCh38_primary.extend.delta > GRCh38_ALT.GRCh38_primary.extend.flt.delta
show-coords -cdlqoTH GRCh38_ALT.GRCh38_primary.extend.flt.delta > GRCh38_ALT.GRCh38_primary.extend.flt.coords
mummerplot -postscript -p GRCh38_ALT.GRCh38_primary.extend.flt GRCh38_ALT.GRCh38_primary.extend.flt.delta
gnuplot GRCh38_ALT.GRCh38_primary.extend.flt.gp


####GRCh38_primary GRCh38_ALT (just PRSS)
nucmer --mum -b 30 GRCh38.PRSS.fasta GRCh38_ALT.PRSS.fasta -p GRCh38_primary.GRCh38_ALT
delta-filter -l 5000 -1 GRCh38_primary.GRCh38_ALT.delta > GRCh38_primary.GRCh38_ALT.flt.delta
show-coords -cdlqoT GRCh38_primary.GRCh38_ALT.delta > GRCh38_primary.GRCh38_ALT.coords
show-coords -cdlqoT GRCh38_primary.GRCh38_ALT.flt.delta > GRCh38_primary.GRCh38_ALT.flt.coords
mummerplot -postscript -p GRCh38_primary.GRCh38_ALT.flt GRCh38_primary.GRCh38_ALT.flt.delta
gnuplot GRCh38_primary.GRCh38_ALT.flt.gp


031-下载GRCh38 Refseq_function_elements 文件
####################################################################
下载结果：/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/002-PRSS_evalution/reference/008-GRCh38_genome/GRCh38.Refseq_function_elements.txt




023-下载 NA19239 NA11830 数据
#################################
数据网址：https://www.ebi.ac.uk/arrayexpress/experiments/E-MTAB-1884/samples/?s_page=3&s_pagesize=25
数据路径
#################
/picb/humpopg-bigdata/xiebo/NGS/reference/Chipseq/Hom_5copy/NA19239
/picb/humpopg-bigdata/xiebo/NGS/reference/Chipseq/Hom_5copy/NA11830_rep1

数据链接
############################
nohup wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR356/ERR356929/ERR356929.fastq.gz & (NA19239)
nohup wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR356/ERR356864/ERR356864.fastq.gz & (NA11830_rep1)


024-为NA12878样本的gff文件添加PRSS3P2基因的转录本信息
##################################################################
结果路径：/picb/humpopg-bigdata/xiebo/NGS/liftoff/result/GRCh38_gene_convert/NA12878

samtools faidx /picb/humpopg-bigdata/xiebo/NGS/EAGLE_test/reference/NA12878/GCA_002077035.3_NA12878_prelim_3.0_genomic.fna CM009453.1 > /picb/humpopg-bigdata/xiebo/NGS/liftoff/result/GRCh38_gene_convert/NA12878/NA12878.CM009453.1.fasta
samtools faidx /picb/humpopg-bigdata/xiebo/NGS/liftoff/result/GRCh38_gene_convert/NA12878/NA12878.CM009453.1.fasta

lastz /picb/humpopg-bigdata/xiebo/NGS/liftoff/result/GRCh38_gene_convert/NA12878/NA12878.CM009453.1.fasta /picb/humpopg-bigdata/xiebo/NGS/Polyester_test/reference/GRCh38/PRSS3P2.transcript.seq.fa --format=mapping > NA12878_PRSS3P2.transcript_pos.txt


NA12878 -- PRSS3P2 -- (CM009453.1:143532188-143535711)
CHR_HSCHR7_2_CTG6 -- PRSS3P2 -- (142811706-142815230)

CHR_HSCHR7_2_CTG6
#################################
exon-1 : 142811706-142811745 (39)
exon-2 : 142812775-142812934 (159)
exon-3 : 142813993-142814246 (253)
exon-4 : 142814642-142814778 (136)
exon-5 : 142815078-142815230 (152)

NA12878_CM009453.1
#################################
exon-1 : 143532188-143532227
exon-2 : 143533257-143533416
exon-3 : 143534475-143534728
exon-4 : 143535123-143535259
exon-5 : 143535559-143535711

CM009453.1  Liftoff transcript  143532188   143535711   .   +   .   transcript_id "rna-NR_001296.3.1"; gene_id "gene-PRSS3P2.1"; gene_name "PRSS3P2"
CM009453.1  Liftoff exon    143532188   143532227   .   +   .   transcript_id "rna-NR_001296.3.1"; gene_id "gene-PRSS3P2.1"; gene_name "PRSS3P2";
CM009453.1  Liftoff exon    143533257   143533416   .   +   .   transcript_id "rna-NR_001296.3.1"; gene_id "gene-PRSS3P2.1"; gene_name "PRSS3P2";
CM009453.1  Liftoff exon    143534475   143534728   .   +   .   transcript_id "rna-NR_001296.3.1"; gene_id "gene-PRSS3P2.1"; gene_name "PRSS3P2";
CM009453.1  Liftoff exon    143535123   143535259   .   +   .   transcript_id "rna-NR_001296.3.1"; gene_id "gene-PRSS3P2.1"; gene_name "PRSS3P2";
CM009453.1  Liftoff exon    143535559   143535711   .   +   .   transcript_id "rna-NR_001296.3.1"; gene_id "gene-PRSS3P2.1"; gene_name "PRSS3P2";


##HOMER summary output
subString <- function(strings, idx, sep = NA){

    strings = as.character(strings)
    if(is.na(sep)){
        res = as.character(lapply(strings, function(x) paste(strsplit(x, "")[[1]][idx], collapse = "")))
    } else{
        res = sapply(strsplit(strings, sep), function(x) x[idx])
    }
    return(res)
}

summaryHomer <- function(outFolder){

    homerFolder = paste0(outFolder, "/homerResults")
    xFiles = list.files(homerFolder, ".motif$")
    xFiles = xFiles[-grep("similar", xFiles)]
    xFiles = xFiles[-grep("RV", xFiles)]
    xFiles = xFiles[order(as.numeric(gsub("\\.", "", gsub("motif", "", xFiles))))]
    texts  = sapply(paste0(homerFolder, "/", xFiles), readLines)
    chunks = sapply(texts, function(x) strsplit(x[1], "[\t]"))

    motif = sapply(chunks, function(x) subString(x[1], 2, ">"))
    match = sapply(chunks, function(x) subString(subString(x[2], 2, "BestGuess:"),  1, "/"))
    score = sapply(chunks, function(x) rev(strsplit(x[2], "[()]")[[1]])[1])
    count = sapply(chunks, function(x) subString(x[6], 3, "[T:()]"))
    ratio = sapply(chunks, function(x) subString(x[6], 2, "[()]"))
    p_value = sapply(chunks, function(x) subString(x[6], 2, "P:"))

    xresT = data.frame(motif, 
                       match, 
                       score = as.numeric(score), 
                       count = as.numeric(count),
                       ratio_perc = as.numeric(gsub("%", "", ratio)), 
                       p_value = as.numeric(p_value)
                       )
    rownames(xresT) = gsub(".motif", "", basename(rownames(xresT)))
    return(xresT)
}

summaryHomer("/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/HOMER_results/")
fout_data <- summaryHomer("/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/HOMER_results/")
write.table(fout_data,file="/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/HOMER_results/NA12878.PRSS_H3K27ac_peaks.HOMER_motifs.txt",sep="\t")
summaryHomer("/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/HOMER_results/test_1/")
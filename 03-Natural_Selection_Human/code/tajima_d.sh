###CHB###
####################
python /picb/humpopg-bigdata5/xiebo/software/Theta_D_H.Est/Theta_D_F_H.py3.py \
    --gzvcf /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/002-vcf/2023samp_remap_MQ50.PRSS1_PRSS3P1_PRSS2.refGRCh38.ancestor.BiAllele.phased.vcf.gz \
    --region /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/003-target_region/PRSS_target_region.bed \
    --samples /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/CHB.txt \
    --haps /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/CHB.PRSS_copy3.hap.txt \
    --outgroup Y \
    --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/CHB.PRSS_copy3.Theta_D_F_H.BiAllele.txt

/picb/humpopg-bigdata5/xiebo/software/Theta_D_H.Est/Theta_D_H.Est \
    --gzvcf /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/002-vcf/2023samp_remap_MQ50.PRSS1_PRSS3P1_PRSS2.refGRCh38.ancestor.phased.vcf.gz \
    --region /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/003-target_region/PRSS_target_region.bed \
    --samples /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/CHB.txt \
    --haps /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/CHB.PRSS_copy3.hap.txt \
    --outgroup Y \
    --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/CHB.PRSS_copy3.Theta_D_F_H.txt

/picb/humpopg-bigdata5/xiebo/software/Theta_D_H.Est/Theta_D_H.Est \
    --gzvcf /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/002-vcf/2023samp_remap_MQ50.PRSS1_PRSS3P1_PRSS2.refGRCh38.ancestor.phased.vcf.gz \
    --region /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/003-target_region/PRSS_target_region.bed \
    --samples /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/CHB.txt \
    --haps /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/CHB.PRSS_copy5.hap.txt \
    --outgroup Y \
    --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/CHB.PRSS_copy5.Theta_D_F_H.txt

###CEU####
####################
/picb/humpopg-bigdata5/xiebo/software/Theta_D_H.Est/Theta_D_H.Est \
    --gzvcf /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/002-vcf/2023samp_remap_MQ50.PRSS1_PRSS3P1_PRSS2.refGRCh38.ancestor.phased.vcf.gz \
    --region /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/003-target_region/PRSS_target_region.bed \
    --samples /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/CEU.txt \
    --haps /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/CEU.PRSS_copy3.hap.txt \
    --outgroup Y \
    --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/CEU.PRSS_copy3.Theta_D_F_H.txt

/picb/humpopg-bigdata5/xiebo/software/Theta_D_H.Est/Theta_D_H.Est \
    --gzvcf /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/002-vcf/2023samp_remap_MQ50.PRSS1_PRSS3P1_PRSS2.refGRCh38.ancestor.phased.vcf.gz \
    --region /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/003-target_region/PRSS_target_region.bed \
    --samples /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/CEU.txt \
    --haps /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/CEU.PRSS_copy5.hap.txt \
    --outgroup Y \
    --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/CEU.PRSS_copy5.Theta_D_F_H.txt

###YRI####
####################
/picb/humpopg-bigdata5/xiebo/software/Theta_D_H.Est/Theta_D_H.Est \
    --gzvcf /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/002-vcf/2023samp_remap_MQ50.PRSS1_PRSS3P1_PRSS2.refGRCh38.ancestor.phased.vcf.gz \
    --region /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/003-target_region/PRSS_target_region.bed \
    --samples /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/YRI.txt \
    --haps /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/YRI.PRSS_copy3.hap.txt \
    --outgroup Y \
    --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/YRI.PRSS_copy3.Theta_D_F_H.txt

/picb/humpopg-bigdata5/xiebo/software/Theta_D_H.Est/Theta_D_H.Est \
    --gzvcf /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/002-vcf/2023samp_remap_MQ50.PRSS1_PRSS3P1_PRSS2.refGRCh38.ancestor.phased.vcf.gz \
    --region /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/003-target_region/PRSS_target_region.bed \
    --samples /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/YRI.txt \
    --haps /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/reference/001-pop/remapping_pop/YRI.PRSS_copy5.hap.txt \
    --outgroup Y \
    --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/009-PRSS_TajimaD/results/001-Theta_D_F_H/YRI.PRSS_copy5.Theta_D_F_H.txt
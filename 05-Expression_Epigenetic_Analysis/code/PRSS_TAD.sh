005-使用HG00513 (3/3), NA18522 (3/5), NA18505 (5/5) 样本的HiC data，然后用HiCexplorer和armatus软件绘图
##########################################################################################
使用数据：/picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/HG00513/output/hic_results/matrix/HG00513/raw
结果路径：/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/


005-01 建立软链接
################################
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/HG00513/output/hic_results/matrix/HG00513/raw/1000/HG00513_1000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/HG00513/1000/HG00513_1000_abs.bed
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/HG00513/output/hic_results/matrix/HG00513/raw/1000/HG00513_1000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/HG00513/1000/HG00513_1000.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/HG00513/output/hic_results/matrix/HG00513/raw/5000/HG00513_5000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/HG00513/5000/HG00513_5000_abs.bed
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/HG00513/output/hic_results/matrix/HG00513/raw/5000/HG00513_5000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/HG00513/5000/HG00513_5000.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/HG00513/output/hic_results/matrix/HG00513/raw/10000/HG00513_10000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/HG00513/10000/HG00513_10000_abs.bed
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/HG00513/output/hic_results/matrix/HG00513/raw/10000/HG00513_10000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/HG00513/10000/HG00513_10000.matrix

ln -s /picb/humpopg-bigdata3/louhaiyi/PRSS2/Hic-Pro/HG00514/merge_HG00514/hic_results/matrix/HG00514/raw/5000/HG00514_5000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/HG00514/5000/HG00514_5000_abs.bed
ln -s /picb/humpopg-bigdata3/louhaiyi/PRSS2/Hic-Pro/HG00514/merge_HG00514/hic_results/matrix/HG00514/raw/5000/HG00514_5000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/HG00514/5000/HG00514_5000.matrix

ln -s /picb/humpopg-bigdata3/louhaiyi/PRSS2/Hic-Pro/HG00514/merge_3copy-hap/hic_results/matrix/HG00514/raw/5000/HG00514_5000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/CHM13_HG00513_HG00514_combined/5000/HG00514_5000.matrix
ln -s /picb/humpopg-bigdata3/louhaiyi/PRSS2/Hic-Pro/HG00514/merge_3copy-hap/hic_results/matrix/HG00514/raw/5000/HG00514_5000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/CHM13_HG00513_HG00514_combined/5000/HG00514_5000_abs.bed

ln -s /picb/humpopg-bigdata3/louhaiyi/PRSS2/Hic-Pro/HG00514/merge_3copy-hap/hic_results/matrix/HG00514/raw/10000/HG00514_10000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/CHM13_HG00513_HG00514_combined/10000/HG00514_10000.matrix
ln -s /picb/humpopg-bigdata3/louhaiyi/PRSS2/Hic-Pro/HG00514/merge_3copy-hap/hic_results/matrix/HG00514/raw/10000/HG00514_10000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/CHM13_HG00513_HG00514_combined/10000/HG00514_10000_abs.bed

ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/NA18505/output/hic_results/matrix/NA18505/raw/1000/NA18505_1000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA18505/1000/NA18505_1000_abs.bed
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/NA18505/output/hic_results/matrix/NA18505/raw/1000/NA18505_1000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA18505/1000/NA18505_1000.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/NA18505/output/hic_results/matrix/NA18505/raw/5000/NA18505_5000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA18505/5000/NA18505_5000_abs.bed
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/NA18505/output/hic_results/matrix/NA18505/raw/5000/NA18505_5000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA18505/5000/NA18505_5000.matrix

ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/HG00514_HG00513_combined/output/hic_results/matrix/HG00514_HG00513_combined/raw/1000/HG00514_HG00513_combined_1000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/HG00514_HG00513_combined/HG00514_HG00513_combined_1000.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/HG00514_HG00513_combined/output/hic_results/matrix/HG00514_HG00513_combined/raw/1000/HG00514_HG00513_combined_1000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/HG00514_HG00513_combined/HG00514_HG00513_combined_1000_abs.bed

ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/HiC-Pro-selfalign/output/hic_results/matrix/TJ1/iced/1000/TJ1_1000_iced.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/TJ1/1000/TJ1_1000.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/HiC-Pro-selfalign/output/hic_results/matrix/TJ1/raw/1000/TJ1_1000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/TJ1/1000/TJ1_1000_abs.bed
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/HiC-Pro-selfalign/output/hic_results/matrix/TJ1/iced/5000/TJ1_5000_iced.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/TJ1/5000/TJ1_5000.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/HiC-Pro-selfalign/output/hic_results/matrix/TJ1/raw/5000/TJ1_5000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/TJ1/5000/TJ1_5000_abs.bed
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/HiC-Pro-selfalign/output/hic_results/matrix/TJ1/iced/10000/TJ1_10000_iced.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/TJ1/10000/TJ1_10000.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/HiC-Pro-selfalign/output/hic_results/matrix/TJ1/raw/10000/TJ1_10000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/TJ1/10000/TJ1_10000_abs.bed

ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/NA12878/output/hic_results/matrix/NA12878/raw/1000/NA12878_1000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/1000/NA12878_1000.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/NA12878/output/hic_results/matrix/NA12878/iced/1000/NA12878_1000_iced.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/1000/NA12878_1000_iced.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/NA12878/output/hic_results/matrix/NA12878/raw/1000/NA12878_1000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/1000/NA12878_1000_abs.bed
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/NA12878/output/hic_results/matrix/NA12878/raw/5000/NA12878_5000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/5000/NA12878_5000.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/NA12878/output/hic_results/matrix/NA12878/iced/5000/NA12878_5000_iced.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/5000/NA12878_5000_iced.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/NA12878/output/hic_results/matrix/NA12878/raw/5000/NA12878_5000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/5000/NA12878_5000_abs.bed
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/NA12878/output/hic_results/matrix/NA12878/raw/10000/NA12878_10000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/10000/NA12878_10000.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/NA12878/output/hic_results/matrix/NA12878/iced/10000/NA12878_10000_iced.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/10000/NA12878_10000_iced.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/sample1/PRSS2/HicPro/NA12878/output/hic_results/matrix/NA12878/raw/10000/NA12878_10000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/10000/NA12878_10000_abs.bed

ln -s /picb/humpopg-bigdata/xiebo/NGS/reference/HiC_data/hicpro/CHM13/full_enzyme_output/hic_results/matrix/CHM13/iced/1000/CHM13_1000_iced.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/CHM13/1000/CHM13_1000_iced.matrix
ln -s /picb/humpopg-bigdata/xiebo/NGS/reference/HiC_data/hicpro/CHM13/full_enzyme_output/hic_results/matrix/CHM13/raw/1000/CHM13_1000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/CHM13/1000/CHM13_1000_abs.bed
ln -s /picb/humpopg-bigdata/xiebo/NGS/reference/HiC_data/hicpro/CHM13/full_enzyme_output/hic_results/matrix/CHM13/iced/5000/CHM13_5000_iced.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/CHM13/5000/CHM13_5000_iced.matrix
ln -s /picb/humpopg-bigdata/xiebo/NGS/reference/HiC_data/hicpro/CHM13/full_enzyme_output/hic_results/matrix/CHM13/raw/5000/CHM13_5000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/CHM13/5000/CHM13_5000_abs.bed
ln -s /picb/humpopg-bigdata/xiebo/NGS/reference/HiC_data/hicpro/CHM13/full_enzyme_output/hic_results/matrix/CHM13/iced/10000/CHM13_10000_iced.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/CHM13/10000/CHM13_10000_iced.matrix
ln -s /picb/humpopg-bigdata/xiebo/NGS/reference/HiC_data/hicpro/CHM13/full_enzyme_output/hic_results/matrix/CHM13/raw/10000/CHM13_10000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/CHM13/10000/CHM13_10000_abs.bed

ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/NA12878/HiC-Pro-selfalign/output/hic_results/matrix/NA12878/raw/1000/NA12878_1000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/1000/NA12878_1000.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/NA12878/HiC-Pro-selfalign/output/hic_results/matrix/NA12878/raw/1000/NA12878_1000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/1000/NA12878_1000_abs.bed
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/NA12878/HiC-Pro-selfalign/output/hic_results/matrix/NA12878/raw/5000/NA12878_5000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/5000/NA12878_5000.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/NA12878/HiC-Pro-selfalign/output/hic_results/matrix/NA12878/raw/5000/NA12878_5000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/5000/NA12878_5000_abs.bed
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/NA12878/HiC-Pro-selfalign/output/hic_results/matrix/NA12878/raw/10000/NA12878_10000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/10000/NA12878_10000.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/NA12878/HiC-Pro-selfalign/output/hic_results/matrix/NA12878/raw/10000/NA12878_10000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/10000/NA12878_10000_abs.bed

ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/NA12878/HiChip-HiCPro/output/hic_results/matrix/NA12878/raw/1000/NA12878_1000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878_HiChip/1000/NA12878_1000.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/NA12878/HiChip-HiCPro/output/hic_results/matrix/NA12878/raw/1000/NA12878_1000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878_HiChip/1000/NA12878_1000_abs.bed
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/NA12878/HiChip-HiCPro/output/hic_results/matrix/NA12878/raw/5000/NA12878_5000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878_HiChip/5000/NA12878_5000.matrix
ln -s /picb/humpopg-bigdata4/louhaiyi/TGS/NA12878/HiChip-HiCPro/output/hic_results/matrix/NA12878/raw/5000/NA12878_5000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878_HiChip/5000/NA12878_5000_abs.bed

ln -s /picb/humpopg-bigdata/xiebo/NGS/reference/HiC_data/hicpro/CHM13/full_enzyme_self_output/hic_results/matrix/CHM13/raw/1000/CHM13_1000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/CHM13/1000/CHM13_1000.matrix
ln -s /picb/humpopg-bigdata/xiebo/NGS/reference/HiC_data/hicpro/CHM13/full_enzyme_self_output/hic_results/matrix/CHM13/iced/1000/CHM13_1000_iced.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/CHM13/1000/CHM13_1000_iced.matrix
ln -s /picb/humpopg-bigdata/xiebo/NGS/reference/HiC_data/hicpro/CHM13/full_enzyme_self_output/hic_results/matrix/CHM13/raw/1000/CHM13_1000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/CHM13/1000/CHM13_1000_abs.bed
ln -s /picb/humpopg-bigdata/xiebo/NGS/reference/HiC_data/hicpro/CHM13/full_enzyme_self_output/hic_results/matrix/CHM13/raw/5000/CHM13_5000.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/CHM13/5000/CHM13_5000.matrix
ln -s /picb/humpopg-bigdata/xiebo/NGS/reference/HiC_data/hicpro/CHM13/full_enzyme_self_output/hic_results/matrix/CHM13/iced/5000/CHM13_5000_iced.matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/CHM13/5000/CHM13_5000_iced.matrix
ln -s /picb/humpopg-bigdata/xiebo/NGS/reference/HiC_data/hicpro/CHM13/full_enzyme_self_output/hic_results/matrix/CHM13/raw/5000/CHM13_5000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/CHM13/5000/CHM13_5000_abs.bed




005-02 转换格式 (matrix -> h5) (source activate py27)
################################
1000
#######
hicConvertFormat --matrices HG00513_1000.matrix --outFileName HG00513_1000 --inputFormat hicpro --outputFormat h5 --resolutions 1000 --bedFileHicpro HG00513_1000_abs.bed
hicConvertFormat --matrices NA18505_1000.matrix --outFileName NA18505_1000 --inputFormat hicpro --outputFormat h5 --resolutions 1000 --bedFileHicpro NA18505_1000_abs.bed
hicConvertFormat --matrices HG00514_HG00513_combined_1000.matrix --outFileName HG00514_HG00513_combined_1000 --inputFormat hicpro --outputFormat h5 --resolutions 1000 --bedFileHicpro HG00514_HG00513_combined_1000_abs.bed
hicConvertFormat --matrices TJ1_1000.matrix --outFileName TJ1_1000 --inputFormat hicpro --outputFormat h5 --resolutions 1000 --bedFileHicpro TJ1_1000_abs.bed
hicConvertFormat --matrices NA12878_1000.matrix --outFileName NA12878_1000 --inputFormat hicpro --outputFormat h5 --resolutions 1000 --bedFileHicpro NA12878_1000_abs.bed
hicConvertFormat --matrices NA12878_1000.matrix --outFileName NA12878_1000.cool --inputFormat hicpro --outputFormat cool --resolutions 1000 --bedFileHicpro NA12878_1000_abs.bed
hicConvertFormat --matrices NA12878_1000_iced.matrix --outFileName NA12878_1000_iced --inputFormat hicpro --outputFormat h5 --resolutions 1000 --bedFileHicpro NA12878_1000_abs.bed
hicConvertFormat --matrices CHM13_1000_iced.matrix --outFileName CHM13_1000_iced --inputFormat hicpro --outputFormat h5 --resolutions 1000 --bedFileHicpro CHM13_1000_abs.bed
hicConvertFormat --matrices CHM13_1000.matrix --outFileName CHM13_1000 --inputFormat hicpro --outputFormat h5 --resolutions 1000 --bedFileHicpro CHM13_1000_abs.bed

5000
#######
hicConvertFormat --matrices HG00513_5000.matrix --outFileName HG00513_5000 --inputFormat hicpro --outputFormat h5 --resolutions 5000 --bedFileHicpro HG00513_5000_abs.bed
hicConvertFormat --matrices HG00514_5000.matrix --outFileName HG00514_5000 --inputFormat hicpro --outputFormat h5 --resolutions 5000 --bedFileHicpro HG00514_5000_abs.bed
hicConvertFormat --matrices TJ1_5000.matrix --outFileName TJ1_5000 --inputFormat hicpro --outputFormat h5 --resolutions 5000 --bedFileHicpro TJ1_5000_abs.bed
hicConvertFormat --matrices NA18505_5000.matrix --outFileName NA18505_5000 --inputFormat hicpro --outputFormat h5 --resolutions 5000 --bedFileHicpro NA18505_5000_abs.bed
hicConvertFormat --matrices NA12878_5000.matrix --outFileName NA12878_5000 --inputFormat hicpro --outputFormat h5 --resolutions 5000 --bedFileHicpro NA12878_5000_abs.bed
hicConvertFormat --matrices NA12878_5000.matrix --outFileName NA12878_5000.cool --inputFormat hicpro --outputFormat cool --resolutions 5000 --bedFileHicpro NA12878_5000_abs.bed
hicConvertFormat --matrices NA12878_5000.cool --outFileName NA12878_5000.CM009453.1.h5 --inputFormat cool --outputFormat h5 --resolutions 5000 
hicConvertFormat --matrices NA12878_5000_iced.matrix --outFileName NA12878_5000_iced --inputFormat hicpro --outputFormat h5 --resolutions 5000 --bedFileHicpro NA12878_5000_abs.bed
hicConvertFormat --matrices CHM13_5000_iced.matrix --outFileName CHM13_5000_iced --inputFormat hicpro --outputFormat h5 --resolutions 5000 --bedFileHicpro CHM13_5000_abs.bed
hicConvertFormat --matrices CHM13_5000.matrix --outFileName CHM13_5000 --inputFormat hicpro --outputFormat h5 --resolutions 5000 --bedFileHicpro CHM13_5000_abs.bed

10000
#######
/picb/humpopg/xiebo/conda/envs/py27/bin/hicConvertFormat --matrices HG00513_10000.matrix --outFileName HG00513_10000 --inputFormat hicpro --outputFormat h5 --resolutions 10000 --bedFileHicpro HG00513_10000_abs.bed
hicConvertFormat --matrices HG00514_10000.matrix --outFileName HG00514_10000 --inputFormat hicpro --outputFormat h5 --resolutions 10000 --bedFileHicpro HG00514_10000_abs.bed
hicConvertFormat --matrices TJ1_10000.matrix --outFileName TJ1_10000 --inputFormat hicpro --outputFormat h5 --resolutions 10000 --bedFileHicpro TJ1_10000_abs.bed
hicConvertFormat --matrices NA12878_10000.matrix --outFileName NA12878_10000 --inputFormat hicpro --outputFormat h5 --resolutions 10000 --bedFileHicpro NA12878_10000_abs.bed
hicConvertFormat --matrices NA12878_10000_iced.matrix --outFileName NA12878_10000_iced --inputFormat hicpro --outputFormat h5 --resolutions 10000 --bedFileHicpro NA12878_10000_abs.bed
hicConvertFormat --matrices CHM13_10000_iced.matrix --outFileName CHM13_10000_iced --inputFormat hicpro --outputFormat h5 --resolutions 10000 --bedFileHicpro CHM13_10000_abs.bed

005-03 correct matrix
################################
1000
#######
hicCorrectMatrix  diagnostic_plot --matrix HG00513_1000.h5  --plotName HG00513_1000_corrected.h5.plot.png
hicCorrectMatrix correct --matrix HG00513_1000.h5 --filterThreshold -0.4 2  --outFileName HG00513_1000_corrected.h5

hicCorrectMatrix  diagnostic_plot --matrix NA18505_1000.h5  --plotName NA18505_1000_corrected.h5.plot.png
hicCorrectMatrix correct --matrix NA18505_1000.h5 --filterThreshold -0.4 2  --outFileName NA18505_1000_corrected.h5

hicCorrectMatrix  diagnostic_plot --matrix HG00514_HG00513_combined_1000.h5  --plotName HG00514_HG00513_combined_1000_corrected.h5.plot.png
hicCorrectMatrix correct --matrix HG00514_HG00513_combined_1000.h5 --filterThreshold -0.4 2  --outFileName HG00514_HG00513_combined_1000_corrected.h5

hicCorrectMatrix  diagnostic_plot --matrix TJ1_1000.h5  --plotName TJ1_1000_corrected.h5.plot.png
hicCorrectMatrix correct --matrix TJ1_1000.h5 --filterThreshold -3 3  --outFileName TJ1_1000_corrected.h5
#hicCorrectMatrix correct --matrix /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/TJ1/1000/TJ1_1000.h5 --filterThreshold -3.5 5  --outFileName TJ1_1000_corrected.h5

hicCorrectMatrix  diagnostic_plot --matrix NA12878_1000.h5  --plotName NA12878_1000_corrected.h5.plot.png
hicCorrectMatrix correct --matrix NA12878_1000.h5 --filterThreshold -1.4 3  --outFileName NA12878_1000_corrected.h5

hicCorrectMatrix  diagnostic_plot --matrix NA12878_1000_iced.h5  --plotName NA12878_1000_iced_corrected.h5.plot.png
hicCorrectMatrix correct --matrix NA12878_1000_iced.h5 --filterThreshold -5 5  --outFileName NA12878_1000_iced_corrected.h5

hicCorrectMatrix  diagnostic_plot --matrix CHM13_1000_iced.h5  --plotName CHM13_1000_iced_corrected.h5.plot.png
hicCorrectMatrix correct --matrix CHM13_1000_iced.h5 --filterThreshold -3 2.2  --outFileName CHM13_1000_iced_corrected.h5

5000
#######
hicCorrectMatrix  diagnostic_plot --matrix HG00513_5000.h5  --plotName HG00513_5000_corrected.h5.plot.png
hicCorrectMatrix correct --matrix HG00513_5000.h5 --filterThreshold -1.2 3  --outFileName HG00513_5000_corrected.h5

hicCorrectMatrix  diagnostic_plot --matrix HG00514_5000.h5  --plotName HG00514_5000_corrected.h5.plot.png
hicCorrectMatrix correct --matrix HG00514_5000.h5 --filterThreshold -1.9 3  --outFileName HG00514_5000_corrected.h5

###CHM13_HG00513_HG00514_combined
hicCorrectMatrix  diagnostic_plot --matrix HG00514_5000.h5  --plotName HG00514_5000_corrected.h5.plot.png
hicCorrectMatrix correct --matrix HG00514_5000.h5 --filterThreshold -1.4 2.6  --outFileName HG00514_5000_corrected.h5

hicCorrectMatrix  diagnostic_plot --matrix TJ1_5000.h5  --plotName TJ1_5000_corrected.h5.plot.png
hicCorrectMatrix correct --matrix TJ1_5000.h5 --filterThreshold -2 2.8  --outFileName TJ1_5000_corrected.h5

hicCorrectMatrix  diagnostic_plot --matrix NA12878_5000.h5  --plotName NA12878_5000_corrected.h5.plot.png
hicCorrectMatrix correct --matrix NA12878_5000.h5 --filterThreshold -1.8 3  --outFileName NA12878_5000_corrected.h5

hicCorrectMatrix  diagnostic_plot --matrix NA12878_5000_iced.h5  --plotName NA12878_5000_iced_corrected.h5.plot.png
hicCorrectMatrix correct --matrix NA12878_5000_iced.h5 --filterThreshold -4 4  --outFileName NA12878_5000_iced_corrected.h5

hicCorrectMatrix  diagnostic_plot --matrix CHM13_5000_iced.h5  --plotName CHM13_5000_iced_corrected.h5.plot.png
hicCorrectMatrix correct --matrix CHM13_5000_iced.h5 --filterThreshold -4 2.2  --outFileName CHM13_5000_iced_corrected.h5

10000
#######
hicCorrectMatrix  diagnostic_plot --matrix HG00513_10000.h5  --plotName HG00513_10000_corrected.h5.plot.png
hicCorrectMatrix correct --matrix HG00513_10000.h5 --filterThreshold -1.4 3  --outFileName HG00513_10000_corrected.h5

hicCorrectMatrix  diagnostic_plot --matrix TJ1_10000.h5  --plotName TJ1_10000_corrected.h5.plot.png
hicCorrectMatrix correct --matrix TJ1_10000.h5 --filterThreshold -3 3  --outFileName TJ1_10000_corrected.h5

hicCorrectMatrix  diagnostic_plot --matrix NA12878_10000.h5  --plotName NA12878_10000_corrected.h5.plot.png
hicCorrectMatrix correct --matrix NA12878_10000.h5 --filterThreshold -1.8 3  --outFileName NA12878_10000_corrected.h5

hicCorrectMatrix  diagnostic_plot --matrix NA12878_10000_iced.h5  --plotName NA12878_10000_iced_corrected.h5.plot.png
hicCorrectMatrix correct --matrix NA12878_10000_iced.h5 --filterThreshold -4 4  --outFileName NA12878_10000_iced_corrected.h5

hicCorrectMatrix  diagnostic_plot --matrix CHM13_10000_iced.h5  --plotName CHM13_10000_iced_corrected.h5.plot.png
hicCorrectMatrix correct --matrix CHM13_10000_iced.h5 --filterThreshold -4 2.2  --outFileName CHM13_10000_iced_corrected.h5


005-04 detect loops 
###############################
NA12878 (detect loops)
############
/picb/humpopg/xiebo/conda/envs/py36/bin/hicDetectLoops -m NA12878_1000.cool -o NA12878_1000.loops.bedgraph --maxLoopDistance 2000000 --windowSize 10 --peakWidth 4 --pValuePreselection 0.05 --pValue 0.05
/picb/humpopg/xiebo/conda/envs/py36/bin/hicDetectLoops -m NA12878_5000.cool -o NA12878_5000.loops.bedgraph --maxLoopDistance 2000000 --windowSize 10 --peakWidth 4 --pValuePreselection 0.05 --pValue 0.05

/picb/humpopg/xiebo/conda/envs/py36/bin/hicDetectLoops -m NA12878_1000.normalized.cool -o NA12878_1000.normalized.loops.bedgraph --maxLoopDistance 2000000 --windowSize 10 --peakWidth 4 --pValuePreselection 0.05 --pValue 0.05
/picb/humpopg/xiebo/conda/envs/py36/bin/hicDetectLoops -m NA12878_5000.normalized.cool -o NA12878_5000.normalized.loops.bedgraph --maxLoopDistance 2000000 --windowSize 10 --peakWidth 4 --pValuePreselection 0.05 --pValue 0.05

NA12878 (plot loops)
############
hicPlotMatrix -m NA12878_1000.cool -o NA12878_1000.PRSS.add_loops.png --log1p --region CM009453.1:143,408,012-143,650,162 --loops NA12878_1000.loops.bedgraph
hicPlotMatrix -m NA12878_5000.cool -o NA12878_5000.PRSS.add_loops.png --log1p --region CM009453.1:143,408,012-143,650,162 --loops NA12878_5000.loops.bedgraph

005-04 hicAdjustMatrix
###############################
5000
############
hicAdjustMatrix -m HG00514_5000.h5 --action keep --regions CHM13_PRSS.bed -o HG00514_5000.PRSS.h5
hicAdjustMatrix -m NA12878_5000.h5 --action keep --regions NA12878_PRSS.bed -o NA12878_5000.PRSS.h5

005-04 Normalized matrix
################################
1000
#######
hicNormalize -m HG00513_1000_corrected.h5 --normalize norm_range -o HG00513_1000_corrected.normalized.h5
hicNormalize -m NA18505_1000_corrected.h5 --normalize norm_range -o NA18505_1000_corrected.normalized.h5
hicNormalize -m HG00514_HG00513_combined_1000_corrected.h5 --normalize norm_range -o HG00514_HG00513_combined_1000_corrected.normalized.h5
hicNormalize -m NA12878_1000.h5 --normalize norm_range -o NA12878_1000.normalized.h5
hicNormalize -m NA12878_1000.cool --normalize norm_range -o NA12878_1000.normalized.cool

5000
#######
hicNormalize -m HG00514_5000.h5 --normalize norm_range -o HG00514_5000.normalized.h5
hicNormalize -m NA12878_5000.h5 --normalize norm_range -o NA12878_5000.normalized.h5
hicNormalize -m HG00513_5000_corrected.h5 --normalize norm_range -o HG00513_5000_corrected.normalized.h5
hicNormalize -m HG00514_5000_corrected.h5 --normalize norm_range -o HG00514_5000_corrected.normalized.h5
hicNormalize -m NA12878_5000_corrected.h5 --normalize norm_range -o NA12878_5000_corrected.normalized.h5

hicNormalize -m HG00514_5000.PRSS.h5 --normalize norm_range -o HG00514_5000.PRSS_normalized.h5
hicNormalize -m NA12878_5000.PRSS.h5 --normalize norm_range -o NA12878_5000.PRSS_normalized.h5
hicNormalize -m NA12878_5000.cool --normalize norm_range -o NA12878_5000.normalized.cool


1000
#######
hicNormalize -m HG00513_10000_corrected.h5 --normalize norm_range -o HG00513_10000_corrected.normalized.h5


005-05 plot correct matrix
################################
1000
#######
hicPlotMatrix --log1p --dpi 300 --matrix HG00513_1000_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,464,420-138,536,665 --clearMaskedBins -o HG00513_1000_corrected.PRSS.png
hicPlotMatrix --log1p --dpi 300 --matrix NA18505_1000_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,464,420-138,536,665 --clearMaskedBins -o NA18505_1000_corrected.PRSS.png
hicPlotMatrix --log1p --dpi 300 --matrix HG00514_HG00513_combined_1000_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,464,420-138,536,665 --clearMaskedBins -o HG00514_HG00513_combined_1000_corrected.PRSS.png
hicPlotMatrix --log1p --dpi 300 --matrix TJ1_1000_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,464,420-138,536,665 --clearMaskedBins -o TJ1_1000_corrected.PRSS.png
hicPlotMatrix --log1p --dpi 300 --matrix NA12878_1000.h5 --region p0_HiC_scaffold_2_pilon3:138,464,420-138,536,665 --clearMaskedBins -o NA12878_1000.PRSS.png
#hicPlotMatrix --log1p --dpi 300 --matrix NA12878_1000.h5 --region CM009453.1:143,508,012-143,560,162 --clearMaskedBins -o NA12878_1000.PRSS.png
#hicPlotMatrix --log1p --dpi 300 --matrix NA12878_1000.h5 --region CM009453.1:143,458,012-143,600,162 --clearMaskedBins -o NA12878_1000.PRSS.beta.png
#hicPlotMatrix --log1p --dpi 300 --matrix NA12878_1000.h5 --region CM009453.1:143,408,012-143,650,162 --clearMaskedBins -o NA12878_1000.PRSS.beta.1.png
#hicPlotMatrix --dpi 300 --matrix NA12878_1000.h5 --region CM009453.1:143,458,012-143,600,162 --clearMaskedBins -o NA12878_1000.PRSS.beta.2.png
#hicPlotMatrix --log1p --dpi 300 --matrix NA12878_1000.normalized.h5 --region CM009453.1:143,408,012-143,650,162 --clearMaskedBins -o NA12878_1000.PRSS.normalized.beta.1.png
hicPlotMatrix --log1p --dpi 300 --matrix NA12878_1000_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,464,420-138,536,665 --clearMaskedBins -o NA12878_1000_corrected.PRSS.png
#hicPlotMatrix --log1p --dpi 300 --matrix NA12878_1000_corrected.h5 --region CM009453.1:143,458,012-143,600,162 --clearMaskedBins -o NA12878_1000_corrected.PRSS.beta.png
hicPlotMatrix --log1p --dpi 300 --matrix NA12878_1000_iced_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,464,420-138,536,665 --clearMaskedBins -o NA12878_1000_iced_corrected.PRSS.png
hicPlotMatrix --log1p --dpi 300 --matrix CHM13_1000_iced_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,464,420-138,536,665 --clearMaskedBins -o CHM13_1000_iced_corrected.PRSS.png
hicPlotMatrix --log1p --dpi 300 --matrix CHM13_1000_iced.h5 --region p0_HiC_scaffold_2_pilon3:138,464,420-138,536,665 --clearMaskedBins -o CHM13_1000_iced.PRSS.png

5000
#######
CM009453.1:143508012-143560162
CHM13 PRSS: chr7:144102531-144134301
hicPlotMatrix --log1p --dpi 300 --matrix HG00513_5000_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,464,420-138,536,665 --clearMaskedBins -o HG00513_5000_corrected.PRSS.png
hicPlotMatrix --log1p --dpi 300 --matrix HG00514_5000_corrected.h5 --region chr7:144,062,531-144,174,301 --clearMaskedBins -o HG00514_5000_corrected.PRSS.png
hicPlotMatrix --log1p --dpi 300 --matrix TJ1_5000_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,464,420-138,536,665 --clearMaskedBins -o TJ1_5000_corrected.PRSS.png
hicPlotMatrix --log1p --dpi 300 --matrix NA18505_5000.h5 --region p0_HiC_scaffold_2_pilon3:138,374,420-138,616,665 --clearMaskedBins -o NA18505_5000.PRSS.beta.1.png
hicPlotMatrix --log1p --dpi 300 --matrix NA12878_5000_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,304,420-138,696,665 --clearMaskedBins -o NA12878_5000_corrected.PRSS.beta.png
#/picb/humpopg/xiebo/conda/envs/py36/bin/hicPlotMatrix --log1p --dpi 300 --matrix NA12878_5000.cool --region CM009453.1:143,408,012-143,650,162 --clearMaskedBins -o NA12878_5000.PRSS.loops.beta.1.png --loops NA12878_5000.loops.bedgraph
#hicPlotMatrix --log1p --dpi 300 --matrix NA12878_5000.h5 --region CM009453.1:143,408,012-143,650,162 --clearMaskedBins -o NA12878_5000.PRSS.beta.1.png
#hicPlotMatrix --log1p --dpi 300 --matrix NA12878_5000.h5 --region CM009453.1:143,358,012-143,700,162 --clearMaskedBins -o NA12878_5000.PRSS.beta.2.png
#hicPlotMatrix --log1p --dpi 300 --matrix NA12878_5000.h5 --region CM009453.1:143,308,012-143,750,162 --clearMaskedBins -o NA12878_5000.PRSS.beta.3.png
#hicPlotMatrix --log1p --dpi 300 --matrix NA12878_5000_corrected.h5 --region CM009453.1:143,508,012-143,560,162 --clearMaskedBins -o NA12878_5000_corrected.PRSS.beta.png
#hicPlotMatrix --log1p --dpi 300 --matrix NA12878_5000_corrected.h5 --region CM009453.1:143,408,012-143,650,162 --clearMaskedBins -o NA12878_5000_corrected.PRSS.beta.1.png
#hicPlotMatrix --log1p --dpi 300 --matrix NA12878_5000_corrected.h5 --region CM009453.1:143,358,012-143,650,162 --clearMaskedBins -o NA12878_5000_corrected.PRSS.beta.2.png
hicPlotMatrix --log1p --dpi 300 --matrix NA12878_5000_iced_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,404,420-138,596,665 --clearMaskedBins -o NA12878_5000_iced_corrected.PRSS.beta.png
hicPlotMatrix --log1p --dpi 300 --matrix CHM13_5000_iced_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,404,420-138,596,665 --clearMaskedBins -o CHM13_5000_iced_corrected.PRSS.beta.png

10000
#######
hicPlotMatrix --log1p --dpi 300 --matrix HG00513_10000_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,464,420-138,536,665 --clearMaskedBins -o HG00513_10000_corrected.PRSS.png
hicPlotMatrix --log1p --dpi 300 --matrix TJ1_10000_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,404,420-138,596,665 --clearMaskedBins -o TJ1_10000_corrected.PRSS.png
hicPlotMatrix --log1p --dpi 300 --matrix NA12878_10000_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,404,420-138,596,665 --clearMaskedBins -o NA12878_10000_corrected.PRSS.png
hicPlotMatrix --log1p --dpi 300 --matrix NA12878_10000_iced_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,404,420-138,596,665 --clearMaskedBins -o NA12878_10000_iced_corrected.PRSS.png
hicPlotMatrix --log1p --dpi 300 --matrix CHM13_10000_iced_corrected.h5 --region p0_HiC_scaffold_2_pilon3:138,404,420-138,596,665 --clearMaskedBins -o CHM13_10000_iced_corrected.PRSS.png


005-06 call and plot TAD
################################
1000
#######
hicFindTADs -m HG00513_1000_corrected.h5 --outPrefix HG00513_1000_corrected_min10000_max30000_step1000 --minDepth 10000 --maxDepth 30000 --step 1000 --thresholdComparisons 0.05 --delta 0.01 --correctForMultipleTesting fdr --numberOfProcessors 16
hicFindTADs -m NA18505_1000_corrected.h5 --outPrefix NA18505_1000_corrected_min10000_max30000_step1000 --minDepth 10000 --maxDepth 30000 --step 1000 --thresholdComparisons 0.05 --delta 0.01 --correctForMultipleTesting fdr --numberOfProcessors 16
hicFindTADs -m NA12878_1000.h5 --outPrefix NA12878_1000 --correctForMultipleTesting fdr --numberOfProcessors 16
hicFindTADs -m NA12878_1000.h5 --outPrefix NA12878_1000_fdr0.05 --thresholdComparisons 0.05 --correctForMultipleTesting fdr --numberOfProcessors 16
hicPlotTADs --tracks NA12878_1000.PRSS.hic_track.ini -o NA12878_1000.PRSS.CM009453.1-143450000-143650000.hic_track.png --region CM009453.1:143,450,000-143,650,000  -o NA12878_1000.PRSS.CM009453.1-143450000-143650000.hic_track.pdf
hicPlotTADs --tracks NA12878_1000.PRSS.hic_track.ini -o NA12878_1000.PRSS.CM009453.1-143450000-143600000.hic_track.png --region CM009453.1:143,450,000-143,600,000  -o NA12878_1000.PRSS.CM009453.1-143450000-143600000.hic_track.pdf

#hicPlotTADs --tracks NA12878_1000.PRSS.hic_track.beta.ini --region CM009453.1:143,500,000-143,575,000 -o NA12878_1000.PRSS.CM009453.1-143500000-143575000.hic_track.beta.pdf
hicPlotTADs --tracks NA12878_1000.PRSS.hic_track.beta.ini --region CM009453.1:143,500,000-143,575,000 -o NA12878_1000.PRSS.CM009453.1-143500000-143575000.hic_track.HiChip.beta.pdf

5000
#######
hicFindTADs -m HG00513_5000_corrected.h5 --outPrefix HG00513_5000_corrected --numberOfProcessors 16
hicFindTADs -m NA12878_5000.h5 --outPrefix NA12878_5000 --correctForMultipleTesting fdr --numberOfProcessors 16
hicFindTADs -m NA12878_5000.h5 --outPrefix NA12878_5000_fdr0.05 --thresholdComparisons 0.05 --correctForMultipleTesting fdr --numberOfProcessors 16
hicFindTADs -m NA12878_5000.h5 --outPrefix NA12878_5000_min20000_max80000_step5000 --minDepth 20000 --maxDepth 80000 --step 5000 --correctForMultipleTesting fdr --numberOfProcessors 16
#hicFindTADs -m NA12878_5000.CM009453.1.h5 --outPrefix NA12878_5000.CM009453.1 --chromosomes CM009453.1 --correctForMultipleTesting fdr --numberOfProcessors 16
#hicFindTADs -m NA12878_5000.h5 --outPrefix NA12878_5000_corrected_min20000_max80000_step5000 --minDepth 20000 --maxDepth 80000 --step 5000 --correctForMultipleTesting fdr --numberOfProcessors 16
#hicFindTADs -m NA12878_5000.h5 --outPrefix NA12878_5000_corrected_min15000_max60000_step5000 --minDepth 15000 --maxDepth 60000 --step 5000 --thresholdComparisons 0.05 --correctForMultipleTesting fdr --numberOfProcessors 16

hicPlotTADs --tracks HG00514_5000.PRSS.hic_track.ini --region chr7:144,062,531-144,174,301 -o HG00514_5000.PRSS.chr7-144062531-144174301.hic_track.pdf
hicPlotTADs --tracks HG00514_5000.PRSS.hic_track.normalized.ini --region chr7:144,062,531-144,174,301 -o HG00514_5000.PRSS.chr7-144062531-144174301.hic_track.normalized.pdf
hicPlotTADs --tracks HG00514_5000.PRSS.hic_track.PRSS_normalized.ini --region chr7:144,062,531-144,174,301 -o HG00514_5000.PRSS.chr7-144062531-144174301.hic_track.PRSS_normalized.pdf

hicPlotTADs --tracks CHM13_5000.PRSS.hic_track.ini -o CHM13_5000.PRSS.p0_HiC_scaffold_2_pilon3-138465000-138541000.hic_track.png --region p0_HiC_scaffold_2_pilon3:138,465,000-138,541,000 -o CHM13_5000.PRSS.p0_HiC_scaffold_2_pilon3-138465000-138541000.hic_track.pdf

hicPlotTADs --tracks CHM13_5000.PRSS.hic_track.selfRefence.ini --region chr7:144,090,000-144,150,000 -o CHM13_5000.PRSS.chr7-144090000-144150000.hic_track.selfRefence.pdf

hicPlotTADs --tracks CHM13_5000.PRSS.hic_track.selfRefence.beta.ini --region chr7:144,045,000-144,195,000 -o CHM13_5000.PRSS.chr7-144045000-144195000.hic_track.selfRefence.pdf


hicPlotTADs --tracks NA12878_5000.PRSS.hic_track.ini -o NA12878_5000.PRSS.hic_track.png --region CM009453.1:143,350,000-143,700,000 -t 'NA12878_5000_fdr0.05_TAD' -o NA12878_5000.PRSS.hic_track.pdf
hicPlotTADs --tracks NA12878_5000.PRSS.hic_track.ini -o NA12878_5000.PRSS.CM009453.1-143450000-143650000.hic_track.png --region CM009453.1:143,450,000-143,650,000 -t 'NA12878_5000_fdr0.05_TAD' -o NA12878_5000.PRSS.CM009453.1-143450000-143650000.hic_track.pdf
hicPlotTADs --tracks NA12878_5000.PRSS.hic_track.ini -o NA12878_5000.PRSS.CM009453.1-143450000-143600000.hic_track.png --region CM009453.1:143,450,000-143,600,000 -o NA12878_5000.PRSS.CM009453.1-143450000-143600000.hic_track.pdf
hicPlotTADs --tracks NA12878_5000.PRSS.hic_track.beta.ini  --region CM009453.1:143,450,000-143,600,000 -o NA12878_5000.PRSS.CM009453.1-143450000-143600000.hic_track.beta.pdf
hicPlotTADs --tracks NA12878_5000.add_GECODE_pancreas_chipseq.PRSS.hic_track.beta.ini  --region CM009453.1:143,450,000-143,600,000 -o NA12878_5000.add_GECODE_pancreas_chipseq.PRSS.CM009453.1-143450000-143600000.hic_track.beta.pdf
hicPlotTADs --tracks NA12878_5000.add_GECODE_pancreas_chipseq.PRSS.hic_track.beta.1.ini  --region CM009453.1:143,450,000-143,600,000 -o NA12878_5000.add_GECODE_pancreas_chipseq.PRSS.CM009453.1-143450000-143600000.hic_track.beta.1.pdf
hicPlotTADs --tracks NA12878_5000.add_GECODE_Adrenal_Gland_chipseq.PRSS.hic_track.beta.ini  --region CM009453.1:143,450,000-143,600,000 -o NA12878_5000.add_GECODE_Adrenal_Gland_chipseq.PRSS.CM009453.1-143450000-143600000.hic_track.beta.pdf
hicPlotTADs --tracks NA12878_5000.add_GECODE_Small_Intestine_chipseq.PRSS.hic_track.beta.ini  --region CM009453.1:143,450,000-143,600,000 -o NA12878_5000.add_GECODE_Small_Intestine_chipseq.PRSS.CM009453.1-143450000-143600000.hic_track.beta.pdf
hicPlotTADs --tracks NA12878_5000.add_GECODE_pancreas_and_small_Intestine_chipseq.5-copy-PRSS.hic_track.beta.ini  --region CM009453.1:143,450,000-143,600,000 -o NA12878_5000.add_GECODE_pancreas_and_small_Intestine_chipseq.PRSS.CM009453.1-143450000-143600000.hic_track.beta.pdf
hicPlotTADs --tracks NA12878_5000.PRSS.hic_track.normalized.beta.ini  --region CM009453.1:143,450,000-143,600,000 -o NA12878_5000.PRSS.CM009453.1-143450000-143600000.hic_track.normalized.beta.pdf
hicPlotTADs --tracks NA12878_5000.PRSS.hic_track.PRSS_normalized.beta.ini  --region CM009453.1:143,450,000-143,600,000 -o NA12878_5000.PRSS.CM009453.1-143450000-143600000.hic_track.PRSS_normalized.beta.pdf
hicPlotTADs --tracks NA12878_5000.add_GECODE_pancreas_chipseq.PRSS.beta.ini  --region CM009453.1:143508012-143560162 -o NA12878_5000.add_GECODE_pancreas_chipseq.PRSS.CM009453.1-143508012-143560162.beta.pdf
hicPlotTADs --tracks NA12878_5000.add_GECODE_pancreas_chipseq.PRSS.Hom-5-copy.beta.ini  --region CM009453.1:143508012-143560162 -o NA12878_5000.add_GECODE_pancreas_chipseq.PRSS.CM009453.1-143508012-143560162.Hom-5-copy.beta.pdf
hicPlotTADs --tracks NA12878_5000.add_GECODE_pancreas_chipseq.PRSS.Het-3-5-copy.beta.ini  --region CM009453.1:143508012-143560162 -o NA12878_5000.add_GECODE_pancreas_chipseq.PRSS.CM009453.1-143508012-143560162.Het-3-5-copy.beta.pdf
hicPlotTADs --tracks NA12878_5000.add_GECODE_pancreas_chipseq.PRSS.Hom-3-copy.beta.ini  --region CM009453.1:143508012-143560162 -o NA12878_5000.add_GECODE_pancreas_chipseq.PRSS.CM009453.1-143508012-143560162.Hom-3-copy.beta.pdf


hicPlotTADs --tracks NA12878_5000.PRSS.hic_track.beta.ini --region CM009453.1:143,500,000-143,575,000 -o NA12878_5000.PRSS.CM009453.1-143500000-143575000.hic_track.beta.pdf
#hicPlotTADs --tracks NA12878_5000.PRSS.hic_track.beta.ini --region CM009453.1:143,500,000-143,575,000 -o NA12878_5000.PRSS.CM009453.1-143500000-143575000.hic_track.HiChip.beta.pdf

hicPlotTADs --tracks NA07037.PRSS.hic_track.beta.ini --region CM009453.1:143,500,000-143,575,000 -o NA07037.PRSS.CM009453.1-143500000-143575000.hic_track.beta.pdf
hicPlotTADs --tracks NA12287.PRSS.hic_track.beta.ini --region CM009453.1:143,500,000-143,575,000 -o NA12287.PRSS.CM009453.1-143500000-143575000.hic_track.beta.pdf
hicPlotTADs --tracks NA12878_NA07037_NA12287.PRSS.hic_track.beta.ini --region CM009453.1:143,500,000-143,575,000 -o NA12878_NA07037_NA12287.PRSS.CM009453.1-143500000-143575000.hic_track.beta.pdf

hicPlotTADs --tracks KGP.PRSS_Hom_3copy.hic_track.3samples.beta.ini --region CM009453.1:143,500,000-143,575,000 -o KGP.PRSS_Hom_3copy.CM009453.1-143500000-143575000.hic_track.3samples.beta.pdf
hicPlotTADs --tracks KGP.PRSS_Het_3_5copy.hic_track.3samples.beta.ini --region CM009453.1:143,500,000-143,575,000 -o KGP.PRSS_Het_3_5copy.CM009453.1-143500000-143575000.hic_track.3samples.beta.pdf
hicPlotTADs --tracks KGP.PRSS_Hom_5copy.hic_track.3samples.beta.ini --region CM009453.1:143,500,000-143,575,000 -o KGP.PRSS_Hom_5copy.CM009453.1-143500000-143575000.hic_track.3samples.beta.pdf


hicPlotTADs --tracks KGP.PRSS_Hom_3copy.hic_track.beta.ini --region CM009453.1:143,500,000-143,575,000 -o KGP.PRSS_Hom_3copy.CM009453.1-143500000-143575000.hic_track.beta.pdf
hicPlotTADs --tracks KGP.PRSS_Het_3_5copy.hic_track.beta.ini --region CM009453.1:143,500,000-143,575,000 -o KGP.PRSS_Het_3_5copy.CM009453.1-143500000-143575000.hic_track.beta.pdf
hicPlotTADs --tracks KGP.PRSS_Hom_5copy.hic_track.beta.ini --region CM009453.1:143,500,000-143,575,000 -o KGP.PRSS_Hom_5copy.CM009453.1-143500000-143575000.hic_track.beta.pdf
hicPlotTADs --tracks GECODE.PRSS.hic_track.beta.ini --region CM009453.1:143,500,000-143,575,000 -o GECODE.PRSS.CM009453.1-143500000-143575000.hic_track.beta.pdf
hicPlotTADs --tracks GECODE.PRSS.hic_track.MQ10.beta.ini --region CM009453.1:143,500,000-143,575,000 -o GECODE.PRSS.CM009453.1-143500000-143575000.hic_track.MQ10.beta.pdf
hicPlotTADs --tracks GECODE.PRSS.hic_track.MQ20.beta.ini --region CM009453.1:143,500,000-143,575,000 -o GECODE.PRSS.CM009453.1-143500000-143575000.hic_track.MQ20.beta.pdf
hicPlotTADs --tracks GECODE.PRSS.hic_track.MQ20.beta.1.ini --region CM009453.1:143,500,000-143,575,000 -o GECODE.PRSS.CM009453.1-143500000-143575000.hic_track.MQ20.beta.1.pdf
hicPlotTADs --tracks GECODE.PRSS.hic_track.MQ30.beta.1.ini --region CM009453.1:143,500,000-143,575,000 -o GECODE.PRSS.CM009453.1-143500000-143575000.hic_track.MQ30.beta.1.pdf
hicPlotTADs --tracks GECODE.PRSS.hic_track.beta.1.ini --region CM009453.1:143,500,000-143,575,000 -o GECODE.PRSS.CM009453.1-143500000-143575000.hic_track.beta.1.pdf
hicPlotTADs --tracks pancreatic_cell_chipseq.PRSS.hic_track.beta.ini --region CM009453.1:143,500,000-143,575,000 -o pancreatic_cell_chipseq.PRSS.CM009453.1-143500000-143575000.hic_track.beta.pdf
hicPlotTADs --tracks GECODE.PRSS.Adrenal_Gland.hic_track.MQ20.beta.1.ini --region CM009453.1:143,500,000-143,575,000 -o GECODE.PRSS.Adrenal_Gland.CM009453.1-143500000-143575000.hic_track.MQ20.beta.1.pdf
hicPlotTADs --tracks GECODE.PRSS.Stomach.hic_track.MQ20.beta.1.ini --region CM009453.1:143,500,000-143,575,000 -o GECODE.PRSS.Stomach.CM009453.1-143500000-143575000.hic_track.MQ20.beta.1.pdf
hicPlotTADs --tracks GECODE.PRSS.Small_Intestine.hic_track.MQ20.beta.1.ini --region CM009453.1:143,500,000-143,575,000 -o GECODE.PRSS.Small_Intestine.CM009453.1-143500000-143575000.hic_track.MQ20.beta.1.pdf

hicPlotTADs --tracks GECODE.PRSS.macs2_narrowPeak.H3K27ac.track.beta.ini --region CM009453.1:143,500,000-143,575,000 -o GECODE.PRSS.macs2_narrowPeak.CM009453.1-143500000-143575000.H3K27ac.track.beta.pdf
hicPlotTADs --tracks GECODE.PRSS.macs2_narrowPeak.H3K4me3.track.beta.ini --region CM009453.1:143,500,000-143,575,000 -o GECODE.PRSS.macs2_narrowPeak.CM009453.1-143500000-143575000.H3K4me3.track.beta.pdf

hicPlotTADs --tracks GECODE.PRSS.macs2_narrowPeak.H3K27ac.track.MQ20.beta.ini --region CM009453.1:143,500,000-143,575,000 -o GECODE.PRSS.macs2_narrowPeak.CM009453.1-143500000-143575000.H3K27ac.track.MQ20.beta.pdf
hicPlotTADs --tracks GECODE.PRSS.macs2_narrowPeak.H3K4me3.track.MQ20.beta.ini --region CM009453.1:143,500,000-143,575,000 -o GECODE.PRSS.macs2_narrowPeak.CM009453.1-143500000-143575000.H3K4me3.track.MQ20.beta.pdf
hicPlotTADs --tracks GECODE.PRSS.macs2_narrowPeak.track.MQ20.beta.1.ini --region CM009453.1:143,500,000-143,575,000 -o GECODE.PRSS.macs2_narrowPeak.CM009453.1-143500000-143575000.track.MQ20.beta.1.pdf
hicPlotTADs --tracks GECODE.PRSS.macs2_narrowPeak.track.MQ20.beta.1.ini --region CM009453.1:143,507,000-143,563,000 -o GECODE.PRSS.macs2_narrowPeak.CM009453.1-143507000-143563000.track.MQ20.beta.1.pdf
hicPlotTADs --tracks GECODE.PRSS.macs2_narrowPeak.track.MQ20.beta.1.ini --region CM009453.1:143,450,000-143,600,000 -o GECODE.PRSS.macs2_narrowPeak.CM009453.1-143450000-143600000.track.MQ20.beta.1.pdf

hicPlotTADs --tracks KGP.PRSS_Hom_3copy.hic_track.beta.ini --region CM009453.1:143,450,000-143,600,000 -o KGP.PRSS_Hom_3copy.CM009453.1-143450000-143600000.hic_track.beta.pdf
hicPlotTADs --tracks KGP.PRSS_Hom_5copy.hic_track.beta.ini --region CM009453.1:143,450,000-143,600,000 -o KGP.PRSS_Hom_5copy.CM009453.1-143450000-143600000.hic_track.beta.pdf
hicPlotTADs --tracks GECODE.PRSS.hic_track.beta.ini --region CM009453.1:143,300,000-143,700,000 -o GECODE.PRSS.CM009453.1-143300000-143700000.hic_track.beta.pdf
hicPlotTADs --tracks pancreatic_cell_chipseq.PRSS.hic_track.beta.ini --region CM009453.1:143,300,000-143,700,000 -o pancreatic_cell_chipseq.PRSS.CM009453.1-143300000-143700000.hic_track.beta.pdf

hicPlotTADs --tracks KGP.PRSS_Hom_3copy.hic_track.refGRCh38_ALT.beta.ini --region chr7_KI270803v1_alt:740,000-815,000 -o KGP.PRSS_Hom_3copy.hic_track.refGRCh38_ALT.beta.pdf
hicPlotTADs --tracks KGP.PRSS_Hom_5copy.hic_track.refGRCh38_ALT.beta.ini --region chr7_KI270803v1_alt:740,000-815,000 -o KGP.PRSS_Hom_5copy.hic_track.refGRCh38_ALT.beta.pdf

10000
#######
hicFindTADs -m HG00513_10000_corrected.h5 --outPrefix HG00513_10000_corrected --correctForMultipleTesting fdr --numberOfProcessors 16



005-使用NA12878样本的HiC data，然后用armatus软件绘图
##########################################################################################
结果路径：/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/

01-把hic-pro生成的数据转化成 dense matrices
###########################################
python /picb/humpopg/xiebo/TAD/hic_pro/sparseToDense.py -b /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/5000/NA12878_5000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/5000/NA12878_5000.matrix --perchr

python /picb/humpopg/xiebo/TAD/hic_pro/sparseToDense.py -b /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/1000/NA12878_1000_abs.bed /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/1000/NA12878_1000.matrix -c CM009453.1

02-使用armatus检测TAD
###########################################
/picb/humpopg/xiebo/armatus-master/armatus-master/armatus -m -r 1000 -N -c CM009453.1 -i /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/1000/NA12878_1000_CM009453.1_dense.matrix.gz -g 1.0 -s 0.05 -o /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/1000/NA12878_1000_CM009453.1

/picb/humpopg/xiebo/armatus-master/armatus-master/armatus -m -r 5000 -N -c CM009453.1 -i /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/5000/NA12878_5000_CM009453.1_dense.matrix.gz -g 1.0 -s 0.05 -o /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/PRSS_HiC/results/NA12878/5000/NA12878_5000_CM009453.1
######################################
###/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/relate
######################################

####KGP snvs#######
bcftools view -v snps --threads 20 /picb/humpopg-bigdata/xiebo/NGS/reference/KGP_refGRCh38_SNV_INDEL/ALL.chr7.shapeit2_integrated_snvindels_v2a_27022019.GRCh38.phased.vcf.gz |bgzip -@20 -c > /picb/humpopg-bigdata/xiebo/NGS/reference/KGP_refGRCh38_SNV_INDEL/ALL.chr7.shapeit2_integrated_snvs_v2a_27022019.GRCh38.phased.vcf.gz

ln -s /picb/humpopg-bigdata/xiebo/NGS/reference/KGP_refGRCh38_SNV_INDEL/ALL.chr7.shapeit2_integrated_snvs_v2a_27022019.GRCh38.phased.vcf.gz /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/ALL.chr7.shapeit2_integrated_snvs_v2a_27022019.GRCh38.phased.vcf.gz
tabix -p vcf /picb/humpopg-bigdata/xiebo/NGS/reference/KGP_refGRCh38_SNV_INDEL/ALL.chr7.shapeit2_integrated_snvs_v2a_27022019.GRCh38.phased.vcf.gz

############################## 
###001-convert vcf to sample/hap (Prepate input files)
############################## 
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/bin/RelateFileFormats \
                 --mode ConvertFromVcf \
                 --haps KGP.snvs.chr7.test.haps \
                 --sample KGP.snvs.chr7.test.sample \
                 --chr 7 \
                 -i ALL.chr7.shapeit2_integrated_snvs_v2a_27022019.GRCh38.phased


/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/PrepareInputFiles/PrepareInputFiles.sh \
                 --haps KGP.snvs.chr7.haps \
                 --sample KGP.snvs.chr7.sample \
                 --ancestor /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/homo_sapiens_ancestor_7.fa \
                 --poplabels KGP.sample.poplabels \
                 -o KGP.snvs.chr7.relate_input 

###prepare *annot file
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/bin/RelateFileFormats \
                 --mode GenerateSNPAnnotations \
                 --haps KGP.snvs.chr7.haps \
                 --sample KGP.snvs.chr7.sample \
                 --poplabels KGP.sample.poplabels \
                 --ancestor homo_sapiens_ancestor_7.fa \
                 -o KGP.snvs.chr7

tar -czvPf picb_humpopg_xiebo.tar.gz /picb/humpopg-bigdata/xiebo/picb_humpopg_xiebo/test
tar -czvf picb_humpopg_xiebo.tar.gz -C /picb/humpopg/ xiebo
chr6-185557-SNP
/picb/humpopg/xiebo/armatus-2.2/examples/mES/eij/eij.chr15
##############################               
###002-run relate
##############################  
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/RelateParallel/RelateParallel.sh\
                  -m 1.25e-8 \
                  -N 30000 \
                  --haps /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.snvs.chr7.haps \
                  --sample /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.snvs.chr7.sample \
                  --map /picb/humpopg-bigdata5/wangyimin/resource/genetic_map_hg38/genetic_map_GRCh38_chr7 \
                  --annot /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.snvs.chr7.annot \
                  --seed 1 \
                  -o KGP.snvs.chr7 \
                  --threads 25 

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/RelateParallel/RelateParallel.sh\
                  -m 1.25e-8 \
                  -N 30000 \
                  --haps /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.snvs.chr7.relate_input.haps \
                  --sample /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.snvs.chr7.relate_input.sample \
                  --map /picb/humpopg-bigdata5/wangyimin/resource/genetic_map_hg38/genetic_map_GRCh38_chr7 \
                  --annot /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.snvs.chr7.relate_input.annot \
                  --seed 1 \
                  -o KGP.snvs.chr7.relate_input \
                  --threads 40 

############################## 
####003-Estimating effective population sizes
############################## 
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/EstimatePopulationSize/EstimatePopulationSize.sh \
              -i KGP.snvs.chr7.relate_input \
              -m 1.25e-8 \
              --poplabels /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.sample.poplabels \
              --seed 1 \
              --pop_of_interest YRI \
              --threshold 0 \
              --threads 25 \
              -o YRI_popsize.relate_input.test

/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/026-CLPS_CEL_relate/tools/relate_v1.1.9_x86_64_static/scripts/EstimatePopulationSize/EstimatePopulationSize.sh \
              -i KGP.snvs.chr7.relate_input \
              -m 1.25e-8 \
              --poplabels /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.sample.poplabels \
              --seed 1 \
              --pop_of_interest YRI \
              --threshold 0 \
              --threads 25 \
              -o YRI_popsize.relate_input.test

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/EstimatePopulationSize/EstimatePopulationSize.sh \
              -i KGP.snvs.chr7.relate_input \
              -m 1.25e-8 \
              --poplabels /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.sample.poplabels \
              --seed 1 \
              --pop_of_interest CEU \
              --threshold 0 \
              --threads 25 \
              -o CEU_popsize.relate_input

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/EstimatePopulationSize/EstimatePopulationSize.sh \
              -i KGP.snvs.chr7.relate_input \
              -m 1.25e-8 \
              --poplabels /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.sample.poplabels \
              --seed 1 \
              --pop_of_interest CHB \
              --threshold 0 \
              --threads 25 \
              -o CHB_popsize.relate_input

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/EstimatePopulationSize/EstimatePopulationSize.sh \
              -i KGP.snvs.chr7.relate_input \
              -m 1.25e-8 \
              --poplabels /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.sample.poplabels \
              --seed 1 \
              --threshold 0 \
              --threads 25 \
              -o KGP_popsize.relate_input


############################## 
####005-Sample branch lengths
############################## 

####################
chr7_142770582
####################
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142770582 \
                 -m 1.25e-8 \
                 --coal CHB_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142770582 \
                 --last_bp 142770582 \
                 --seed 1 

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i CEU_popsize.relate_input \
                 -o CEU_popsize.relate_input.chr7_142770582 \
                 -m 1.25e-8 \
                 --coal CEU_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142770582 \
                 --last_bp 142770582 \
                 --seed 1 

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i YRI_popsize.relate_input \
                 -o YRI_popsize.relate_input.chr7_142770582 \
                 -m 1.25e-8 \
                 --coal YRI_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142770582 \
                 --last_bp 142770582 \
                 --seed 1

####################
chr7_142762093
####################
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142762093 \
                 -m 1.25e-8 \
                 --coal CHB_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142762093 \
                 --last_bp 142762093 \
                 --seed 1 

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i CEU_popsize.relate_input \
                 -o CEU_popsize.relate_input.chr7_142762093 \
                 -m 1.25e-8 \
                 --coal CEU_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142762093 \
                 --last_bp 142762093 \
                 --seed 1

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i YRI_popsize.relate_input \
                 -o YRI_popsize.relate_input.chr7_142762093 \
                 -m 1.25e-8 \
                 --coal YRI_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142762093 \
                 --last_bp 142762093 \
                 --seed 1

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input \
                 -o /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142762093_test \
                 -m 1.25e-8 \
                 --coal /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142762093 \
                 --last_bp 142762093 \
                 --seed 1

/picb/pggtools/archives/relate_v1.0.16_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
				-m 1.25e-8 \
				--format b \
				--num_samples 5 \
				--coal Deng_popsize.chr12.relate_output.coal \
				-i Deng_popsize.chr12.relate_output \
				-o Deng_popsize.chr12.relate_output.chr12_12909168 \
				--first_bp 12909168 --last_bp 12909168

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
				-m 1.25e-8 \
				--format b \
				--num_samples 5 \
				--coal Deng_popsize.chr12.relate_output.coal \
				-i Deng_popsize.chr12.relate_output \
				-o Deng_popsize.chr12.relate_output.chr12_12909168 \
				--first_bp 12909168 --last_bp 12909168


####################
chr7_142778093
####################
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142778093 \
                 -m 1.25e-8 \
                 --coal CHB_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142778093 \
                 --last_bp 142778093 \
                 --seed 1 

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i CEU_popsize.relate_input \
                 -o CEU_popsize.relate_input.chr7_142778093 \
                 -m 1.25e-8 \
                 --coal CEU_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142778093 \
                 --last_bp 142778093 \
                 --seed 1

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i YRI_popsize.relate_input \
                 -o YRI_popsize.relate_input.chr7_142778093 \
                 -m 1.25e-8 \
                 --coal YRI_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142778093 \
                 --last_bp 142778093 \
                 --seed 1


####################
chr7_142746720_142778572
####################
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142746720_142778572 \
                 -m 1.25e-8 \
                 --coal CHB_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142746720 \
                 --last_bp 142778572 \
                 --seed 1 

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i CEU_popsize.relate_input \
                 -o CEU_popsize.relate_input.chr7_142746720_142778572 \
                 -m 1.25e-8 \
                 --coal CEU_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142746720 \
                 --last_bp 142778572 \
                 --seed 1

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i YRI_popsize.relate_input \
                 -o YRI_popsize.relate_input.chr7_142746720_142778572 \
                 -m 1.25e-8 \
                 --coal YRI_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142746720 \
                 --last_bp 142778572 \
                 --seed 1

############################## 
####006-Detect positive selection
############################## 

####################
chr7_142770582
####################
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142770582_selection \
                 -m 1.25e-8 \
                 --first_bp 142770582 \
                 --last_bp 142770582 \
                 --years_per_gen 28 \
                 --coal CHB_popsize.relate_input.coal 
python convert_file_tap.py CHB_popsize.relate_input.chr7_142770582_selection.freq CHB_popsize.relate_input.chr7_142770582_selection.freq.txt
python convert_file_tap.py CHB_popsize.relate_input.chr7_142770582_selection.sele CHB_popsize.relate_input.chr7_142770582_selection.sele.txt

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CEU_popsize.relate_input \
                 -o CEU_popsize.relate_input.chr7_142770582_selection \
                 -m 1.25e-8 \
                 --first_bp 142770582 \
                 --last_bp 142770582 \
                 --years_per_gen 28 \
                 --coal CEU_popsize.relate_input.coal 
python convert_file_tap.py CEU_popsize.relate_input.chr7_142770582_selection.freq CEU_popsize.relate_input.chr7_142770582_selection.freq.txt
python convert_file_tap.py CEU_popsize.relate_input.chr7_142770582_selection.sele CEU_popsize.relate_input.chr7_142770582_selection.sele.txt

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i YRI_popsize.relate_input \
                 -o YRI_popsize.relate_input.chr7_142770582_selection \
                 -m 1.25e-8 \
                 --first_bp 142770582 \
                 --last_bp 142770582 \
                 --years_per_gen 28 \
                 --coal YRI_popsize.relate_input.coal 
python convert_file_tap.py YRI_popsize.relate_input.chr7_142770582_selection.freq YRI_popsize.relate_input.chr7_142770582_selection.freq.txt
python convert_file_tap.py YRI_popsize.relate_input.chr7_142770582_selection.sele YRI_popsize.relate_input.chr7_142770582_selection.sele.txt


####################
chr7_142762093
####################
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142762093_selection \
                 -m 1.25e-8 \
                 --first_bp 142762093 \
                 --last_bp 142762093 \
                 --years_per_gen 28 \
                 --coal CHB_popsize.relate_input.coal 
python convert_file_tap.py CHB_popsize.relate_input.chr7_142762093_selection.freq CHB_popsize.relate_input.chr7_142762093_selection.freq.txt
python convert_file_tap.py CHB_popsize.relate_input.chr7_142762093_selection.sele CHB_popsize.relate_input.chr7_142762093_selection.sele.txt

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CEU_popsize.relate_input \
                 -o CEU_popsize.relate_input.chr7_142762093_selection \
                 -m 1.25e-8 \
                 --first_bp 142762093 \
                 --last_bp 142762093 \
                 --years_per_gen 28 \
                 --coal CEU_popsize.relate_input.coal 
python convert_file_tap.py CEU_popsize.relate_input.chr7_142762093_selection.freq CEU_popsize.relate_input.chr7_142762093_selection.freq.txt
python convert_file_tap.py CEU_popsize.relate_input.chr7_142762093_selection.sele CEU_popsize.relate_input.chr7_142762093_selection.sele.txt

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i YRI_popsize.relate_input \
                 -o YRI_popsize.relate_input.chr7_142762093_selection \
                 -m 1.25e-8 \
                 --first_bp 142762093 \
                 --last_bp 142762093 \
                 --years_per_gen 28 \
                 --coal YRI_popsize.relate_input.coal 
python convert_file_tap.py YRI_popsize.relate_input.chr7_142762093_selection.freq YRI_popsize.relate_input.chr7_142762093_selection.freq.txt
python convert_file_tap.py YRI_popsize.relate_input.chr7_142762093_selection.sele YRI_popsize.relate_input.chr7_142762093_selection.sele.txt


####################
chr7_142778093
####################
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142778093_selection \
                 -m 1.25e-8 \
                 --first_bp 142778093 \
                 --last_bp 142778093 \
                 --years_per_gen 28 \
                 --coal CHB_popsize.relate_input.coal 
python convert_file_tap.py CHB_popsize.relate_input.chr7_142778093_selection.freq CHB_popsize.relate_input.chr7_142778093_selection.freq.txt
python convert_file_tap.py CHB_popsize.relate_input.chr7_142778093_selection.sele CHB_popsize.relate_input.chr7_142778093_selection.sele.txt

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CEU_popsize.relate_input \
                 -o CEU_popsize.relate_input.chr7_142778093_selection \
                 -m 1.25e-8 \
                 --first_bp 142778093 \
                 --last_bp 142778093 \
                 --years_per_gen 28 \
                 --coal CEU_popsize.relate_input.coal 
python convert_file_tap.py CEU_popsize.relate_input.chr7_142778093_selection.freq CEU_popsize.relate_input.chr7_142778093_selection.freq.txt
python convert_file_tap.py CEU_popsize.relate_input.chr7_142778093_selection.sele CEU_popsize.relate_input.chr7_142778093_selection.sele.txt

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i YRI_popsize.relate_input \
                 -o YRI_popsize.relate_input.chr7_142778093_selection \
                 -m 1.25e-8 \
                 --first_bp 142778093 \
                 --last_bp 142778093 \
                 --years_per_gen 28 \
                 --coal YRI_popsize.relate_input.coal 
python convert_file_tap.py YRI_popsize.relate_input.chr7_142778093_selection.freq YRI_popsize.relate_input.chr7_142778093_selection.freq.txt
python convert_file_tap.py YRI_popsize.relate_input.chr7_142778093_selection.sele YRI_popsize.relate_input.chr7_142778093_selection.sele.txt


####################
chr7_142746720_142778572
####################
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142746720_142778572_selection \
                 -m 1.25e-8 \
                 --first_bp 142746720 \
                 --last_bp 142778572 \
                 --years_per_gen 28 \
                 --coal CHB_popsize.relate_input.coal 
python convert_file_tap.py CHB_popsize.relate_input.chr7_142746720_142778572_selection.freq CHB_popsize.relate_input.chr7_142746720_142778572_selection.freq.txt
python convert_file_tap.py CHB_popsize.relate_input.chr7_142746720_142778572_selection.sele CHB_popsize.relate_input.chr7_142746720_142778572_selection.sele.txt

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CEU_popsize.relate_input \
                 -o CEU_popsize.relate_input.chr7_142746720_142778572_selection \
                 -m 1.25e-8 \
                 --first_bp 142746720 \
                 --last_bp 142778572 \
                 --years_per_gen 28 \
                 --coal CEU_popsize.relate_input.coal 
python convert_file_tap.py CEU_popsize.relate_input.chr7_142746720_142778572_selection.freq CEU_popsize.relate_input.chr7_142746720_142778572_selection.freq.txt
python convert_file_tap.py CEU_popsize.relate_input.chr7_142746720_142778572_selection.sele CEU_popsize.relate_input.chr7_142746720_142778572_selection.sele.txt

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i YRI_popsize.relate_input \
                 -o YRI_popsize.relate_input.chr7_142746720_142778572_selection \
                 -m 1.25e-8 \
                 --first_bp 142746720 \
                 --last_bp 142778572 \
                 --years_per_gen 28 \
                 --coal YRI_popsize.relate_input.coal 
python convert_file_tap.py YRI_popsize.relate_input.chr7_142746720_142778572_selection.freq YRI_popsize.relate_input.chr7_142746720_142778572_selection.freq.txt
python convert_file_tap.py YRI_popsize.relate_input.chr7_142746720_142778572_selection.sele YRI_popsize.relate_input.chr7_142746720_142778572_selection.sele.txt


/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142762093_selection_tmp \
                 -m 1.25e-8 \
                 --first_bp 142762093 \
                 --last_bp 142762093 \
                 --years_per_gen 28 \
                 --coal CHB_popsize.relate_input.coal 
python convert_file_tap.py CHB_popsize.relate_input.chr7_142762093_selection_tmp.freq CHB_popsize.relate_input.chr7_142762093_selection_tmp.freq.txt
python convert_file_tap.py CHB_popsize.relate_input.chr7_142762093_selection_tmp.sele CHB_popsize.relate_input.chr7_142762093_selection_tmp.sele.txt


############################## 
####007-run clues
##############################
注意：应该需要到"/picb/humpopg-bigdata5/xiebo/software/clues/clues-master/" 路径下执行该文件

BIOSTATISTICS
#########################
chr7_142770582
#########################
结果目录：/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142770582-A-G/

CHB
#######################
/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times CHB_popsize.relate_input.chr7-142770582-A-G.random_1 --tCutoff 2500 --out CHB_popsize.relate_input.chr7-142770582-A-G.tCutoff_2500.random_1.selection_clues_beta_out > CHB_popsize.relate_input.chr7-142770582-A-G.tCutoff_2500.random_1.selection_clues_beta_out.sele_value.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times CHB_popsize.relate_input.chr7-142770582-A-G.random_1 --tCutoff 2000 --out CHB_popsize.relate_input.chr7-142770582-A-G.tCutoff_2000.random_1.selection_clues_beta_out > CHB_popsize.relate_input.chr7-142770582-A-G.tCutoff_2000.random_1.selection_clues_beta_out.sele_value.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times CHB_popsize.relate_input.chr7-142770582-A-G.random_1 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.beta.txt --tCutoff 7500 --out CHB_popsize.relate_input.chr7-142770582-A-G.tCutoff_7500.random_1.selection_clues_beta_out > CHB_popsize.relate_input.chr7-142770582-A-G.tCutoff_7500.random_1.selection_clues_beta_out.sele_value.txt

CEU
#######################
/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times CEU_popsize.relate_input.chr7-142770582-A-G.random_1 --tCutoff 2500 --out CEU_popsize.relate_input.chr7-142770582-A-G.tCutoff_2500.random_1.selection_clues_beta_out > CEU_popsize.relate_input.chr7-142770582-A-G.tCutoff_2500.random_1.selection_clues_beta_out.sele_value.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times CEU_popsize.relate_input.chr7-142770582-A-G.random_1 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.beta.txt --tCutoff 7500 --out CEU_popsize.relate_input.chr7-142770582-A-G.tCutoff_7500.random_1.selection_clues_beta_out > CEU_popsize.relate_input.chr7-142770582-A-G.tCutoff_7500.random_1.selection_clues_beta_out.sele_value.txt

YRI
#######################
/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times YRI_popsize.relate_input.chr7-142770582-A-G.random_1 --tCutoff 7500 --out YRI_popsize.relate_input.chr7-142770582-A-G.tCutoff_7500.random_1.selection_clues_out > YRI_popsize.relate_input.chr7-142770582-A-G.tCutoff_7500.random_1.selection_clues_out.sele_value.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times YRI_popsize.relate_input.chr7-142770582-A-G.random_1 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.beta.txt --tCutoff 7500 --out YRI_popsize.relate_input.chr7-142770582-A-G.tCutoff_7500.random_1.selection_clues_beta_out > YRI_popsize.relate_input.chr7-142770582-A-G.tCutoff_7500.random_1.selection_clues_beta_out.sele_value.txt


#########################
chr7_142778093
#########################
CHB
#######################
/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142778093 --tCutoff 3000 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.tCutoff_3000.chr7_142778093_selection_clues_out


CEU
#######################
/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142778093 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142778093_selection_clues_out


YRI
#######################
/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142778093 --tCutoff 3000 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.tCutoff_3000.chr7_142778093_selection_clues_out



#########################
chr7-142762093-C-G
#########################
CHB
#######################
python inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093_selection_clues_out

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093 --tCutoff 2000 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CHB_popsize.relate_input.tCutoff2000.chr7_142762093_selection_clues_out > CHB_popsize.relate_input.tCutoff2000.chr7_142762093_selection_clues_out.sign.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.Bin_200gens.Cutoff3000.txt --tCutoff 3000 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CHB_popsize.relate_input.tCutoff3000.chr7_142762093_selection_clues_beta_out > CHB_popsize.relate_input.tCutoff3000.chr7_142762093_selection_clues_beta_out.sign.beta.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.beta.txt --tCutoff 7500 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CHB_popsize.relate_input.tCutoff7500.chr7_142762093_selection_clues_beta_out > CHB_popsize.relate_input.tCutoff7500.chr7_142762093_selection_clues_beta_out.sign.beta.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.Bin_200gens.txt --tCutoff 7600 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CHB_popsize.relate_input.tCutoff7600.chr7_142762093_selection_clues_Bin_200gens_beta_out > CHB_popsize.relate_input.tCutoff7600.chr7_142762093_selection_clues_Bin_200gens_beta_out.sign.beta.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.Bin_350gens.txt --tCutoff 7700 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CHB_popsize.relate_input.tCutoff7700.chr7_142762093_selection_clues_Bin_350gens_beta_out > CHB_popsize.relate_input.tCutoff7700.chr7_142762093_selection_clues_Bin_350gens_beta_out.sign.beta.txt

epochs = np.load("/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093_selection_clues_out.epochs.npy")
freqs = np.load("/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093_selection_clues_out.freqs.npy")
logpost = np.load("/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093_selection_clues_out.post.npy")

python /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/tools/003-manage_freq_traj.py CHB_popsize.relate_input.chr7_142762093_selection_clues_out CHB_popsize.relate_input.chr7_142762093_selection_clues_out 


CEU
#######################
python inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093_selection_clues_out
python plot_traj.py  /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093_selection_clues_out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093_selection_clues_out_fig

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093 --tCutoff 2000 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CEU_popsize.relate_input.tCutoff2000.chr7_142762093_selection_clues_out > CEU_popsize.relate_input.tCutoff2000.chr7_142762093_selection_clues_out.sign.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.Bin_200gens.Cutoff3000.txt --tCutoff 3000 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CEU_popsize.relate_input.tCutoff3000.chr7_142762093_selection_clues_beta_out > CEU_popsize.relate_input.tCutoff3000.chr7_142762093_selection_clues_beta_out.sign.beta.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.Bin_200gens.txt --tCutoff 7600 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CEU_popsize.relate_input.tCutoff7600.chr7_142762093_selection_clues_Bin_200gens_beta_out > CEU_popsize.relate_input.tCutoff7600.chr7_142762093_selection_clues_Bin_200gens_beta_out.sign.beta.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.Bin_350gens.txt --tCutoff 7700 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CEU_popsize.relate_input.tCutoff7700.chr7_142762093_selection_clues_Bin_350gens_beta_out > CEU_popsize.relate_input.tCutoff7700.chr7_142762093_selection_clues_Bin_350gens_beta_out.sign.beta.txt


/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.beta.txt --tCutoff 7500 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CEU_popsize.relate_input.tCutoff7500.chr7_142762093_selection_clues_beta_out > CEU_popsize.relate_input.tCutoff7500.chr7_142762093_selection_clues_beta_out.sign.beta.txt


YRI
#######################
python inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142762093 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142762093_selection_clues_out
python plot_traj.py  /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142762093_selection_clues_out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142762093_selection_clues_out_fig


#########################
chr7_142778093
#########################
CHB
#######################
python inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142778093 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142778093_selection_clues_out
python plot_traj.py  /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142778093_selection_clues_out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142778093_selection_clues_out_fig

CEU
#######################
python inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142778093 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142778093_selection_clues_out
python plot_traj.py  /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142778093_selection_clues_out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142778093_selection_clues_out_fig

YRI
#######################
python inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142778093 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142778093_selection_clues_out
python plot_traj.py  /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142778093_selection_clues_out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142778093_selection_clues_out_fig######################################
###/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/relate
######################################
注意：我按照的relate使用遇到了问题，改用pggtools的relate了

####KGP snvs#######
bcftools view -v snps --threads 20 /picb/humpopg-bigdata/xiebo/NGS/reference/KGP_refGRCh38_SNV_INDEL/ALL.chr7.shapeit2_integrated_snvindels_v2a_27022019.GRCh38.phased.vcf.gz |bgzip -@20 -c > /picb/humpopg-bigdata/xiebo/NGS/reference/KGP_refGRCh38_SNV_INDEL/ALL.chr7.shapeit2_integrated_snvs_v2a_27022019.GRCh38.phased.vcf.gz

ln -s /picb/humpopg-bigdata/xiebo/NGS/reference/KGP_refGRCh38_SNV_INDEL/ALL.chr7.shapeit2_integrated_snvs_v2a_27022019.GRCh38.phased.vcf.gz /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/ALL.chr7.shapeit2_integrated_snvs_v2a_27022019.GRCh38.phased.vcf.gz
tabix -p vcf /picb/humpopg-bigdata/xiebo/NGS/reference/KGP_refGRCh38_SNV_INDEL/ALL.chr7.shapeit2_integrated_snvs_v2a_27022019.GRCh38.phased.vcf.gz

############################## 
###001-convert vcf to sample/hap (Prepate input files)
############################## 
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/bin/RelateFileFormats \
                 --mode ConvertFromVcf \
                 --haps KGP.snvs.chr7.test.haps \
                 --sample KGP.snvs.chr7.test.sample \
                 --chr 7 \
                 -i ALL.chr7.shapeit2_integrated_snvs_v2a_27022019.GRCh38.phased


/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/PrepareInputFiles/PrepareInputFiles.sh \
                 --haps KGP.snvs.chr7.haps \
                 --sample KGP.snvs.chr7.sample \
                 --ancestor /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/homo_sapiens_ancestor_7.fa \
                 --poplabels KGP.sample.poplabels \
                 -o KGP.snvs.chr7.relate_input 

###prepare *annot file
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/bin/RelateFileFormats \
                 --mode GenerateSNPAnnotations \
                 --haps KGP.snvs.chr7.haps \
                 --sample KGP.snvs.chr7.sample \
                 --poplabels KGP.sample.poplabels \
                 --ancestor homo_sapiens_ancestor_7.fa \
                 -o KGP.snvs.chr7

tar -czvPf picb_humpopg_xiebo.tar.gz /picb/humpopg-bigdata/xiebo/picb_humpopg_xiebo/test
tar -czvf picb_humpopg_xiebo.tar.gz -C /picb/humpopg/ xiebo
chr6-185557-SNP
/picb/humpopg/xiebo/armatus-2.2/examples/mES/eij/eij.chr15
##############################               
###002-run relate
##############################  
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/RelateParallel/RelateParallel.sh\
                  -m 1.25e-8 \
                  -N 30000 \
                  --haps /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.snvs.chr7.haps \
                  --sample /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.snvs.chr7.sample \
                  --map /picb/humpopg-bigdata5/wangyimin/resource/genetic_map_hg38/genetic_map_GRCh38_chr7 \
                  --annot /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.snvs.chr7.annot \
                  --seed 1 \
                  -o KGP.snvs.chr7 \
                  --threads 25 

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/RelateParallel/RelateParallel.sh\
                  -m 1.25e-8 \
                  -N 30000 \
                  --haps /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.snvs.chr7.relate_input.haps \
                  --sample /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.snvs.chr7.relate_input.sample \
                  --map /picb/humpopg-bigdata5/wangyimin/resource/genetic_map_hg38/genetic_map_GRCh38_chr7 \
                  --annot /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.snvs.chr7.relate_input.annot \
                  --seed 1 \
                  -o KGP.snvs.chr7.relate_input \
                  --threads 40 

############################## 
####003-Estimating effective population sizes
############################## 
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/EstimatePopulationSize/EstimatePopulationSize.sh \
              -i KGP.snvs.chr7.relate_input \
              -m 1.25e-8 \
              --poplabels /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.sample.poplabels \
              --seed 1 \
              --pop_of_interest YRI \
              --threshold 0 \
              --threads 25 \
              -o YRI_popsize.relate_input.test

/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/026-CLPS_CEL_relate/tools/relate_v1.1.9_x86_64_static/scripts/EstimatePopulationSize/EstimatePopulationSize.sh \
              -i KGP.snvs.chr7.relate_input \
              -m 1.25e-8 \
              --poplabels /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.sample.poplabels \
              --seed 1 \
              --pop_of_interest YRI \
              --threshold 0 \
              --threads 25 \
              -o YRI_popsize.relate_input.test

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/EstimatePopulationSize/EstimatePopulationSize.sh \
              -i KGP.snvs.chr7.relate_input \
              -m 1.25e-8 \
              --poplabels /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.sample.poplabels \
              --seed 1 \
              --pop_of_interest CEU \
              --threshold 0 \
              --threads 25 \
              -o CEU_popsize.relate_input

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/EstimatePopulationSize/EstimatePopulationSize.sh \
              -i KGP.snvs.chr7.relate_input \
              -m 1.25e-8 \
              --poplabels /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.sample.poplabels \
              --seed 1 \
              --pop_of_interest CHB \
              --threshold 0 \
              --threads 25 \
              -o CHB_popsize.relate_input

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/EstimatePopulationSize/EstimatePopulationSize.sh \
              -i KGP.snvs.chr7.relate_input \
              -m 1.25e-8 \
              --poplabels /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/reference/KGP.sample.poplabels \
              --seed 1 \
              --threshold 0 \
              --threads 25 \
              -o KGP_popsize.relate_input


############################## 
####005-Sample branch lengths
############################## 

####################
chr7_142770582
####################
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142770582 \
                 -m 1.25e-8 \
                 --coal CHB_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142770582 \
                 --last_bp 142770582 \
                 --seed 1 

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i CEU_popsize.relate_input \
                 -o CEU_popsize.relate_input.chr7_142770582 \
                 -m 1.25e-8 \
                 --coal CEU_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142770582 \
                 --last_bp 142770582 \
                 --seed 1 

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i YRI_popsize.relate_input \
                 -o YRI_popsize.relate_input.chr7_142770582 \
                 -m 1.25e-8 \
                 --coal YRI_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142770582 \
                 --last_bp 142770582 \
                 --seed 1

####################
chr7_142762093
####################
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142762093 \
                 -m 1.25e-8 \
                 --coal CHB_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142762093 \
                 --last_bp 142762093 \
                 --seed 1 

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i CEU_popsize.relate_input \
                 -o CEU_popsize.relate_input.chr7_142762093 \
                 -m 1.25e-8 \
                 --coal CEU_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142762093 \
                 --last_bp 142762093 \
                 --seed 1

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i YRI_popsize.relate_input \
                 -o YRI_popsize.relate_input.chr7_142762093 \
                 -m 1.25e-8 \
                 --coal YRI_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142762093 \
                 --last_bp 142762093 \
                 --seed 1

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input \
                 -o /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142762093_test \
                 -m 1.25e-8 \
                 --coal /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142762093 \
                 --last_bp 142762093 \
                 --seed 1

/picb/pggtools/archives/relate_v1.0.16_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                -m 1.25e-8 \
                --format b \
                --num_samples 5 \
                --coal Deng_popsize.chr12.relate_output.coal \
                -i Deng_popsize.chr12.relate_output \
                -o Deng_popsize.chr12.relate_output.chr12_12909168 \
                --first_bp 12909168 --last_bp 12909168

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                -m 1.25e-8 \
                --format b \
                --num_samples 5 \
                --coal Deng_popsize.chr12.relate_output.coal \
                -i Deng_popsize.chr12.relate_output \
                -o Deng_popsize.chr12.relate_output.chr12_12909168 \
                --first_bp 12909168 --last_bp 12909168


####################
chr7_142778093
####################
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142778093 \
                 -m 1.25e-8 \
                 --coal CHB_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142778093 \
                 --last_bp 142778093 \
                 --seed 1 

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i CEU_popsize.relate_input \
                 -o CEU_popsize.relate_input.chr7_142778093 \
                 -m 1.25e-8 \
                 --coal CEU_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142778093 \
                 --last_bp 142778093 \
                 --seed 1

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i YRI_popsize.relate_input \
                 -o YRI_popsize.relate_input.chr7_142778093 \
                 -m 1.25e-8 \
                 --coal YRI_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142778093 \
                 --last_bp 142778093 \
                 --seed 1


####################
chr7_142746720_142778572
####################
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142746720_142778572 \
                 -m 1.25e-8 \
                 --coal CHB_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142746720 \
                 --last_bp 142778572 \
                 --seed 1 

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i CEU_popsize.relate_input \
                 -o CEU_popsize.relate_input.chr7_142746720_142778572 \
                 -m 1.25e-8 \
                 --coal CEU_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142746720 \
                 --last_bp 142778572 \
                 --seed 1

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/SampleBranchLengths/SampleBranchLengths.sh \
                 -i YRI_popsize.relate_input \
                 -o YRI_popsize.relate_input.chr7_142746720_142778572 \
                 -m 1.25e-8 \
                 --coal YRI_popsize.relate_input.coal \
                 --format b \
                 --num_samples 5 \
                 --first_bp 142746720 \
                 --last_bp 142778572 \
                 --seed 1

############################## 
####006-Detect positive selection
############################## 

####################
chr7_142770582
####################
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142770582_selection \
                 -m 1.25e-8 \
                 --first_bp 142770582 \
                 --last_bp 142770582 \
                 --years_per_gen 28 \
                 --coal CHB_popsize.relate_input.coal 
python convert_file_tap.py CHB_popsize.relate_input.chr7_142770582_selection.freq CHB_popsize.relate_input.chr7_142770582_selection.freq.txt
python convert_file_tap.py CHB_popsize.relate_input.chr7_142770582_selection.sele CHB_popsize.relate_input.chr7_142770582_selection.sele.txt

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CEU_popsize.relate_input \
                 -o CEU_popsize.relate_input.chr7_142770582_selection \
                 -m 1.25e-8 \
                 --first_bp 142770582 \
                 --last_bp 142770582 \
                 --years_per_gen 28 \
                 --coal CEU_popsize.relate_input.coal 
python convert_file_tap.py CEU_popsize.relate_input.chr7_142770582_selection.freq CEU_popsize.relate_input.chr7_142770582_selection.freq.txt
python convert_file_tap.py CEU_popsize.relate_input.chr7_142770582_selection.sele CEU_popsize.relate_input.chr7_142770582_selection.sele.txt

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i YRI_popsize.relate_input \
                 -o YRI_popsize.relate_input.chr7_142770582_selection \
                 -m 1.25e-8 \
                 --first_bp 142770582 \
                 --last_bp 142770582 \
                 --years_per_gen 28 \
                 --coal YRI_popsize.relate_input.coal 
python convert_file_tap.py YRI_popsize.relate_input.chr7_142770582_selection.freq YRI_popsize.relate_input.chr7_142770582_selection.freq.txt
python convert_file_tap.py YRI_popsize.relate_input.chr7_142770582_selection.sele YRI_popsize.relate_input.chr7_142770582_selection.sele.txt


####################
chr7_142762093
####################
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142762093_selection \
                 -m 1.25e-8 \
                 --first_bp 142762093 \
                 --last_bp 142762093 \
                 --years_per_gen 28 \
                 --coal CHB_popsize.relate_input.coal 
python convert_file_tap.py CHB_popsize.relate_input.chr7_142762093_selection.freq CHB_popsize.relate_input.chr7_142762093_selection.freq.txt
python convert_file_tap.py CHB_popsize.relate_input.chr7_142762093_selection.sele CHB_popsize.relate_input.chr7_142762093_selection.sele.txt

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CEU_popsize.relate_input \
                 -o CEU_popsize.relate_input.chr7_142762093_selection \
                 -m 1.25e-8 \
                 --first_bp 142762093 \
                 --last_bp 142762093 \
                 --years_per_gen 28 \
                 --coal CEU_popsize.relate_input.coal 
python convert_file_tap.py CEU_popsize.relate_input.chr7_142762093_selection.freq CEU_popsize.relate_input.chr7_142762093_selection.freq.txt
python convert_file_tap.py CEU_popsize.relate_input.chr7_142762093_selection.sele CEU_popsize.relate_input.chr7_142762093_selection.sele.txt

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i YRI_popsize.relate_input \
                 -o YRI_popsize.relate_input.chr7_142762093_selection \
                 -m 1.25e-8 \
                 --first_bp 142762093 \
                 --last_bp 142762093 \
                 --years_per_gen 28 \
                 --coal YRI_popsize.relate_input.coal 
python convert_file_tap.py YRI_popsize.relate_input.chr7_142762093_selection.freq YRI_popsize.relate_input.chr7_142762093_selection.freq.txt
python convert_file_tap.py YRI_popsize.relate_input.chr7_142762093_selection.sele YRI_popsize.relate_input.chr7_142762093_selection.sele.txt


####################
chr7_142778093
####################
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142778093_selection \
                 -m 1.25e-8 \
                 --first_bp 142778093 \
                 --last_bp 142778093 \
                 --years_per_gen 28 \
                 --coal CHB_popsize.relate_input.coal 
python convert_file_tap.py CHB_popsize.relate_input.chr7_142778093_selection.freq CHB_popsize.relate_input.chr7_142778093_selection.freq.txt
python convert_file_tap.py CHB_popsize.relate_input.chr7_142778093_selection.sele CHB_popsize.relate_input.chr7_142778093_selection.sele.txt

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CEU_popsize.relate_input \
                 -o CEU_popsize.relate_input.chr7_142778093_selection \
                 -m 1.25e-8 \
                 --first_bp 142778093 \
                 --last_bp 142778093 \
                 --years_per_gen 28 \
                 --coal CEU_popsize.relate_input.coal 
python convert_file_tap.py CEU_popsize.relate_input.chr7_142778093_selection.freq CEU_popsize.relate_input.chr7_142778093_selection.freq.txt
python convert_file_tap.py CEU_popsize.relate_input.chr7_142778093_selection.sele CEU_popsize.relate_input.chr7_142778093_selection.sele.txt

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i YRI_popsize.relate_input \
                 -o YRI_popsize.relate_input.chr7_142778093_selection \
                 -m 1.25e-8 \
                 --first_bp 142778093 \
                 --last_bp 142778093 \
                 --years_per_gen 28 \
                 --coal YRI_popsize.relate_input.coal 
python convert_file_tap.py YRI_popsize.relate_input.chr7_142778093_selection.freq YRI_popsize.relate_input.chr7_142778093_selection.freq.txt
python convert_file_tap.py YRI_popsize.relate_input.chr7_142778093_selection.sele YRI_popsize.relate_input.chr7_142778093_selection.sele.txt


####################
chr7_142746720_142778572
####################
/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142746720_142778572_selection \
                 -m 1.25e-8 \
                 --first_bp 142746720 \
                 --last_bp 142778572 \
                 --years_per_gen 28 \
                 --coal CHB_popsize.relate_input.coal 
python convert_file_tap.py CHB_popsize.relate_input.chr7_142746720_142778572_selection.freq CHB_popsize.relate_input.chr7_142746720_142778572_selection.freq.txt
python convert_file_tap.py CHB_popsize.relate_input.chr7_142746720_142778572_selection.sele CHB_popsize.relate_input.chr7_142746720_142778572_selection.sele.txt

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CEU_popsize.relate_input \
                 -o CEU_popsize.relate_input.chr7_142746720_142778572_selection \
                 -m 1.25e-8 \
                 --first_bp 142746720 \
                 --last_bp 142778572 \
                 --years_per_gen 28 \
                 --coal CEU_popsize.relate_input.coal 
python convert_file_tap.py CEU_popsize.relate_input.chr7_142746720_142778572_selection.freq CEU_popsize.relate_input.chr7_142746720_142778572_selection.freq.txt
python convert_file_tap.py CEU_popsize.relate_input.chr7_142746720_142778572_selection.sele CEU_popsize.relate_input.chr7_142746720_142778572_selection.sele.txt

/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i YRI_popsize.relate_input \
                 -o YRI_popsize.relate_input.chr7_142746720_142778572_selection \
                 -m 1.25e-8 \
                 --first_bp 142746720 \
                 --last_bp 142778572 \
                 --years_per_gen 28 \
                 --coal YRI_popsize.relate_input.coal 
python convert_file_tap.py YRI_popsize.relate_input.chr7_142746720_142778572_selection.freq YRI_popsize.relate_input.chr7_142746720_142778572_selection.freq.txt
python convert_file_tap.py YRI_popsize.relate_input.chr7_142746720_142778572_selection.sele YRI_popsize.relate_input.chr7_142746720_142778572_selection.sele.txt


/picb/humpopg-bigdata5/xiebo/software/relate/relate_v1.1.8_x86_64_static/scripts/DetectSelection/DetectSelection.sh \
                 -i CHB_popsize.relate_input \
                 -o CHB_popsize.relate_input.chr7_142762093_selection_tmp \
                 -m 1.25e-8 \
                 --first_bp 142762093 \
                 --last_bp 142762093 \
                 --years_per_gen 28 \
                 --coal CHB_popsize.relate_input.coal 
python convert_file_tap.py CHB_popsize.relate_input.chr7_142762093_selection_tmp.freq CHB_popsize.relate_input.chr7_142762093_selection_tmp.freq.txt
python convert_file_tap.py CHB_popsize.relate_input.chr7_142762093_selection_tmp.sele CHB_popsize.relate_input.chr7_142762093_selection_tmp.sele.txt


############################## 
####007-run clues
##############################
注意：应该需要到"/picb/humpopg-bigdata5/xiebo/software/clues/clues-master/" 路径下执行该文件

BIOSTATISTICS
#########################
chr7_142770582
#########################
结果目录：/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142770582-A-G/

CHB
#######################
/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times CHB_popsize.relate_input.chr7-142770582-A-G.random_1 --tCutoff 2500 --out CHB_popsize.relate_input.chr7-142770582-A-G.tCutoff_2500.random_1.selection_clues_beta_out > CHB_popsize.relate_input.chr7-142770582-A-G.tCutoff_2500.random_1.selection_clues_beta_out.sele_value.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times CHB_popsize.relate_input.chr7-142770582-A-G.random_1 --tCutoff 2000 --out CHB_popsize.relate_input.chr7-142770582-A-G.tCutoff_2000.random_1.selection_clues_beta_out > CHB_popsize.relate_input.chr7-142770582-A-G.tCutoff_2000.random_1.selection_clues_beta_out.sele_value.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times CHB_popsize.relate_input.chr7-142770582-A-G.random_1 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.beta.txt --tCutoff 7500 --out CHB_popsize.relate_input.chr7-142770582-A-G.tCutoff_7500.random_1.selection_clues_beta_out > CHB_popsize.relate_input.chr7-142770582-A-G.tCutoff_7500.random_1.selection_clues_beta_out.sele_value.txt

CEU
#######################
/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times CEU_popsize.relate_input.chr7-142770582-A-G.random_1 --tCutoff 2500 --out CEU_popsize.relate_input.chr7-142770582-A-G.tCutoff_2500.random_1.selection_clues_beta_out > CEU_popsize.relate_input.chr7-142770582-A-G.tCutoff_2500.random_1.selection_clues_beta_out.sele_value.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times CEU_popsize.relate_input.chr7-142770582-A-G.random_1 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.beta.txt --tCutoff 7500 --out CEU_popsize.relate_input.chr7-142770582-A-G.tCutoff_7500.random_1.selection_clues_beta_out > CEU_popsize.relate_input.chr7-142770582-A-G.tCutoff_7500.random_1.selection_clues_beta_out.sele_value.txt

YRI
#######################
/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times YRI_popsize.relate_input.chr7-142770582-A-G.random_1 --tCutoff 7500 --out YRI_popsize.relate_input.chr7-142770582-A-G.tCutoff_7500.random_1.selection_clues_out > YRI_popsize.relate_input.chr7-142770582-A-G.tCutoff_7500.random_1.selection_clues_out.sele_value.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times YRI_popsize.relate_input.chr7-142770582-A-G.random_1 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.beta.txt --tCutoff 7500 --out YRI_popsize.relate_input.chr7-142770582-A-G.tCutoff_7500.random_1.selection_clues_beta_out > YRI_popsize.relate_input.chr7-142770582-A-G.tCutoff_7500.random_1.selection_clues_beta_out.sele_value.txt


#########################
chr7_142778093
#########################
CHB
#######################
/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142778093 --tCutoff 3000 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.tCutoff_3000.chr7_142778093_selection_clues_out


CEU
#######################
/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142778093 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142778093_selection_clues_out


YRI
#######################
/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142778093 --tCutoff 3000 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.tCutoff_3000.chr7_142778093_selection_clues_out



#########################
chr7-142762093-C-G
#########################
CHB
#######################
python inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093_selection_clues_out

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093 --tCutoff 2000 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CHB_popsize.relate_input.tCutoff2000.chr7_142762093_selection_clues_out > CHB_popsize.relate_input.tCutoff2000.chr7_142762093_selection_clues_out.sign.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.Bin_200gens.Cutoff3000.txt --tCutoff 3000 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CHB_popsize.relate_input.tCutoff3000.chr7_142762093_selection_clues_beta_out > CHB_popsize.relate_input.tCutoff3000.chr7_142762093_selection_clues_beta_out.sign.beta.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.beta.txt --tCutoff 7500 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CHB_popsize.relate_input.tCutoff7500.chr7_142762093_selection_clues_beta_out > CHB_popsize.relate_input.tCutoff7500.chr7_142762093_selection_clues_beta_out.sign.beta.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.Bin_200gens.txt --tCutoff 7600 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CHB_popsize.relate_input.tCutoff7600.chr7_142762093_selection_clues_Bin_200gens_beta_out > CHB_popsize.relate_input.tCutoff7600.chr7_142762093_selection_clues_Bin_200gens_beta_out.sign.beta.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.Bin_350gens.txt --tCutoff 7700 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CHB_popsize.relate_input.tCutoff7700.chr7_142762093_selection_clues_Bin_350gens_beta_out > CHB_popsize.relate_input.tCutoff7700.chr7_142762093_selection_clues_Bin_350gens_beta_out.sign.beta.txt

epochs = np.load("/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093_selection_clues_out.epochs.npy")
freqs = np.load("/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093_selection_clues_out.freqs.npy")
logpost = np.load("/picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142762093_selection_clues_out.post.npy")

python /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/tools/003-manage_freq_traj.py CHB_popsize.relate_input.chr7_142762093_selection_clues_out CHB_popsize.relate_input.chr7_142762093_selection_clues_out 


CEU
#######################
python inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093_selection_clues_out
python plot_traj.py  /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093_selection_clues_out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093_selection_clues_out_fig

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093 --tCutoff 2000 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CEU_popsize.relate_input.tCutoff2000.chr7_142762093_selection_clues_out > CEU_popsize.relate_input.tCutoff2000.chr7_142762093_selection_clues_out.sign.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.Bin_200gens.Cutoff3000.txt --tCutoff 3000 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CEU_popsize.relate_input.tCutoff3000.chr7_142762093_selection_clues_beta_out > CEU_popsize.relate_input.tCutoff3000.chr7_142762093_selection_clues_beta_out.sign.beta.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.Bin_200gens.txt --tCutoff 7600 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CEU_popsize.relate_input.tCutoff7600.chr7_142762093_selection_clues_Bin_200gens_beta_out > CEU_popsize.relate_input.tCutoff7600.chr7_142762093_selection_clues_Bin_200gens_beta_out.sign.beta.txt

/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.Bin_350gens.txt --tCutoff 7700 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CEU_popsize.relate_input.tCutoff7700.chr7_142762093_selection_clues_Bin_350gens_beta_out > CEU_popsize.relate_input.tCutoff7700.chr7_142762093_selection_clues_Bin_350gens_beta_out.sign.beta.txt


/picb/humpopg/xiebo/conda/envs/py36/bin/python /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142762093 --timeBins /picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.beta.txt --tCutoff 7500 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/001-Targe_SNP/chr7-142762093-C-G/CEU_popsize.relate_input.tCutoff7500.chr7_142762093_selection_clues_beta_out > CEU_popsize.relate_input.tCutoff7500.chr7_142762093_selection_clues_beta_out.sign.beta.txt


YRI
#######################
python inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142762093 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142762093_selection_clues_out
python plot_traj.py  /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142762093_selection_clues_out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142762093_selection_clues_out_fig


#########################
chr7_142778093
#########################
CHB
#######################
python inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142778093 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142778093_selection_clues_out
python plot_traj.py  /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142778093_selection_clues_out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CHB_popsize.relate_input.chr7_142778093_selection_clues_out_fig

CEU
#######################
python inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142778093 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142778093_selection_clues_out
python plot_traj.py  /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142778093_selection_clues_out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/CEU_popsize.relate_input.chr7_142778093_selection_clues_out_fig

YRI
#######################
python inference.py --times /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142778093 --out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142778093_selection_clues_out
python plot_traj.py  /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142778093_selection_clues_out /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/result/010-relate/results/YRI_popsize.relate_input.chr7_142778093_selection_clues_out_fig
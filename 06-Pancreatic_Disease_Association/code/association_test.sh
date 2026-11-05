#!/bin/bash

# Phenotypes:
# MA1, MANNHEIM clinical stage 1 CP vs. controls
# MA2, MANNHEIM clinical stage 2 CP vs. controls
# MA3, MANNHEIM clinical stage 3 CP vs. controls
# MA4a, MANNHEIM clinical stage 2+3 CP vs. controls
# MAcc, MANNHEIM clinical stage 2+3 CP vs. stage 1

############################## association test (stratification) ##############################
# with all cases
/mnt/sda/prog/plink2 --vcf ./CP_lcWGS.imputed.qc.posID.PRSSloci+SPINK1.vcf -pheno CovarPC20hetIBD.r01.case.sex.age.MA.txt --pheno-name Pheno --covar CovarPC20hetIBD.r01.case.sex.age.MA.txt --covar-name sex,age,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,PC11,PC12,PC13,PC14,PC15,PC16,PC17,PC18,PC19,PC20 --glm hide-covar cols=+beta,+err,+a1freq,+a1freqcc --ci 0.95 --out ./CP_lcWGS.imputed.qc.PC20AgeSex.removeSPINK1 --threads 6 --no-fid --covar-variance-standardize --remove SPINK1_194+2.sample
# by stage
for i in MA1 MA2 MA3 MA4a MAcc; do
/mnt/sda/prog/plink2 --vcf ./CP_lcWGS.imputed.qc.posID.PRSSloci+SPINK1.vcf -pheno CovarPC20hetIBD.r01.case.sex.age.MA.txt --pheno-name $i --1 --covar CovarPC20hetIBD.r01.case.sex.age.MA.txt --covar-name sex,age,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,PC11,PC12,PC13,PC14,PC15,PC16,PC17,PC18,PC19,PC20 --glm hide-covar cols=+beta,+err,+a1freq,+a1freqcc --ci 0.95 --out ./CP_lcWGS.imputed.qc.${i}.PC20AgeSex.removeSPINK1 --threads 6 --no-fid --covar-variance-standardize --remove SPINK1_194+2.sample
done

############################## association test (conditional) ##############################
# by stage
for i in MA1 MA2 MA3 MA4a MAcc; do
/mnt/sda/prog/plink2 --vcf ./CP_lcWGS.imputed.qc.posID.PRSSloci+SPINK1.vcf -pheno CovarPC20hetIBD.r01.case.sex.age.MA.txt --pheno-name $i --1 --covar CovarPC20hetIBD.r01.case.sex.age.MA.txt --covar-name sex,age,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,PC11,PC12,PC13,PC14,PC15,PC16,PC17,PC18,PC19,PC20 --glm hide-covar cols=+beta,+err,+a1freq,+a1freqcc --ci 0.95 --out ./CP_lcWGS.imputed.qc.${i}.PC20AgeSex.cond --threads 6 --no-fid --covar-variance-standardize --condition rs148954387
done

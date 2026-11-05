#!/bin/bash
smr_Linux smr --qfile gene_eQTL_data.txt --make-besd --out gene_eQTL
smr_Linux --bld rs.ld --gwas-summary gwas.ma --beqtl-summary gene_eQTL --peqtl-heidi 0.05 --peqtl-smr 0.05 --out smr_0.05 --thread-num 10


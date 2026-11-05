#LOC="/picb/humpopg-bigdata2/wangyimin/PRSS/fasta/exact/"
LIST=("300" "400" "500" "600" "700" "800" "900" "1000" "1100" "1200" "1300" "1400" "1500")
for i in ${LIST[@]}
do
	./../miropeats_2.02/miropeats -seq b38_PRSSonly_reverse.fasta b38_PRSS3P2+TRY7.fasta -onlyinter -s ${i} -o 3copy-2pseudo-${i}.ps
done

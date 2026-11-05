#!/bin/bash
inloc=0
name="myfile"
FLAG_INFILE=0
WD=`pwd`
#设定参数
if [ x$1 != x ]
then
	while getopts "i:n:" arg #选项后面的冒号表示该选项需要参数
	do
		case $arg in
		i)
			inloc=$OPTARG
			FLAG_INFILE=1
			;;
		n)
			name=$OPTARG
			;;
		?)  #当有不认识的选项的时候arg为?
			echo "FAIL: Unknown argument. Please check again."
			exit 1
			;;
		esac
	done
	
	until [ $FLAG_INFILE -eq 1 ]
	do
		echo "FAIL: Variables uncomplete. Please check again."
		exit 1
	done

	cd ${inloc}
	FA=`ls *.fa* | grep -v "fai"`
	for i in ${FA[@]}
	do
		j=`echo ${i} | sed "s/.fasta//g" | sed "s/.fa//g"`
		echo ">"${j} >> ${WD}/${name}.fa
		cat ${i} | sed "1d" >> ${WD}/${name}.fa
	done
else
	echo "USAGE
	fasta_merger.sh -i copy2 -n copy2_run1"
fi
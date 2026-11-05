#!/bin/bash
TASK="primate-human"
rm ${TASK}*fa ${TASK}*nex 2>/dev/null
../code/BEASTtree__fasta_merger.sh -i ${TASK} -n ${TASK}
mafft --auto ${TASK}.fa > ${TASK}_mafft.fa
java -jar ~/Softwares/ALTER/alter-lib/target/ALTER-1.3.4-jar-with-dependencies.jar -i ${TASK}_mafft.fa -if FASTA -io MacOS -ip MAFFT -o ${TASK}.nex -of NEXUS -oo Linux -op GENERAL
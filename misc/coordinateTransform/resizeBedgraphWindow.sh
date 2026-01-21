#!/bin/sh

module load ngs/samtools/1.9
module load ngs/Homer/4.9
module load ngs/UCSCutils
module load ngs/bedtools2
module load ngs/MACS2/2.1.2




SAMPLES=`ls *.bedgraph`	

for SAMPLE in ${SAMPLES};do
	
	BASE=`echo ${SAMPLE}|sed -e 's/.bedgraph//g'`
	#bigWigToBedGraph ${BASE}.bw ${BASE}.bedgraph
	binSize=200
	sort-bed ${BASE}.bedgraph | awk -vOFS="\t" '{ print $1, $2, $3, ".", $4 }' - > ${BASE}.bed
	#cat dm6.chrom.sizes | awk -vOFS="\t" '($1!~/_/){ print $1, "0", $2 }' | sort-bed - > dm6.bed
	bedops --chop ${binSize} dm6.bed | bedmap --echo --skip-unmapped --delim "\t" --mean --prec 3 - ${BASE}.bed > ${BASE}_resize.bedgraph

done







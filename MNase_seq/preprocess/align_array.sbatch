#! /bin/bash
#
# S1_qscore_array_fix.sbatch
#
#SBATCH -n 24        					# cores
#SBATCH -N 1         					# one node ?required
#SBATCH -t 0-80:00    					# Running time 
#SBATCH -o align_array_%A_%a.out	# Standard output
#SBATCH -e align_array_%A_%a.err    # Standard error

module load ngs/sratoolkit/2.8.0
module load ngs/bowtie2
module load ngs/samtools
module load ngs/bedtools2
module load R/3.6.0



FILENAME=`ls read1* | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`
FILEBASE=`echo ${FILENAME}|sed -e "s/.fastq.gz.fastqsanger.gz//g"|sed -e "s/read1_//g"`


#LINE_NO=$(echo ${SLURM_ARRAY_TASK_ID}+1 | bc)

## get parameters from table
#SRUN=$(awk -F '\t' -v line=${LINE_NO} -v field=5 'NR==line{print $field}' SraRunTable.txt)

#BOWTIE_INDEX=/work/data/genomes/fly/Drosophila_melanogaster/UCSC/dm6/Sequence/Bowtie2Index/genome

BOWTIE_INDEX="/work/project/becbec_005/ChIP_Seq/240205_SandroFosmids/FosmidsGenome/GenomeAssembly_v4/28xFos_genome"


#mkdir ${SRUN}_out
#cd ${SRUN}_out

#fastq-dump --split-3 ${SRUN}

bowtie_opts="-p 20 -X 250 --no-discordant --no-mixed --no-unal"

bowtie2 $bowtie_opts -x $BOWTIE_INDEX -1 read1_${FILEBASE}.fastq.gz.fastqsanger.gz -2 read2_${FILEBASE}.fastq.gz.fastqsanger.gz > ${FILEBASE}.sam ## separate for error exit
samtools view -hf 0x2 ${FILEBASE}.sam | grep -v "XS:i:" | ./filter_orphans.py | samtools view -b -o ${FILEBASE}.bam
samtools sort -n -m 2G -@ 16 -o ${FILEBASE}.s.bam ${FILEBASE}.bam

#samtools index ${FILEBASE}.s.bam ${FILEBASE}.s.bam.bai

bamToBed -i ${FILEBASE}.s.bam -bedpe > ${FILEBASE}.bed 2>/dev/null

cut -f 1,2,6 ${FILEBASE}.bed > ${FILEBASE}.s.bed

Rscript --vanilla ./bed2ranges.R ${FILEBASE}.s.bed

#rm *.bed
#rm *.bam
#rm *.sam
#rm *.fastq

#cp ../align_array_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}.out .
#cp ../align_array_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}.err .

#! /bin/bash
#
# sde_array.sbatch
#
#SBATCH -n 8        					# cores
#SBATCH -N 1         					# one node ?required
#SBATCH -t 0-80:00    					# Running time 
#SBATCH -o sde_array_%A_%a.out	# Standard output
#SBATCH -e sde_array_%A_%a.err    # Standard error

module load R/3.6.0


FILENAME=`ls *_dyadCov.rds | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`
FILEBASE=`echo ${FILENAME} | sed -e "s/_dyadCov.rds//g"`



#LINE_NO=$(echo ${SLURM_ARRAY_TASK_ID}+1 | bc)

## get parameters from table
#SRUN=$(awk -F '\t' -v line=${LINE_NO} -v field=5 'NR==line{print $field}' SraRunTable.txt)


##### MODIFY HERE !!!! 

echo ${FILEBASE}

Rscript --vanilla cov2spec.R ${FILEBASE}_dyadCov.rds spectralRepeatLength.rds

#cp ../sde_array_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}.out .
#cp ../sde_array_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}.err .

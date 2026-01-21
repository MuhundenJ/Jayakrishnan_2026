#! /bin/bash
### run bowtie array ###

FILES=($(ls -1 read1*))

# get size of array
NUMFASTQ=${#FILES[@]}

#mkdir -p out
#mkdir ../Homer

#cd ../

# now submit to SLURM
if [ $NUMFASTQ -ge 0 ]; then
	sbatch --array=1-$NUMFASTQ align_array.sbatch
fi

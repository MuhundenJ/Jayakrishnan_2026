#! /bin/bash

#mv ../MNase\ Analysis/*.rds .


FILES=($(ls -1 *_dyadCov.rds))

# get size of array
NUMFILES=${#FILES[@]}

#submit to slurm
if [ $NUMFILES -ge 0 ]; then
	jid1=$(sbatch --parsable --array=1-$NUMFILES sde_array.sbatch)
fi

#sbatch --dependency=afterany:$jid1 util_scripts/cleanup.sh

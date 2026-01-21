#!/bin/bash
#SBATCH --job-name=nf-hic
#SBATCH --partition=slim18
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=3-00:00:00
#SBATCH --mem=32G
#SBATCH --output=./hic.out
#SBATCH --error=./hic.err

#module purge
#module load nextflow
#module load singularity

conda init
conda activate MicroC_Nextflow

BOWTIE_INDEX="/work/project/becbec_005/ChIP_Seq/240205_SandroFosmids/FosmidsGenome/GenomeAssembly_v4/28xFos_genome.fa"

nextflow run nf-core-hic_2.1.0/2_1_0/main.nf\
	-offline\
	-c ../bonus.config\
	-resume\
	--fasta ${BOWTIE_INDEX}\
	--input samplesheet.csv\
	--dnase\
	--hicpro_maps\
	--bin_size '200,500,1000,2000,5000,10000'\
	--res_zoomify '200,500,1000,2000,5000,10000'\
	--res_dist_decay '1000,5000,10000'\
	--res_tads '5000,10000,20000'\
	--min_cis_dist 150

#!/bin/sh

module load ngs/bedtools2/2.28.0
module load ngs/bowtie2/2.2.9


## Left out 2G10 (018703) and 4E9 (022426) 

bedtools getfasta -fi genome.fa -fo 28xFos_genome.fa -bed 28xFos_genome.bed -name+

bowtie2-build 28xFos_genome.fa 28xFos_genome

# Jayakrishnan_2026
Scripts related to in vitro reconstitution manuscript Jayakrishnan et al., 2026

Description of folder contents :

1) SampleSheet_master.xlsx : Excel file containing sample metadata (such as experimental batches, treatment conditions etc.)
2) MNase-seq : Folder containing preprocessing and post-processing analyses scripts for MNase-seq data. The analyses pipeline is largely based on Baldi et al., 2018 Mol Cell (see forked repo from BMC CompBio)
   a) preprocess -- raw .fastq.gz files are placed in the subfolder. Running bowtie2_run_PE.sh script runs a SLURM-parallelized version to perform bowtie alignment and generates intermediate .bam, .bed and .rds files of reads (note: bed2ranges.R is written for R 3.6).

   b) MNaseSeq_preproc.rmd uses the .rds files containing positions of reads to generate normalized dyadCov coverages .bw for vizualizing on IGV as well as .rds coverages + autocorrelation analyses to identify/output spectralRepeatLength.rds which are required for next step

   c) SDE : The 04_runSDE.sh script runs a SLURM-parallelized version to perform SDE calculations using .rds dyadCov objects and spectralRepeatLength.rds object generated from previous step. Outputs vanilla as well as z-score normalized .wig coverages of the spectral density estimate representing regularity in nucleosome positioning data

   d) Analyses : Control_Analyses.rmd -- R 4.0-based correlative analyses of MNase-seq data with ChIP-seq data, SDE features, MicroC insulation, overlap with in vivo boundaries, changes in nucleosome positioning upon ATP inhibition/protein depletion etc. used in main and Extended Figures in the manuscript; RE_digestion.rmd -- Relates to Extended Data 6, generates heatmap of MNase-seq signal around Restriction Enzyme cut sites


3) MicroC : Folder containing preprocessing and post-processing analyses scripts for MicroC data.

  a) preprocess : run-nf-hic.sh : Run script for Nextflow based nf-core/hic pipeline. See nf-core website for setup and execution. After standard execution, the cooler_rebalance_rezoomify.sh script is an independent, cooltools based script for changing balancing parameters as used in final figures in the manuscript. 

  b) Analyses: OHCA (Serizay et al., 2024) based analyses of MicroC data (R 4.3). The MicroC_control.rmd script generates contact maps as displayed in main figures 1-3/extended figures 1-4. The MicroC_REdigestion.rmd file is an example markdown script for differential analyses of MicroC data used in Main figures 4-6/extended data 5-7. 


4) Misc : Miscellaneous scripts used in the study

  a) GenomeAssembly : Assembly.sh script generates the reference assembly used in this study based on coordinates in the 28xFos_genome.bed file and dm6 genome fasta file 
  b) CoordinateTransform : resizeBedgraphWindow.sh script takes in published ChIP-seq datasets to transform the coordinates to the 28xFos_genome as well as perform a logQuantile normalization to make datasets uniform.
  

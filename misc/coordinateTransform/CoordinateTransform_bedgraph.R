rm(list=ls())

library(dplyr)
library(tidyr)

# 1. Read the BEDGRAPH files of ChIp-seq etc. (dm6 coordinates! -- perform liftOver if datasets are mapped to different reference genomes)
my_bedgraphs <- list.files("./bedgraphs/",pattern = "resize.bedgraph",full.names = T)

## Log normalize to make data comparable - modified to exclude Infinities

log_normalize <- function(scores) {
  ranked_scores <- rank(scores, ties.method = "average")
  max_rank <- max(ranked_scores)
  ratio <- ranked_scores / max_rank
  ratio[ratio >= 1] <- 1 - .Machine$double.eps  # Prevent exactly 1
  normalized <- -log2(1 - ratio)
  return(normalized)
}

##Fosgen -- load fosmid genome coordinates

fosmid_regions <- read.table("../../FosmidsGenome/GenomeAssembly_v4/28xFos_genome.bed", header = FALSE, sep = "\t", stringsAsFactors = FALSE) %>% mutate(V4=paste0(V4,"::",V1,":",V2,"-",V3))

colnames(fosmid_regions) <- c("chr", "start", "end", "fosmid_name")

### Because we know start and end of constructs, shifting coordinates are quite easy. 

i <- 1

for (i in 1:length(my_bedgraphs)){
  
  my_bedgraph <- my_bedgraphs[i]
  
  signal_bedgraph <- read.table(my_bedgraph, header = FALSE, sep = "\t", stringsAsFactors = FALSE)[,1:4] %>% mutate(name=paste0(V1,":",V2,"-",V3))
  #motifs_bed <- read.table(my_bed, header = FALSE, sep = "\t", stringsAsFactors = FALSE)[,1:3] %>% mutate(name=paste0(V1,":",V2,"-",V3))
  colnames(signal_bedgraph) <- c("chr_signal", "start_signal", "end_signal","score","name")
  
  ## logNorm scores
  
  signal_bedgraph$logNorm_score <- log_normalize(signal_bedgraph$score)
  
  #Find overlapping Fosmid/BAC and adjust coordinates
  results <- signal_bedgraph %>%
    # Cross-check motifs against Fosmid regions
    crossing(fosmid_regions) %>%
    # Keep only overlaps (bin must be fully within a Fosmid)
    filter(chr_signal == chr, 
           start_signal >= start, 
           end_signal <= end) %>%
    # Calculate new coordinates (relative to Fosmid start)
    mutate(
      new_start = start_signal - start,
      new_end = end_signal - start,
      new_chr = fosmid_name
    ) %>%
    # Select only needed columns
    select(new_chr, new_start, new_end,score,logNorm_score)
  
  # 4. Save the results as a new BEDGRPH file
  write.table(results %>% select(-logNorm_score), paste0("./CoordTransf_",gsub("./bedgraphs//","",my_bedgraph)), 
             sep = "\t", col.names = FALSE, row.names = FALSE, quote = FALSE)
  
  write.table(results %>% select(-score), paste0("./CoordTransfwithLogNorm_",gsub("./bedgraphs//","",my_bedgraph)), 
              sep = "\t", col.names = FALSE, row.names = FALSE, quote = FALSE)
  
}

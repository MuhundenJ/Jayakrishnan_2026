#!/usr/bin/env Rscript

library(parallel)
library(rtracklayer)
library(dplyr)


args = commandArgs(trailingOnly=TRUE)
file.id <- args[1]
repeat.length <- readRDS(args[2])

cov <- readRDS(file.id)

sd <- mclapply(cov, function(chrCov) {
  stepsize <- 100
  windowsize <- 1024
  freqs <- 0.5/windowsize*1:1024 # frequencies at which densities are reported
  repeatLengths <- 1/freqs
  selectFreq <- which.min(abs(repeatLengths-repeat.length))
  mw.views <- Views(chrCov, start=seq(1, to=(length(chrCov)-windowsize), by=stepsize ), width=windowsize)
  sds <- viewApply(mw.views, function(x){
    spec.pgram(as.vector(x), log="n", pad=1, spans=c(3,3), plot=F)$spec[selectFreq]
  })
  append(Rle(0,((windowsize/2)-1)), Rle(round(sds), rep(stepsize,length(mw.views))))
})

rl <- as(sd, "SimpleRleList")
file.id <- strsplit(file.id,"\\.")[[1]][1]
saveRDS(rl, file=paste0(file.id,"_spec_",repeat.length,".rds"))
export.bedGraph(rl, paste0(file.id,"_spec_",repeat.length,".wig"))

#my_chromosomes <- c("chr2L","chr2R","chr3L","chr3R","chrX","chrY","chr4")

my_chromosomes <- read.delim("/work/project/becbec_005/ChIP_Seq/240205_SandroFosmids/FosmidsGenome/GenomeAssembly_v4/28xFos_genome.bed",header=F) %>% mutate(name=paste0(V4,"::",V1,":",V2,"-",V3)) %>% pull(name)

rl_scaled <- rl

mu <- mean(rl)
sigma <- sd(rl)

#### transform into per chromosome z-score

for (chr in my_chromosomes){
  rl_scaled[chr] <- (rl_scaled[chr] - mu[chr])/sigma[chr]
}

export.bedGraph(rl_scaled, paste0(file.id,"_spec_Zscore",repeat.length,".wig"))

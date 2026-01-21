#!/usr/bin/env Rscript

suppressWarnings(suppressMessages(library(GenomicRanges)))
suppressWarnings(suppressMessages(library(data.table)))

args = commandArgs(trailingOnly=TRUE)
file.id <- args[1]

bed <- data.frame(fread(file.id))
bedR <- GRanges(bed[,1], IRanges(bed[,2], bed[,3]))
file.id <- strsplit(file.id,"\\.")[[1]][1]
saveRDS(bedR, file=paste(file.id,"_ranges.rds", sep=""))

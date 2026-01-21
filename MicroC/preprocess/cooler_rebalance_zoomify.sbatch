#!/bin/bash
#SBATCH --mem=40000
#SBATCH --job-name=rebalance_zoomify
#SBATCH --output=rebalance_zoomify_%j.out

conda activate MicroC_Viz

# Loop over all 200 bp balanced cool files
for coolfile in *.200_balanced.cool; do
    echo "============================================="
    echo "Processing $coolfile"
    echo "============================================="

    # Strip extension to build base name
    base=${coolfile%.200_balanced.cool}

    # Create a duplicated file to safely overwrite weights
    rebalance_file="${base}.200_balanced.cool"
    #cp "$coolfile" "$rebalance_file"
    #echo "→ Duplicated to $rebalance_file"

    # Rebalance this duplicated file with relaxed parameters
    cooler balance \
        --force \
        --mad-max 12 \
        --min-nnz 3 \
        --min-count 1 \
        "$rebalance_file"
    echo "→ Rebalanced $rebalance_file"

    # Define output mcool name
    out="${base}.mcool"

    # Zoomify into multiresolution mcool
    cooler zoomify \
        --balance \
        --balance-args '--mad-max 12 --min-nnz 3 --min-count 1' \
        -r 400,800,1000,1600,2000,3200 \
        --out "$out" \
        "$rebalance_file"

    echo "→ Generated multires file: $out"
done

echo "============================================="
echo "Finished rebalancing and zoomifying all files."
echo "============================================="


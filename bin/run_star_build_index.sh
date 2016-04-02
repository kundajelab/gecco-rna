#!/usr/bin/env bash

#
# Run STAR aligner on all samples
#

source /users/cprobert/.bashrc
source /users/cprobert/dev/gecco-rna/bin/project_paths.sh

# Path for the star executable
export star_exec="${PROJECT_SRC}STAR/source/STAR"

${star_exec} \
    --runThreadN 16 \
    --runMode genomeGenerate \
    --genomeDir ${PROJECT_STAR_INDEX_DIR} \
    --genomeFastaFiles ${PROJECT_REF_GENOME_FILE} \
    --sjdbGTFfile ${PROJECT_REF_ANNOT_FILE} \
    --sjdbOverhang 101

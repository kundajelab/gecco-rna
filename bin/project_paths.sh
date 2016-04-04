#!/usr/bin/env bash

# Encapsulated static paths for project data.

#
# BASE PATHS - should be the only host-dependent paths
#

# PROJECT_READS_BASE_DIR: Base reads directory - should contain subfolder for each batch
# PROJECT_ANALYSIS_BASE_DIR: Analysis data directory base path
# PROJECT_SCRATCH_BASE: Scratch directory (for intermediate files only)
# PROJECT_SOURCE_BASE_DIR: Base directory for analysis source code

export HOSTNAME="$(hostname)"
if [ "$HOSTNAME" = "nandi" ]; then
    export PROJECT_READS_BASE_DIR="/srv/persistent/pgreens/projects/gecco/data/rna_seq/Casey_RNA-Seq_Batches_1-5/casey_rnaseq_case/"
    export PROJECT_ANALYSIS_BASE_DIR="/srv/scratch/cprobert/gecco-rna/"
    export PROJECT_SCRATCH_BASE="/srv/scratch/cprobert/gecco-rna/"
    export PROJECT_SOURCE_BASE_DIR="/users/cprobert/dev/gecco-rna/"
elif (echo $HOSTNAME | grep -q scg); then
    export PROJECT_READS_BASE_DIR="/srv/gsfs0/projects/kundaje/users/cprobert/data/casey_rnaseq_case/"
    export PROJECT_ANALYSIS_BASE_DIR="/srv/gsfs0/scratch/cprobert/gecco-rna/"
    export PROJECT_SCRATCH_BASE="/srv/gsfs0/scratch/cprobert/gecco-rna/"
    export PROJECT_SOURCE_BASE_DIR="/srv/gsfs0/projects/kundaje/users/cprobert/gecco-rna/"
elif (uname | grep -q Darwin); then
    export PROJECT_READS_BASE_DIR="/Users/chris/dev/trimmomatic-test/mock-data/casey_rna_seq/"
    export PROJECT_ANALYSIS_BASE_DIR="/srv/gsfs0/projects/kundaje/users/cprobert/data/gecco-rna-analysis/"
    export PROJECT_SCRATCH_BASE="/Users/chris/dev/trimmomatic-test/mock-data/scratch/"
    export PROJECT_SOURCE_BASE_DIR="/Users/chris/dev/gecco-rna/"
else
    echo "ERROR: hostname ${HOSTNAME} not recognized."
    exit 1
fi;

#
# RAW DATA
#

# List of batch folder names - one folder per sequencing batch
export PROJECT_READS_BATCH_DIR_NAMES=$(ls ${PROJECT_READS_BASE_DIR} | grep batch*)

#
# ANALYSIS SOURCE CODE DIRECOTRY STRUCTURE
#

# Base directory for project executable files
export PROJECT_BIN="${PROJECT_SOURCE_BASE_DIR}bin/"

# Base directory for project executable files
export PROJECT_SRC="${PROJECT_SOURCE_BASE_DIR}src/"

# Path to sample file, which lists all files and samples by sample
export PROJECT_SAMPLE_FILE="${PROJECT_SOURCE_BASE_DIR}data/VM_stats.csv"

#
# ANNOTATION AND REFERENCE
#

# Annotation data directory base path
export PROJECT_ANNOTATION_BASE_DIR="${PROJECT_ANALYSIS_BASE_DIR}annotation/"

# Reference genome path
export PROJECT_REF_GENOME_FILE="${PROJECT_ANNOTATION_BASE_DIR}gencode-v24-GRCh38-sequence/GRCh38.primary_assembly.genome.fa"

# Genome annotation path
export PROJECT_REF_ANNOT_FILE="${PROJECT_ANNOTATION_BASE_DIR}gencode-v24-GRCh38.p5/gencode.v24.primary_assembly.annotation.gtf"

# Star index directory
export PROJECT_STAR_INDEX_DIR="${PROJECT_ANALYSIS_BASE_DIR}indexes/STAR/"

# Trimmed reads direcotry
export PROJECT_TRIMMED_DIR="${PROJECT_ANALYSIS_BASE_DIR}trimmed/"

# Trimming logging directory
export PROJECT_TRIM_LOG_DIR="${PROJECT_ANALYSIS_BASE_DIR}trimming_logs/"

# Aligned round 1 output direcotry
export PROJECT_ALIGNED_ROUND_1="${PROJECT_ANALYSIS_BASE_DIR}aligned/round_1/"

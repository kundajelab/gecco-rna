#!/usr/bin/env bash

# Encapsulated static paths for project data.

# Base reads directory - should contain subfolder for each batch
# export PROJECT_READS_BASE_DIR="/srv/persistent/pgreens/projects/gecco/data/rna_seq/Casey_RNA-Seq_Batches_1-5/casey_rnaseq_case/"
export PROJECT_READS_BASE_DIR="/srv/gsfs0/projects/kundaje/users/cprobert/data/casey_rnaseq_case/"

# Analysis data directory base path
export PROJECT_ANALYSIS_BASE_DIR="/srv/gsfs0/projects/kundaje/users/cprobert/data/gecco-rna-analysis/"

# Scratch directory (for intermediate files only)
export PROJECT_SCRATCH_BASE="/srv/gsfs0/scratch/cprobert/gecco-rna/"

# List of batch folder names - one folder per sequencing batch
export PROJECT_READS_BATCH_DIR_NAMES=$(ls ${PROJECT_READS_BASE_DIR} | grep batch*)

# Base directory for analysis source code
export PROJECT_SOURCE_BASE_DIR="/srv/gsfs0/projects/kundaje/users/cprobert/gecco-rna/"

# Base directory for project executable files
export PROJECT_BIN="${PROJECT_SOURCE_BASE_DIR}bin/"

# Base directory for project executable files
export PROJECT_SRC="${PROJECT_SOURCE_BASE_DIR}src/"

# Path to sample file, which lists all files and samples by sample
export PROJECT_SAMPLE_FILE="${PROJECT_SOURCE_BASE_DIR}data/VM_stats.csv"

# ANNOTATION AND REFERENCE PATHS

# Annotation data directory base path
export PROJECT_ANNOTATION_BASE_DIR="${PROJECT_ANALYSIS_BASE_DIR}annotation/"

# Reference genome path
export PROJECT_REF_GENOME_FILE="${PROJECT_ANNOTATION_BASE_DIR}gencode-v24-GRCh38-sequence/GRCh38.primary_assembly.genome.fa"

# Genome annotation path
export PROJECT_REF_ANNOT_FILE="${PROJECT_ANNOTATION_BASE_DIR}gencode-v24-GRCh38.p5/gencode.v24.primary_assembly.annotation.gtf"

# Star index directory
export PROJECT_STAR_INDEX_DIR="${PROJECT_ANALYSIS_BASE_DIR}indexes/STAR/"

# TRIMMING SCRATCH PATHS

# Trimmed reads scratch directory
export PROJECT_TRIM_SCRATCH="${PROJECT_SCRATCH_BASE}trimmed/"

# Trimming logging directory
export PROJECT_TRIM_LOG_DIR="${PROJECT_SCRATCH_BASE}trimming-logs/"

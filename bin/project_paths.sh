#!/usr/bin/env bash

# Encapsulated static paths for project data.

# Base reads directory - should contain subfolder for each batch
export PROJECT_READS_BASE_DIR="/srv/persistent/pgreens/projects/gecco/data/rna_seq/Casey_RNA-Seq_Batches_1-5/casey_rnaseq_case/"

# List of batch folder names - one folder per sequencing batch
export PROJECT_READS_BATCH_DIR_NAMES=$(ls ${PROJECT_READS_BASE_DIR} | grep batch*)

# Base directory for analysis source code
export PROJECT_SOURCE_BASE_DIR="${HOME}/dev/gecco-rna/"

# Base directory for project executable files
export PROJECT_BIN="${PROJECT_SOURCE_BASE_DIR}/bin/"

# Path to sample file, which lists all files and samples by sample
export PROJECT_SAMPLE_FILE="${PROJECT_SOURCE_BASE_DIR}/data/VM_stats.csv"

# Analysis data directory base path
export PROJECT_ANALYSIS_BASE_DIR="/srv/persistent/cprobert/projects/GECCO-TWAS/"

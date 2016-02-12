#!/usr/bin/env bash

# Encapsulated static paths for project data.

# Base reads directory - should contain subfolder for each batch
export PROJECT_READS_BASE_DIR="/srv/persistent/pgreens/projects/gecco/data/" \
    "rna_seq/Casey_RNA-Seq_Batches_1-5/casey_rnaseq_case/"

# List of batch folder names - one folder per sequencing batch
export PROJECT_READS_BATCH_DIR_NAMES="$(ls ${PROJECT_READS_BASE_DIR}" \
    "| echo batch*)"

# Base directory for analysis source code
export PROJECT_SOURCE_BASE_DIR="${HOME}/dev/gecco-rna/"

# Path to sample file, which lists all files and samples by sample
export PROJECT_SAMPLE_FILE="${PROJECT_SOURCE_BASE_DIR}/data/VM_stats.csv"

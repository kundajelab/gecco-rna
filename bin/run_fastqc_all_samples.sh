#!/usr/bin/env bash

#
# Run fastqc on all RNA-seq samples
#

# Load fastqc module
module load fastqc/0.11.2

# Check project_paths.sh variables are set
if [ -z "$PROJECT_READS_BASE_DIR" ]; then
    echo "project environment variables not set."
    echo "source bin/project_paths.sh first."
    exit -1
fi

# Set the output directory, make sure it exists
export fastqc_output_dir="${PROJECT_ANALYSIS_BASE_DIR}/fastqc/"
mkdir -p ${fastqc_output_dir}

# Iterate through each batch, and run fastqc on all fastqs in the batch
for batchdir in ${PROJECT_READS_BATCH_DIR_NAMES}; do

    export seq_dir="${PROJECT_READS_BASE_DIR}/${batchdir}"
    export output_fname_base="${batchdir}_"
    export output_path_base="${fastqc_output_dir}${output_fname_base}"

    export fastqs=$(ls ${seq_dir} | sed "s/.fastq.gz//")

    parallel -P 25% \
        'zcat {}.fastq.gz | fastqc stdin --outdir=${output_path_base}{}'\
        ::: ${fastqs}

done

#!/usr/bin/env bash

#
# Run PEAR paired end adapter removal on all samples
#

source /users/cprobert/.bashrc
source /users/cprobert/dev/gecco-rna/bin/project_paths.sh

# Path to pear executable
export pear_exec="${PROJECT_BIN}/pear"

# Alignment output directory
export trimmed_fastq_dir="${PROJECT_ANALYSIS_BASE_DIR}/trimmed_fastqs/"
mkdir -p ${trimmed_fastq_dir}

for batchdir in $PROJECT_READS_BATCH_DIR_NAMES; do
    export seq_dir="${PROJECT_READS_BASE_DIR}${batchdir}/"
    export trim_output_base="${trimmed_fastq_dir}${batchdir}_"

    export seqfiles=$(ls ${seq_dir}*R1.fastq.gz | sed "s/1.fastq.gz//")

    parallel -P 25% \
        'zcat {}1.fastq.gz > {}1.fastq && \
        zcat {}2.fastq.gz > {}2.fastq && \
        ${pear_exec} \
            -f {}1.fastq \
            -r {}2.fastq \
            -o ${trim_output_base}{/} \
            -v 3 \
            -n 20 \
            -u 0.1 \
            -j 1 \
            -b 100 \
            {}1.fastq.gz \
            {}2.fastq.gz \
            1> ${trim_output_base}{/}_trim_stdout.txt \
            2> ${trim_output_base}{/}_trim_stderr.txt && \
        rm {}1.fastq && \
        rm {}2.fastq' \
        ::: ${seqfiles}

done

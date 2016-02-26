#!/usr/bin/env bash

#
# Run STAR aligner on all samples
#

source /users/cprobert/.bashrc
source /users/cprobert/dev/gecco-rna/bin/project_paths.sh

# Path for the star executable
export star_exec="${PROJECT_SRC}STAR/source/STAR"

# Star parallelism settings
# N.B.: total threads used = star_num_threads * star_num_concurrent_alignments
export star_num_threads=4
export star_num_concurrent_alignments=4

# Alignment output directory
export align_output_basedir="${PROJECT_ANALYSIS_BASE_DIR}alignments/"
mkdir -p ${align_output_basedir}

for batchdir in $PROJECT_READS_BATCH_DIR_NAMES; do
    export seq_dir="${PROJECT_READS_BASE_DIR}${batchdir}/"
    export align_output_base="${align_output_basedir}${batchdir}_"

    export seqfiles=$(ls ${seq_dir}*R1.fastq.gz | sed "s/1.fastq.gz//")

    parallel -P $star_num_concurrent_alignments \
        '${star_exec} \
            --runThreadN ${star_num_threads} \
            --genomeDir ${PROJECT_STAR_INDEX_DIR} \
            --readFilesIn {}1.fastq.gz {}2.fastq.gz \
            --readFilesCommand zcat \
            --alignIntronMin 20 \
            --outFileNamePrefix ${align_output_base}{/} \
            --outSAMtype BAM SortedByCoordinate \
            --genomeLoad NoSharedMemory \
            --outFilterMultimapNmax 20 \
            --clip3pAdapterSeq AGATCGGAAG \
            --clip3pAdapterMMp 0.1 \
            --outSAMunmapped Within' \
        ::: ${seqfiles}

done

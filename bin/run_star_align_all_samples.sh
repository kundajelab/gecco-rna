#!/usr/bin/env bash

#
# Run STAR aligner on all samples
#

source /users/cprobert/.bashrc
source /users/cprobert/dev/gecco-rna/bin/project_paths.sh

# Path for the star executable
export star_exec="${PROJECT_BIN}STAR"

# Alignment output directory
export align_output_basedir="${PROJECT_ANALYSIS_BASE_DIR}/alignments/"
mkdir -p ${align_output_basedir}

for batchdir in $PROJECT_READS_BATCH_DIR_NAMES; do
    export seq_dir="${PROJECT_READS_BASE_DIR}${batchdir}/"
    export align_output_base="${align_output_basedir}${batchdir}_"

    export seqfiles=$(ls ${seq_dir}*R1.fastq.gz | sed "s/1.fastq.gz//")

    parallel -P 25% \
        '${star_exec} quant \
            -i ${kallisto_idx} \
            -o ${output_dir}{/} \
            -b 100 \
            {}1.fastq.gz \
            {}2.fastq.gz' \
        ::: ${seqfiles}

done

export fastqc_parse_exec="${PROJECT_SOURCE_BASE_DIR}/bin/fastqc_output_parser.py"

python ${fastqc_parse_exec} ${fastqc_output_dir} ${fastqc_output_summary}

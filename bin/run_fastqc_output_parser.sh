#!/usr/bin/env bash

#
# Run the fastqc output parser on all output
#

source /users/cprobert/.bashrc
source /users/cprobert/dev/gecco-rna/bin/project_paths.sh

export fastqc_output_dir="${PROJECT_ANALYSIS_BASE_DIR}/fastqc/"
export fastqc_output_summary="${fastqc_output_dir}/parsed_output.tsv"

export fastqc_parse_exec="${PROJECT_SOURCE_BASE_DIR}/bin/fastqc_output_parser.py"

python ${fastqc_parse_exec} ${fastqc_output_dir} ${fastqc_output_summary}

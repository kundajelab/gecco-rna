#!/usr/bin/env bash

#
# Run trimming and alignment round 1 for one sample.
#
# Usage: run_trimmomatic_for_sample --R1 {R1_path} --R2 {R2_path}
#

# Source project_paths.sh on any host
FILE=/srv/gsfs0/projects/kundaje/users/cprobert/gecco-rna/bin/project_paths.sh && test -f $FILE && source $FILE
FILE=/users/cprobert/dev/gecco-rna/bin/project_paths.sh && test -f $FILE && source $FILE
FILE=/Users/chris/dev/gecco-rna/bin/project_paths.sh && test -f $FILE && source $FILE
if [ -z "$PROJECT_SOURCE_BASE_DIR" ]; then
    echo "ERROR: did not source project_paths.sh"
    exit 1
fi

while [[ $# > 1 ]]
do
key="$1"

case $key in
    --R1)
    R1PATH="$2"
    shift
    ;;
    --R2)
    R2PATH="$2"
    shift
    ;;
    *)
    ;;
esac
shift
done

if [ -z "$R1PATH" ] || [ ! -e ${R1PATH} ]
then
  echo "error: R1 (${R1PATH}) does not exist."
  exit 1
fi

if [ -z "$R2PATH" ] || [ ! -e ${R2PATH} ]
then
  echo "error: R2 (${R2PATH}) does not exist."
  exit 1
fi

# Get a unique output name based on the read 1 fastq name and batch directory
export fname_prefix=$(basename ${R1PATH} | sed "s/_R1.fastq.gz//")
export full_dirname="$(dirname ${R1PATH})"
export batch_dirname="$(basename ${full_dirname})"
export OUTPUT_BASE="${batch_dirname}_${fname_prefix}"

# Run read trimming
${PROJECT_BIN}run_trimmomatic_for_sample.sh \
    --R1 ${R1PATH} \
    --R2 ${R2PATH} \
    --outputbase ${OUTPUT_BASE}

# Paths for paired read fastqs output from the trimming step
export TRIMMED_FQ1="${PROJECT_TRIMMED_DIR}${OUTPUT_BASE}_1P.fq.gz"
export TRIMMED_FQ2="${PROJECT_TRIMMED_DIR}${OUTPUT_BASE}_2P.fq.gz"

# Run alignment round/pass 1
${PROJECT_BIN}run_star_align_round1_for_sample.sh \
    --R1 ${TRIMMED_FQ1} \
    --R2 ${TRIMMED_FQ2} \
    --outputbase ${OUTPUT_BASE}

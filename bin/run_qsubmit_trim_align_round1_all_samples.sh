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

export exec_cmd="${PROJECT_BIN}run_star_align_round1_for_sample.sh"

#for batchdir in $PROJECT_READS_BATCH_DIR_NAMES; do
for batchdir in batch1; do
    export seq_dir="${PROJECT_READS_BASE_DIR}${batchdir}/"
    export R1_seqfiles=$(ls ${seq_dir}*R1.fastq.gz | sed "s/_R1.fastq.gz//" | head -n 10)

    for R1_seqfile_base in $R1_seqfiles; do
        export R1="${R1_seqfile_base}_R1.fastq.gz"
        export R1="${R1_seqfile_base}_R2.fastq.gz"
        export jname="${batchdir}_${R1_seqfile}"
        qsub -q standard -V -N ${jname} -l h_vmem=2G -pe shm 8 \
            ${exec_cmd} --R1 ${R1} --R2 ${R2}
done

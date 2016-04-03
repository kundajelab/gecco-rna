#!/usr/bin/env bash

#
# Run trimmomatic on a single pair of fastqs provided with flags --R1, --R2
#
# Usage: run_trimmomatic_for_sample --R1 {R1_path} --R2 {R2_path}
#

source /home/cprobert/.bashrc
source /srv/gsfs0/projects/kundaje/users/cprobert/gecco-rna/bin/project_paths.sh

module load java/latest


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

export dir_base="$(dirname ${R1PATH})"
export fname_prefix="$(basename ${R1PATH} | grep -oE '(gc_|VM)([0-9]+)([-_ACGTL0-9]*)([ACGTL0-9])')"
export UNIQ_FNAME="$(basename ${dir_base})_${fname_prefix}"
export LOGPATH="${PROJECT_LOG_DIR}/${UNIQ_FNAME}.log.txt"

export TIMATIC_SRC_DIR="${PROJECT_SRC}/Trimmomatic/Trimmomatic-0.36/"
export TRIMATIC_JAR="${TIMATIC_SRC_DIR}trimmomatic-0.36.jar"
export TRIMATIC_REF_FA="${TIMATIC_SRC_DIR}adapters/TruSeq3-PE-2.fa"
export JAVA_EXEC="java"

export OUTPUT_DIR="${PROJECT_TRIM_SCRATCH}"
export OUTPUT_BASE="${OUTPUT_DIR}${UNIQ_FNAME}.fq.gz"

export TRIMATIC_EXEC="${JAVA_EXEC} -jar ${TRIMATIC_JAR}"
export TRIMATIC_EXEC="${TRIMATIC_EXEC} PE"
export TRIMATIC_EXEC="${TRIMATIC_EXEC} -threads 4"
export TRIMATIC_EXEC="${TRIMATIC_EXEC} -trimlog ${LOGPATH}"
export TRIMATIC_EXEC="${TRIMATIC_EXEC} ${R1PATH} ${R2PATH}"
export TRIMATIC_EXEC="${TRIMATIC_EXEC} -baseout ${OUTPUT_BASE}"

export TRIMATIC_EXEC="${TRIMATIC_EXEC} ILLUMINACLIP:${TRIMATIC_REF_FA}:2:20:7:1:true"

export TRIMATIC_EXEC="${TRIMATIC_EXEC} CROP:51"

${TRIMATIC_EXEC}

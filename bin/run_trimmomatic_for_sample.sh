#!/usr/bin/env bash

#
# Run trimmomatic on a single pair of fastqs provided with flags --R1, --R2
# Output files are named with the globally unique filename base --outputbase
#
# Usage: run_trimmomatic_for_sample --R1 {R1_path} --R2 {R2_path} --outputbase {output_fname_base}
#

# Source project_paths.sh on any host
FILE=/srv/gsfs0/projects/kundaje/users/cprobert/gecco-rna/bin/project_paths.sh && test -f $FILE && source $FILE
FILE=/users/cprobert/dev/gecco-rna/bin/project_paths.sh && test -f $FILE && source $FILE
FILE=/Users/chris/dev/gecco-rna/bin/project_paths.sh && test -f $FILE && source $FILE
if [ -z "$PROJECT_SOURCE_BASE_DIR" ]; then
    echo "ERROR: did not source project_paths.sh"
    exit 1
fi

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
    --outputbase)
    OUTFNAMEBASE="$2"
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

if [ -z "$OUTFNAMEBASE" ]
then
  echo "error: output filename not set (--outputbase)"
  exit 1
fi

mkdir -p ${PROJECT_TRIM_LOG_DIR}
export LOGPATH="${PROJECT_TRIM_LOG_DIR}/${OUTFNAMEBASE}.log.txt"

export TIMATIC_SRC_DIR="${PROJECT_SRC}/Trimmomatic/Trimmomatic-0.36/"
export TRIMATIC_JAR="${TIMATIC_SRC_DIR}trimmomatic-0.36.jar"
export TRIMATIC_REF_FA="${TIMATIC_SRC_DIR}adapters/TruSeq3-PE-2.fa"
export JAVA_EXEC="java"

mkdir -p ${PROJECT_TRIMMED_DIR}
export OUTPUT_BASE="${PROJECT_TRIMMED_DIR}${OUTFNAMEBASE}.fq.gz"

export TRIMATIC_EXEC="${JAVA_EXEC} -jar ${TRIMATIC_JAR}"
export TRIMATIC_EXEC="${TRIMATIC_EXEC} PE"
export TRIMATIC_EXEC="${TRIMATIC_EXEC} -threads 4"
export TRIMATIC_EXEC="${TRIMATIC_EXEC} -trimlog ${LOGPATH}"
export TRIMATIC_EXEC="${TRIMATIC_EXEC} ${R1PATH} ${R2PATH}"
export TRIMATIC_EXEC="${TRIMATIC_EXEC} -baseout ${OUTPUT_BASE}"

export TRIMATIC_EXEC="${TRIMATIC_EXEC} ILLUMINACLIP:${TRIMATIC_REF_FA}:2:20:7:1:true"

export TRIMATIC_EXEC="${TRIMATIC_EXEC} CROP:51"

${TRIMATIC_EXEC}

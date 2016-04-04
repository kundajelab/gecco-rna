#!/usr/bin/env bash

#
# Run STAR aligner for one sample
# Input files are given with --R1, --R2
# Output files are named with the globally unique filename base --outputbase
#
# Usage: run_star_align_for_sample --R1 {R1_path} --R2 {R2_path} --outputbase {output_fname_base}
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

# Path for the star executable
export star_exec="${PROJECT_SRC}STAR/source/STAR"

# Star parallelism settings
export star_num_threads=8

# Alignment output directory
export align_output_basedir="${PROJECT_ALIGNED_ROUND_1}"
mkdir -p ${align_output_basedir}
export align_output_base="${align_output_basedir}${OUTFNAMEBASE}"

${star_exec} \
    --runThreadN ${star_num_threads} \
    --genomeDir ${PROJECT_STAR_INDEX_DIR} \
    --readFilesIn ${R1PATH} ${R2PATH} \
    --readFilesCommand zcat \
    --alignIntronMin 20 \
    --outFileNamePrefix ${align_output_base} \
    --outSAMtype BAM SortedByCoordinate \
    --genomeLoad NoSharedMemory \
    --outFilterMultimapNmax 20 \
    --outFilterMismatchNoverLmax 0.1

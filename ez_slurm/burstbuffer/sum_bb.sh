#!/bin/bash
START_XTC=$(date +"%s")

BB_DIR=$DW_PERSISTENT_STRIPED_myBBname

#for experiment database
export SIT_DATA=${BB_DIR}/g/psdm/data

#for psana
export SIT_PSDM_DATA=${BB_DIR}/d/psdm

#cctbx
source /build/setpaths.sh

# base directory
BASE_DIR=${BB_DIR}/d/psdm/cxi/cxid9114/scratch/mona

# experiment parameters
EXP=${1}
RUN=${2}

python ${BASE_DIR}/simpler_psana.py ${EXP} ${RUN}

END_XTC=$(date +"%s")
ELAPSED=$((END_XTC-START_XTC))
echo TotalElapsed_OneCore ${ELAPSED} ${START_XTC} ${END_XTC}

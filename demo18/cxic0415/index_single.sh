#!/bin/bash
START_XTC=$(date +"%s")
EXP=${1}
RUN=${2}
TRIAL=${3}
CMDMODE=${4}
RUN_F="$(printf "r%04d" ${RUN})"
TRIAL_F="$(printf "%03d" ${TRIAL})"


if [ $# -eq 0 ]; then
    echo "Usage: ./index_single.sh EXP RUN_NO TRIAL_NO CMDMODE(none/pythonprof/strace/debug)"
    exit 0
fi

echo $EXP $RUN $TRIAL $CMDMODE

# base directory is the current directory
IN_DIR=/tmp
LIMIT=1
OUT_DIR=${PWD}/output
DATA_DIR=/global/cscratch1/sd/monarin/d/psdm/cxi/${EXP}/xtc2

export PS_CALIB_DIR=$IN_DIR
export PS_SMD_N_EVENTS=1
export PS_SMD_NODES=1

# setup playground
mkdir -p ${OUT_DIR}/discovery/dials/${RUN_F}/${TRIAL_F}/out
mkdir -p ${OUT_DIR}/discovery/dials/${RUN_F}/${TRIAL_F}/stdout
mkdir -p ${OUT_DIR}/discovery/dials/${RUN_F}/${TRIAL_F}/tmp

cctbx_args="input.experiment=${EXP} input.run_num=${RUN} output.logging_dir=${OUT_DIR}/discovery/dials/${RUN_F}/${TRIAL_F}/stdout output.output_dir=${OUT_DIR}/discovery/dials/${RUN_F}/${TRIAL_F}/out format.cbf.invalid_pixel_mask=${IN_DIR}/mask.pickle ${IN_DIR}/process_batch.phil dump_indexed=False output.tmp_output_dir=${OUT_DIR}/discovery/dials/${RUN_F}/${TRIAL_F}/tmp input.xtc_dir=${DATA_DIR} max_events=${LIMIT}"

if [ "${CMDMODE}" = "pythonprof" ]; then
    python -m cProfile -s tottime python /tmp/xtc_process.py ${cctbx_args}
  
elif [ "${CMDMODE}" = "strace" ]; then
    strace -ttt -f -o $$.log python /tmp/xtc_process.py ${cctbx_args}

elif [ "${CMDMODE}" = "debug" ]; then
    python /tmp/xtc_process.py ${cctbx_args}
  
else
    cctbx.xfel.xtc_process ${cctbx_args}
  
fi


END_XTC=$(date +"%s")
ELAPSED=$((END_XTC-START_XTC))
echo TotalElapsed ${ELAPSED} ${START_XTC} ${END_XTC}

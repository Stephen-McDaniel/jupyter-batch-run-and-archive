#!/usr/bin/env bash
set -euo pipefail

# Usage:
# /path/to/script/python3_batch.sh "/path/to/file/000_example.ipynb" &

INPUT="$1"
# INPUT="/backblaze/AI/workspace/peakcreator-python-ssh/HM_202504/000_example.ipynb"

# strip .ipynb or .py suffix if present
if [[ "$INPUT" == *.ipynb ]]; then
  BASE="${INPUT%.ipynb}"
elif [[ "$INPUT" == *.py ]]; then
  BASE="${INPUT%.py}"
else
  BASE="$INPUT"
fi

# ensure NOTEBOOK points to .ipynb
NOTEBOOK="${BASE}.ipynb"

# extract directory and filename
DIR="$(dirname "${INPUT}")"
FILEBASE="$(basename "${BASE}")"

# create logs directory if it doesn't exist
LOGDIR="${DIR}/logs"
mkdir -p "${LOGDIR}"

# record start time
TS1=$(date +"%s")
DT1=$(date +"%Y-%m-%d_%H-%M-%S")
echo " Running: ${FILEBASE}"
echo "Touching: ${BASE}.${DT1}.start"

# touch start flag in original dir
touch "${BASE}.${DT1}.start"

# clean up any leftover running/complete flags
rm -f "${BASE}.running" "${BASE}.complete"

# export notebook to script
/root/.local/bin/jupyter nbconvert --to script "${NOTEBOOK}" --output "${LOGDIR}/${FILEBASE}.${DT1}"

# mark as running
touch "${BASE}.running"

# run script with python3, redirect logs to LOGDIR
/usr/local/bin/python3 "${LOGDIR}/${FILEBASE}.${DT1}.py" > "${LOGDIR}/${FILEBASE}.${DT1}.log" 2>&1

# remove running flag
rm "${BASE}.running"

# record end time and compute duration
TS2=$(date +"%s")
DT2=$(date +"%Y-%m-%d_%H-%M-%S")
DURATION=$(( TS2 - TS1 ))

# write duration into complete file in original dir
echo "Ran for ${DURATION} seconds" > "${BASE}.${DT2}.complete"
# remove start flag
rm -f "${BASE}.${DT1}.start"


# append log content as commented lines to the python script
cat >> "${LOGDIR}/${FILEBASE}.${DT1}.py" <<EOF

# ========================================================================
# LOG FILE (${FILEBASE}.${DT1}.log)
EOF
sed 's/^/# /' "${LOGDIR}/${FILEBASE}.${DT1}.log" >> "${LOGDIR}/${FILEBASE}.${DT1}.py"

echo "Appended log to ${LOGDIR}/${FILEBASE}.${DT1}.py"

echo "# " >> "${LOGDIR}/${FILEBASE}.${DT1}.py"
echo "# Ran for ${DURATION} seconds" >> "${LOGDIR}/${FILEBASE}.${DT1}.py"

rm -f "${LOGDIR}/${FILEBASE}.${DT1}.log"

# echo summary
echo "  Ending: ${FILEBASE}"
echo "Touching: ${BASE}.${DT2}.complete"
echo " Seconds: ${DURATION}"

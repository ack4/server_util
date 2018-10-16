#!/bin/bash -u
BASE_DIR=$(dirname $(readlink -f $0))

find ${BASE_DIR} -type d -name 'EVIDENCE_*' | xargs -I{} ${BASE_DIR}/2_convert_old.sh {}
find ${BASE_DIR} -name 'EVIDENCE_*' -type d | sort | while read LINE
do
    echo "${LINE}" | xargs -I{} ${BASE_DIR}/3_calc.sh {} | tee "${LINE}/calc_result.tsv"
    echo
done

${BASE_DIR}/4_evidence.sh

exit 0

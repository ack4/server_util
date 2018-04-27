#!/bin/bash
BASE_DIR=$(dirname $(readlink -f $0))

find ${BASE_DIR} -type d -name 'EVIDENCE_*' | xargs -I{} ${BASE_DIR}/convert.sh {}
find ${BASE_DIR} -name 'EVIDENCE_*' -type d | sort | while read LINE
do
    echo "${LINE}" | xargs -I{} ${BASE_DIR}/calc.sh {}
    echo
done

exit 0

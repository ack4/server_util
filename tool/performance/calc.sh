#!/bin/bash -u
BASE_DIR=$(dirname $(readlink -f $0))
EVI_DIR=${1-$(find ${BASE_DIR} -maxdepth 1 -type d  -name 'EVIDENCE_*' | sort -r | head -1)}

CONV_VMSTAT=${EVI_DIR}/result_conv_vmstat.csv
CONV_IOSTAT=${EVI_DIR}/result_conv_iostat.csv
CONV_FREE=${EVI_DIR}/result_conv_free.csv

function pre_vmstat()
{
    cat -
}

function pre_iostat()
{
    cat - \
        | cat ${CONV_IOSTAT} | grep '^.*,.*,.*,.*,.*,.*,.*,.*,.*,.*,.*,.*,.*,.*,.*,.*,.*$'
}

function pre_free()
{
    cat -
}

#check resutl file
if [ ! -f "${CONV_FREE}" -o ! -f "${CONV_VMSTAT}" -o ! -e "${CONV_IOSTAT}" ]; then
  echo "not exists result files."
  exit 99
fi


echo -e "target\t$(basename ${EVI_DIR})"
python ${BASE_DIR}/py/vmstat.py <(cat ${CONV_VMSTAT} | pre_vmstat) 0
python ${BASE_DIR}/py/iostat.py <(cat ${CONV_IOSTAT} | pre_iostat) 0
python ${BASE_DIR}/py/free.py <(cat ${CONV_FREE} | pre_free) 0

exit 0

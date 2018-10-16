#!/bin/bash -u
BASE_DIR=$(dirname $(readlink -f $0))
EVI_DIR=${1-$(find ${BASE_DIR} -maxdepth 1 -type d  -name 'EVIDENCE_*' | sort -r | head -1)}

RESULT_VMSTAT=${EVI_DIR}/result_vmstat
RESULT_FREE=${EVI_DIR}/result_free
RESULT_IOSTAT=${EVI_DIR}/result_iostat

function conv_vmstat()
{
    declare local HEADER="datetime,r,b,swpd,free,buff,cache,si,so,bi,bo,in,cs,us,sy,id,wa,st,util"
    echo "${HEADER}"
    cat - \
        | tr -s ' ' \
        | grep -v '^$' \
        | grep -v '^procs' \
        | grep -v '^START' \
        | sed 's/^ *//g' \
        | tr ' ' ',' \
        | grep -v '^r,' \
        | awk -F, 'BEGIN {OFS=","} {print $18 " " $19,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$13+$14+$16+$17}'
}

function conv_free()
{
    declare local HEADER="datetime,total,used,free,shared,buff_cache,available,swap_total,swap_userd,swap_free,util"
    echo "${HEADER}"
    cat - \
        | tr -s ' ' \
        | sed 's/^ *//g' \
        | sed 's/^$/@@@/g' \
        | sed 's/^total.*//g' \
        | grep -v '^$' \
        | sed 's/^.*: //g' \
        | tr ' ' ',' \
        | tr '\n' ',' \
        | sed 's/@@@/\n/g' \
        | sed -E 's/^,(.*),$/\1/g' \
        | grep -v '^START' \
        | grep -v '^,' \
        | awk -F, 'BEGIN {OFS=",";OFMT="%.1f"} {print $1 " " $2,$3,$4,$5,$6,$7,$8,$9,$10,$11,($3-$8)/$3*100}'
}

function conv_iostat()
{
    declare local HEADER="datetime,Device,rrqm/s,wrqm/s,r/s,w/s,rMB/s,wMB/s,avgrq-sz,avgqu-sz,await,r_await,w_await,svctm,util"
    echo "${HEADER}"
    cat - \
        | tr -s ' ' \
        | grep -v '^$' \
        | grep -v '^Device:' \
        | grep -v '^START' \
        | grep -v '^Linux' \
        | sed -E 's/^(..)\/(..)\/(....) (..:..:.. ..)/\n\3-\1-\2 \4/g' \
        | awk 'BEGIN {FS="\n";RS="";OFS="\n"} {print $1 " " $2,$1 " " $3,$1 " " $4}' \
        | tr ' ' ',' \
        | awk -F, 'BEGIN {OFS=","} {print $1 " " $2 " " $3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17}' \
        | while read LINE
          do
              declare local TMP=$(echo ${LINE} | cut -d, -f2-15)
              declare local DATETIME_AMPM=$(echo ${LINE} | cut -d, -f1)
              #AM,PM表記を変換
              DATETIME_AMPM=$(date -d "${DATETIME_AMPM}" +"%F %T")
              echo "${DATETIME_AMPM},${TMP}"
          done
}


#check resutl file
if [ ! -f "${RESULT_FREE}" -o ! -f "${RESULT_VMSTAT}" -o ! -e "${RESULT_IOSTAT}" ]; then
  echo "not exists result files."
  exit 99
fi

cat ${RESULT_VMSTAT} | conv_vmstat > ${EVI_DIR}/result_conv_vmstat.csv
cat ${RESULT_FREE} | conv_free > ${EVI_DIR}/result_conv_free.csv
cat ${RESULT_IOSTAT} | conv_iostat > ${EVI_DIR}/result_conv_iostat.csv



exit 0

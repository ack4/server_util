#!/bin/bash -u
echo "@start"

BASE_DIR=$(dirname $(readlink -f $0))
EVI_DIR=${BASE_DIR}/EVIDENCE_$(date +"%Y%m%d_%H%M%S")
INTERVAL=${1:-1}
INTERVAL_COUNT=${2:-3}

mkdir -p ${EVI_DIR}
START_DATE=$(date +"%F %T")

echo -e "START:${START_DATE}\n" >> ${EVI_DIR}/result_free
#echo -e "START:${START_DATE}\n" >> ${EVI_DIR}/result_sar
echo -e "START:${START_DATE}\n" >> ${EVI_DIR}/result_vmstat
echo -e "START:${START_DATE}\n" >> ${EVI_DIR}/result_mpstat
echo -e "START:${START_DATE}\n" >> ${EVI_DIR}/result_iostat

#free job
YYY='$((COUNT+1))'
XXX='${COUNT}'
FREE_JOB=`cat << EOF
#!/bin/bash -u
COUNT=0
while true
do
  date +'%F %T' >> ${EVI_DIR}/result_free
  free -m >> ${EVI_DIR}/result_free
  echo >> ${EVI_DIR}/result_free
  sleep ${INTERVAL}
  if [ ${XXX} -eq ${INTERVAL_COUNT} ]; then
    break
  fi
  COUNT=${YYY}
done
exit 0
EOF`
bash <(echo "${FREE_JOB}") &
#free job

vmstat -t -n -S M ${INTERVAL} $((INTERVAL_COUNT + 1)) >> ${EVI_DIR}/result_vmstat &
sar ${INTERVAL} ${INTERVAL_COUNT} -o ${EVI_DIR}/result_sar > /dev/null &
mpstat -P ALL ${INTERVAL} ${INTERVAL_COUNT} >> ${EVI_DIR}/result_mpstat &
LC_ALL=C iostat -txdm ${INTERVAL} $((INTERVAL_COUNT + 1)) >> ${EVI_DIR}/result_iostat &

while [ "$(jobs -r | wc -l)"  != "0" ]
do
  sleep ${INTERVAL}
done

echo "@end"
exit 0

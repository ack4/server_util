#!/bin/bash -u
#TARGET_LOG変数で指定したファイルをディレクトリ構造ごとtargzで圧縮し取得
#第一起動引数には何分前に更新されたファイルかを指定する
declare -r BASE_DIR=$(dirname $(readlink -f $0))
declare -r LOG_TIMESTAMP_MIN=${1:-"60"}
declare -r TAR_FILE=${BASE_DIR}/tar_file_$(date +"%Y%m%d%H%M%S").tar.gz

#ファイル、ディレクトリを指定する（ワイルドカード等利用可）
declare -r TARGET_LOG=$(cat << EOS
${BASE_DIR}/EVIDENCE*
/var/log/messages*
/var/log/secure*
/var/log/pgsql/*
/var/log/pgpool/*
/var/log/tomcat/*
EOS
)

function makeLogList()
{
    declare -r local L_TARGET_LOG=$1
    declare -r local L_LOG_TIMESTAMP_MIN=$2
    echo "${TARGET_LOG}" | while read LINE
    do
        find ${LINE} -type f -mmin "-${LOG_TIMESTAMP_MIN}" 2> /dev/null
    done
}

tar zcvf ${TAR_FILE} -T <(makeLogList "${TARGET_LOG}" "${LOG_TIMESTAMP_MIN}")

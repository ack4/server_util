#!/bin/bash -u
LANG=C
declare PAUSE_FLG="TRUE"
#*******************env_param
declare -r pgdir=/var/lib/pgsql/10/data
declare -r pgdirData=/var/lib/pgsql/10/test_data
declare -r pgdirLog=/var/log/pgsql
#*******************env_param

declare BASE_DIR=$(readlink -f $0 | xargs dirname)
declare WORK_DIR="${BASE_DIR}/work"
declare RESULT_DIR="${WORK_DIR}/result"
declare TAR_DIR="${WORK_DIR}/tar"
declare TAR_LIST="${TAR_DIR}/tar_list.lst"
declare TAR_FILE="${TAR_DIR}/comp.tar.gz"

function userInterrupt()
{
    echo
    declare local L_MESSAGE=$1
    declare local EXIT_FLG=""
    echo "${L_MESSAGE}"
    if [ "${PAUSE_FLG:-FALSE}" == "TRUE" ]; then
        read -p "Input Enter or 'q':" EXIT_FLG
        if [ "${EXIT_FLG}" == "q" ]; then
            exit 9
        fi
    fi
}

#**********************init
userInterrupt "rm -rf ${WORK_DIR}"
rm -rf "${WORK_DIR}"

userInterrupt "mkdir -p ${RESULT_DIR}"
mkdir -p "${RESULT_DIR}"

#**********************start

userInterrupt "uname -a > ${RESULT_DIR}/uname-a.txt"
uname -a > "${RESULT_DIR}/uname-a.txt"

userInterrupt "cat /etc/redhat-release > ${RESULT_DIR}/etc_redhat-release.txt"
cat /etc/redhat-release > "${RESULT_DIR}/etc_redhat-release.txt"

userInterrupt "cat /proc/version > ${RESULT_DIR}/proc_version.txt"
cat /proc/version > "${RESULT_DIR}/proc_version.txt"

userInterrupt "cat /etc/inittab > ${RESULT_DIR}/etc_inittab.txt"
cat /etc/inittab > "${RESULT_DIR}/etc_inittab.txt"

userInterrupt "cat /etc/hosts > ${RESULT_DIR}/etc_hosts.txt"
cat /etc/hosts > "${RESULT_DIR}/etc_hosts.txt"

userInterrupt "cat /etc/passwd > ${RESULT_DIR}/etc_passwd.txt"
cat /etc/passwd > "${RESULT_DIR}/etc_passwd.txt"

userInterrupt "cat /etc/group > ${RESULT_DIR}/etc_group.txt"
cat /etc/group > "${RESULT_DIR}/etc_group.txt"

userInterrupt "df -hT > ${RESULT_DIR}/df-hT.txt"
df -h > "${RESULT_DIR}/df-hT.txt"

userInterrupt "cat /etc/fstab > ${RESULT_DIR}/etc_fstab.txt"
cat /etc/fstab > "${RESULT_DIR}/etc_fstab.txt"

userInterrupt "ifconfig > ${RESULT_DIR}/ifconfig.txt"
ifconfig > "${RESULT_DIR}/ifconfig.txt"

userInterrupt "route -v > ${RESULT_DIR}/route-v.txt"
route -v > "${RESULT_DIR}/route-v.txt"

userInterrupt "cat /etc/resolv.conf > ${RESULT_DIR}/etc_resolv.conf"
cat /etc/resolv.conf > "${RESULT_DIR}/etc_resolv.conf"

userInterrupt "rpm -qa > ${RESULT_DIR}/rpm-qa.txt"
rpm -qa > "${RESULT_DIR}/rpm-qa.txt"

userInterrupt "netstat -anp > ${RESULT_DIR}/netstat-anp.txt"
netstat -anp > "${RESULT_DIR}/netstat-anp.txt"

userInterrupt "netstat -antop > ${RESULT_DIR}/netstat-antop.txt"
netstat -antop > "${RESULT_DIR}/netstat-antop.txt"

userInterrupt "cat /etc/sysctl.conf > ${RESULT_DIR}/etc_sysctl.conf.txt"
cat /etc/sysctl.conf > "${RESULT_DIR}/etc_sysctl.conf.txt"

userInterrupt "ps -lef > ${RESULT_DIR}/ps-elf.txt"
ps -lef > "${RESULT_DIR}/ps-elf.txt"

userInterrupt "ulimit -a > ${RESULT_DIR}/ulimit-a.txt"
ulimit -a > "${RESULT_DIR}/ulimit-a.txt"

userInterrupt "free -h > ${RESULT_DIR}/free-h.txt"
free -h > "${RESULT_DIR}/free-h"

#
userInterrupt "du -hs $pgdir > ${RESULT_DIR}/du-hs_postgresql_dir.txt"
du -hs "$pgdir" > "${RESULT_DIR}/du-hs_postgresql_dir.txt"

userInterrupt "du -hs $pgdirData > ${RESULT_DIR}/du-hs_postgresql_dirData.txt"
du -hs "$pgdirData" > "${RESULT_DIR}/du-hs_postgresql_dirData.txt"

#***************************find
#userInterrupt "find / -type l > ${RESULT_DIR}/find_root-typel.txt"
#find / -type l > "${RESULT_DIR}/find_root-typel.txt"
#userInterrupt "find / -type f -follow > ${RESULT_DIR}/find_root-typef-follow.txt"
#find / -type f -follow > "${RESULT_DIR}/find_root-typef-follow.txt"

userInterrupt "find /etc -type l > ${RESULT_DIR}/find_etc-typel.txt"
find /etc -type l > "${RESULT_DIR}/find_etc-typel.txt"
userInterrupt "find /etc -type f -follwo > ${RESULT_DIR}/find_etc-typef-follow.txt"
find /etc -type f -follow > "${RESULT_DIR}/find_etc-typef-follow.txt"

userInterrupt "find /var -type l > ${RESULT_DIR}/find_var-typel.txt"
find /var -type l > "${RESULT_DIR}/find_var-typel.txt"
userInterrupt "find /var -type f -follow > ${RESULT_DIR}/find_var-typef-follow.txt"
find /var -type f -follow > "${RESULT_DIR}/find_var-typef-follow.txt"

userInterrupt "find /usr -type l > ${RESULT_DIR}/find_usr-typel.txt"
find /usr -type l > "${RESULT_DIR}/find_usr_typel.txt"
userInterrupt "find /usr -type f -follow > ${RESULT_DIR}/find_usr-typef-follow.txt"
find /usr -type f -follow > "${RESULT_DIR}/find_usr-typef-follow.txt"

userInterrupt "find /bin -type l > ${RESULT_DIR}/find_bin-typel.txt"
find /bin -type l > "${RESULT_DIR}/find_bin-typel.txt"
userInterrupt "find /bin -type f -follow > ${RESULT_DIR}/find_bin-typef-follow.txt"
find /bin -type f -follow > "${RESULT_DIR}/find_bin-typef-follow.txt"

userInterrupt "find /sbin -type l > ${RESULT_DIR}/find_sbin-typel.txt"
find /sbin -type l > "${RESULT_DIR}/find_sbin-typel.txt"
userInterrupt "find /sbin -type f -follow > ${RESULT_DIR}/find_sbin-typef-follow.txt"
find /sbin -type f -follow > "${RESULT_DIR}/find_sbin-typef-follow.txt"

#***********************#回収リスト作成

userInterrupt "mkdir -p ${TAR_DIR}"
mkdir -p "${TAR_DIR}"

find /home -type f -name '.*' | sed 's/^\///g' >> "${TAR_LIST}"
find /var/log/httpd -type f -mtime -2 | sed 's/^\///g' >> "${TAR_LIST}"
find /var/log/message* -type f -mtime -2 | sed 's/^\///g' >> "${TAR_LIST}"
find /var/log/yum.* -type f | sed 's/^\///g' >> "${TAR_LIST}"
find /etc/init.d/ -type f | sed 's/^\///g' >> "${TAR_LIST}"
find $pgdirLog -type f | sed 's/^\///g' >> "${TAR_LIST}"
find $pgdir -type f -name '*.conf' | sed 's/^\///g' >> "${TAR_LIST}"

userInterrupt "$(cat ${TAR_LIST})"
tar zcvf "${TAR_FILE}" -C / -T "${TAR_LIST}"

exit 0


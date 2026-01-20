#!/bin/bash

DB_HOST="db03.c1i64gi0k41z.ap-northeast-2.rds.amazonaws.com"
DB_NAME="postgres"
DB_USER="admin01"
DB_PASS="kjs202512"     # ✅ 추가

AWS="/usr/local/bin/aws"
SENDMAIL="/home/ec2-user/bin/sendmail-file"
LOG_DIR="/home/ec2-user/batch/log"
LOG_FILE="${LOG_DIR}/db-stop.log"

MAX_LOOP=3         # 5분 × 12 = 60분
SLEEP_SEC=300       # 5분= 300

export PGPASSWORD="${DB_PASS}"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" > "${LOG_FILE}"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "${LOG_FILE}"
}

for ((i=1; i<=MAX_LOOP; i++)); do
    log "DB Connect "
   
    CNT=$(psql "host=${DB_HOST} user=${DB_USER} dbname=${DB_NAME} connect_timeout=30" \
    -t -A -c "select count(*) from alog.tbatch where end_dt is null;" 2>/dev/null | xargs)

    log "check ${i}/${MAX_LOOP} : running batch count = '${CNT}'"

    # ① CNT 값이 없을 경우 → 종료
    if [ -z "${CNT}" ]; then
        log "CNT is empty. exit."
	log "-=Complete=-"
        # ${SENDMAIL} db03-not-connect "${LOG_FILE}"
        unset PGPASSWORD
        exit 0
    fi

    # ② CNT == 1 → RDS stop 후 종료
    if [ "${CNT}" -eq 0 ] 2>/dev/null; then
        log "batch count is 1. stopping RDS."
        ${AWS} rds stop-db-instance --db-instance-identifier db03 >> "${LOG_FILE}" 2>&1
        log "Stop DB Execute. -=Complete=-"
	${SENDMAIL} db03-stop-Execute "${LOG_FILE}"
        unset PGPASSWORD
        exit 0
    fi

    # ③ CNT != 1 → 대기 후 재실행
    log "CNT != 1 (CNT=${CNT}). waiting..."
    ${SENDMAIL} db03-not-stop "${LOG_FILE}"
    sleep "${SLEEP_SEC}"

    if [ "${i}" -eq "${MAX_LOOP}" ]; then
        log "max loop reached. finish. Error "
	${SENDMAIL} db03-not-stop-MAX-LOOP "${LOG_FILE}"
        unset PGPASSWORD
        exit 0
    fi
done


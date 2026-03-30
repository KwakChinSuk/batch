#!/bin/bash

# 기본 설정
APP_NAME="${1:-alog-devtest}"
LOG_DIR="/home/ec2-user/batch/log"
BATCH_DIR="/home/ec2-user/batch"  # BATCH_DIR 경로 정의
PYTHON="/usr/bin/python3"
SENDMAIL="/home/ec2-user/bin/sendmail-file"
BASE_DIR="/home/ec2-user/alog/${APP_NAME}"

# 디렉토리 이동
cd "${BASE_DIR}" || exit 1

# GA 데이터 처리 실행
${PYTHON} alog_ga_app/ga_to_db.py INIT,-2 > "${LOG_DIR}/ga-INIT-${APP_NAME}.log" 2>&1
${PYTHON} alog_ga_app/ga_to_db.py -2 Y > "${LOG_DIR}/ga-${APP_NAME}.log" 2>&1

# 권한 설정
chown -R ec2-user:ec2-user "${BASE_DIR}"

# 메일 발송
sleep 1
${SENDMAIL} "[${APP_NAME}]ga-complete" "${LOG_DIR}/ga-${APP_NAME}.log"



if [ "${APP_NAME}" == "alog-half" ]; then    
  sleep 30
  ${BATCH_DIR}/db-stop.sh    
fi




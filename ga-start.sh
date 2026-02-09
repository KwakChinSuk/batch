#!/bin/bash

APP_NAME="${1:-alog-devtest}" 
BASE_DIR="/home/ec2-user/alog/${APP_NAME}"
LOG_DIR="/home/ec2-user/batch/log"
PYTHON="/usr/bin/python3"
SENDMAIL="/home/ec2-user/bin/sendmail-file"

cd "${BASE_DIR}" || exit 1

${PYTHON} alog_ga_app/ga_to_db.py INIT,-2  > "${LOG_DIR}/ga-INIT-${APP_NAME}.log" 2>&1

${PYTHON} alog_ga_app/ga_to_db.py -2  > "${LOG_DIR}/ga-${APP_NAME}.log" 2>&1

chown -R ec2-user:ec2-user "${BASE_DIR}"

sleep 3
#${SENDMAIL} ga-complete[${APP_NAME}]  ${LOG_DIR}/ga-${APP_NAME}.log


# 1. APP_NAME에 따라 URL 설정
case "${APP_NAME}" in
    "alog-half")
        TARGET_URL="https://ga.halfclub.com"
        ;;
    "alog-bori")
        TARGET_URL="https://ga.boribori.co.kr"
        ;;
    "alog-test")
        TARGET_URL="http://alog-test.alog.ai.kr"
        ;;
    *)
        echo "Error: Defined APP_NAME not found (Current: ${APP_NAME})"
        ;;
esac

sleep 1
# 설정된 ${TARGET_URL} 변수를 사용하여 curl 요청
/usr/bin/curl -f -s -S "${TARGET_URL}?pbatchcode=alog-api@cskwak-152504.iam.gserviceaccount.com" > /home/ec2-user/batch/www-check-log/ga-complete-${APP_NAME}.log 2>&1

sleep 1
${SENDMAIL} [${APP_NAME}]http-check /home/ec2-user/batch/www-check-log/ga-complete-${APP_NAME}.log



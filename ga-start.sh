#!/bin/bash

LOG_DIR="/home/ec2-user/batch/log"
PYTHON="/usr/bin/python3"
SENDMAIL="/home/ec2-user/bin/sendmail-file"

APP_NAME="alog-bori"
BASE_DIR="/home/ec2-user/alog/${APP_NAME}"

cd "${BASE_DIR}" || exit 1

${PYTHON} alog_ga_app/ga_to_db.py INIT,-2 > "${LOG_DIR}/ga-INIT-${APP_NAME}.log" 2>&1

${PYTHON} alog_ga_app/ga_to_db.py -2 Y  > "${LOG_DIR}/ga-${APP_NAME}.log" 2>&1

chown -R ec2-user:ec2-user "${BASE_DIR}"

sleep 1
${SENDMAIL} [${APP_NAME}]ga-complete ${LOG_DIR}/ga-${APP_NAME}.log

APP_NAME="alog-half"
BASE_DIR="/home/ec2-user/alog/${APP_NAME}"

cd "${BASE_DIR}" || exit 1

${PYTHON} alog_ga_app/ga_to_db.py INIT,-2 > "${LOG_DIR}/ga-INIT-${APP_NAME}.log" 2>&1

${PYTHON} alog_ga_app/ga_to_db.py -2 Y  > "${LOG_DIR}/ga-${APP_NAME}.log" 2>&1

chown -R ec2-user:ec2-user "${BASE_DIR}"

sleep 1
${SENDMAIL} [${APP_NAME}]ga-complete ${LOG_DIR}/ga-${APP_NAME}.log


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


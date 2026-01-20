#!/bin/bash

APP_NAME="${1:-alog-bori}" 
BASE_DIR="/home/ec2-user/alog/${APP_NAME}"
LOG_DIR="/home/ec2-user/batch/log"
PYTHON="/usr/bin/python3"
SENDMAIL="/home/ec2-user/bin/sendmail-file"

cd "${BASE_DIR}" || exit 1

${PYTHON} alog_ga_app/ga_to_db.py DataDelete  > "${LOG_DIR}/ga-DataDelete-${APP_NAME}.log" 2>&1 &



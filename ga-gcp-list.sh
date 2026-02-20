#!/bin/bash

BASE_DIR="/home/ec2-user/alog/alog-bori"
PYTHON="/usr/bin/python3"

cd "${BASE_DIR}" || exit 1

${PYTHON} alog_ga_app/gcp_list.py > "/home/ec2-user/batch/log/ga-gcp-list.log" 2>&1



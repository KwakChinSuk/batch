#!/bin/bash

# 로그 파일 경로 (기존 로그 폴더 활용)
SENDMAIL="/home/ec2-user/bin/sendmail"
LOG_FILE="/home/ec2-user/batch/log/cpu_monitor.log"
DATE=$(date "+%Y-%m-%d %H:%M:%S")


# CPU 점유율이 50.0% 이상인 프로세스 추출 (헤더 제외)
# ps -eo: pid(PID), pcpu(CPU%), args(명령어)
high_cpu_procs=$(ps -eo pid,pcpu,args --sort=-pcpu | awk '$2 >= 50.0 {print $0}')

if [ ! -z "$high_cpu_procs" ]; then
    echo "--------------------------------------------------" >> $LOG_FILE
    echo "[$DATE] High CPU Usage Detected (Over 50%)" >> $LOG_FILE
    echo "  PID  %CPU  COMMAND" >> $LOG_FILE
    echo "$high_cpu_procs" >> $LOG_FIiLE
    ${SENDMAIL} "$high_cpu_procs"
fi


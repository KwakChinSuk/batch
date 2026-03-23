#!/bin/bash

# 경로 설정
SENDMAIL="/home/ec2-user/bin/sendmail"
LOG_FILE="/home/ec2-user/batch/log/cpu_monitor.txt"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

# 1. ps 결과에서 헤더를 제외하고(NR>1), 2번째 필드가 50 이상인 것만 추출
high_cpu_procs=$(ps -eo pid,pcpu,args --sort=-pcpu | awk 'NR>1 && $2 >= 50.0 {print $0}')

# 2. 결과가 비어있지 않은 경우에만 실행
if [ -n "$high_cpu_procs" ]; then
    echo "--------------------------------------------------" >> "$LOG_FILE"
    echo "[$DATE] High CPU Usage Detected (Over 50%)" >> "$LOG_FILE"
    echo "  PID  %CPU  COMMAND" >> "$LOG_FILE"
    echo "$high_cpu_procs" >> "$LOG_FILE"  # 오타 수정 완료
    
    # 메일 발송 (필요 시 제목 추가 권장)
    ${SENDMAIL} "Subject: High CPU Alert\n\n$high_cpu_procs"
fi


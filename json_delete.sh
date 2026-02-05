#!/bin/bash

# 1. 파라미터 체크 (입력이 없으면 종료)
if [ -z "$1" ]; then
    echo "사용법: $0 [서비스명]"
    echo "예시: $0 alog-bori"
    exit 1
fi

SERVICE_NAME=$1
TARGET_DIR="/home/ec2-user/alog/$SERVICE_NAME/json"
# 로그 파일명을 서비스명에 따라 가변적으로 변경
LOG_FILE="/home/ec2-user/batch/log/json-delete-$SERVICE_NAME.log"


# 대상 디렉토리가 존재하는지 확인
if [ ! -d "$TARGET_DIR" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 오류: 경로를 찾을 수 없음 ($TARGET_DIR)" >> "$LOG_FILE"
    exit 1
fi

# 100일 전 날짜 구하기
THRESHOLD_DATE=$(date -d "100 days ago" +%Y%m%d)

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$SERVICE_NAME] 100일 경과 폴더 정리 시작 (기준일: $THRESHOLD_DATE)" >> "$LOG_FILE"

# 날짜 형식(YYYY-MM-DD)으로 된 폴더 리스트 반복
for dir_path in "$TARGET_DIR"/20[0-9][0-9]-[0-1][0-9]-[0-3][0-9]; do
    if [ -d "$dir_path" ]; then
        dir_name=$(basename "$dir_path")
        
        # 하이픈 제거하여 숫자 비교
        clean_name=${dir_name//-/}
        
        if [ "$clean_name" -lt "$THRESHOLD_DATE" ]; then
            echo "삭제 실행: $dir_path" >> "$LOG_FILE"
            # 실제 삭제를 원하시면 아래 rm 명령어의 주석(#)을 제거하세요
            rm -rf "$dir_path"
        fi
    fi
done

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$SERVICE_NAME] 정리 완료." >> "$LOG_FILE"
echo "--------------------------------------------------" >> "$LOG_FILE"

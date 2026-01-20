#!/bin/bash

#BASE_DIR="/home/ec2-user/alog/alog-half/json"
BASE_DIR="$1"
REFERENCE_DATE=$(date +%Y-%m-%d)   # 오늘 날짜
DAYS_BEFORE=$2

# 오늘로부터 33일 이전 날짜 계산
CUTOFF_DATE=$(date -d "$REFERENCE_DATE - $DAYS_BEFORE days" +%Y-%m-%d)
echo "삭제 기준일: $CUTOFF_DATE 이전 폴더 삭제 시작..."

# 기준일 이전 폴더 삭제
for dir in "$BASE_DIR"/*; do
  [ -d "$dir" ] || continue

  folder_name=$(basename "$dir")

  if [[ "$folder_name" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    if [[ "$folder_name" < "$CUTOFF_DATE" ]]; then
      echo "삭제 중: $dir"
      rm -rf "$dir"
    fi
  fi
done

echo "✅ 완료: $CUTOFF_DATE 이전의 날짜 폴더 삭제 완료."


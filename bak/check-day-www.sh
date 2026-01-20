#!/bin/bash

# 사용법 체크
if [ $# -ne 3 ]; then
  echo "Usage: $0 <start-date> <end-date> <host>"
  echo "Example: $0 2025-12-01 2026-01-06 half.alog.ai.kr"
  exit 1
fi

start="$1"
end="$2"
host="$3"

# 날짜 유효성 간단 체크
date -d "$start" >/dev/null 2>&1 || { echo "Invalid start date"; exit 1; }
date -d "$end"   >/dev/null 2>&1 || { echo "Invalid end date"; exit 1; }

d="$start"
while [ "$d" != "$(date -I -d "$end + 1 day")" ]; do
  ymd="${d//-/}"
  logfile="$host-$ymd.log"

  curl -sS \
    "https://$host/?pdevice=a&pday=$d&pbatchcode=alog-api@cskwak-152504.iam.gserviceaccount.com" \
    > "$logfile"

  echo "$logfile"

  # -=Complete=- 있으면 삭제
  if grep -q "\-=Complete=-" "$logfile"; then 	  
    rm -f "$logfile"
    echo "  OK delete $logfile"
  fi

  d=$(date -I -d "$d + 1 day")
done


#!/usr/bin/env bash
set -euo pipefail

TOPIC_ARN="arn:aws:sns:ap-northeast-2:123456789012:ec2-disk-report"  # ← 본인 SNS TopicArn
HOST="$(hostname)"
WHEN="$(date '+%Y-%m-%d %H:%M:%S %Z')"

# 주요 FS만 보기: tmpfs/devtmpfs/squashfs/overlay 제외
REPORT="$(df -h \
  -x tmpfs -x devtmpfs -x squashfs -x overlay \
  --output=source,size,used,avail,pcent | sed '1d')"

# 첫 번째 pcent 값 추출 (예: "45%")
FIRST_PCENT="$(echo "$REPORT" | awk 'NR==1 {print $5}')"

MSG=$(
  cat <<EOF
[EC2 HDD $FIRST_PCENT / 90%]
Host: ${HOST}
Time: ${WHEN}

Filesystem           Size  Used  Avail  Use%
$REPORT
EOF
)

/usr/local/bin/aws ses send-email --from alog@alog.ai.kr --destination ToAddresses=kjs819@gmail.com --message "Subject={Data='[w01] HDD ($FIRST_PCENT)  ',Charset='UTF-8'},Body={Text={Data='${MSG}',Charset='UTF-8'}}"


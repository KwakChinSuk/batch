#!/bin/bash
cd /home/ec2-user/batch

# 새로운 .sh 파일이 있으면 추가하고 실행 권한 부여
find . -name "*.sh" -exec git add --chmod=+x {} +

# 변경사항이 있는지 확인 후 커밋 (변경사항 없으면 건너뜀)
if ! git diff-index --quiet HEAD; then
    git commit -m "Auto-upload: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin main
fi

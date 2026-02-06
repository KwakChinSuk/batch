#!/bin/bash

# 1. 작업 디렉토리 이동
cd /home/ec2-user/batch || { echo "Directory not found"; exit 1; }

# 2. 실행 로그 시작 시간 기록 (선택 사항)
echo "Run at: $(date +'%Y-%m-%d %H:%M:%S')"

# 3. 새로운 .sh 파일 추가 및 권한 부여
# 이 과정에서 에러 발생 시 즉시 중단
find . -name "*.sh" -exec git add --chmod=+x {} + || { echo "Error: Failed to add files"; exit 1; }

# 4. 변경사항 확인 및 처리
if ! git diff-index --quiet HEAD; then
    # 커밋 실행
    if git commit -m "Auto-upload: $(date +'%Y-%m-%d %H:%M:%S')"; then
        # 푸시 실행
        if git push origin main; then
            echo "-=Complete=-"
        else
            echo "Error: git push failed"
            exit 1
        fi
    else
        echo "Error: git commit failed"
        exit 1
    fi
else
    # 변경사항이 없는 경우도 성공으로 간주하고 Complete 출력
    echo "No changes to commit. -=Complete=-"
fi

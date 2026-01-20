#!/usr/bin/env bash
set -euo pipefail

# ===============================
# RDS 접속 정보
# ===============================
RDS_HOST="db03.c1i64gi0k41z.ap-northeast-2.rds.amazonaws.com"
RDS_PORT="5432"
DB_USER="admin01"
DB_PASSWORD="kjs202512"     # ⚠️ 보안상 위험 – 요청에 따라 포함

# DB 목록 조회용 기본 DB
LIST_DB="postgres"

# ===============================
# 로컬 백업 디렉터리 (변경됨)
# ===============================
BACKUP_DIR="/home/ec2-user/batch/rds"
RETENTION_DAYS=30

mkdir -p "$BACKUP_DIR"

# 비밀번호 환경변수로 주입
export PGPASSWORD="$DB_PASSWORD"

TS="$(date +%Y%m%d_%H%M%S)"
RUN_DIR="${BACKUP_DIR}/run_${TS}"
mkdir -p "$RUN_DIR"

echo "[INFO] Backup directory: ${RUN_DIR}"
echo "[INFO] Fetching database list..."

# ===============================
# DB 목록 조회 (template / rdsadmin 제외)
# ===============================
DBS=$(psql -h "$RDS_HOST" -p "$RDS_PORT" -U "$DB_USER" -d "$LIST_DB" -Atc "
SELECT datname
FROM pg_database
WHERE datallowconn
  AND datistemplate = false
  AND datname <> 'rdsadmin'
ORDER BY datname;
")

echo "[INFO] Databases to backup:"
echo "$DBS" | sed 's/^/ - /'

# ===============================
# DB별 schema-only 백업
# ===============================
for DB_NAME in $DBS; do
  OUT_FILE="${RUN_DIR}/${DB_NAME}_schema_${TS}.sql.gz"
  echo "[INFO] Dump schema-only: ${DB_NAME}"

  pg_dump \
    -h "$RDS_HOST" -p "$RDS_PORT" \
    -U "$DB_USER" -d "$DB_NAME" \
    --schema-only \
    --no-owner --no-acl \
    | gzip -c > "$OUT_FILE"
done

# ===============================
# 보관 정책 (run_* 디렉터리 단위)
# ===============================
find "$BACKUP_DIR" -maxdepth 1 -type d -name "run_*" -mtime +"$RETENTION_DAYS" -exec rm -rf {} \;

echo "[INFO] Backup completed successfully"
echo "[INFO] Output location: ${RUN_DIR}"


# ==============================
# 복원방법 
# =============================
# gunzip -c /home/ec2-user/batch/rds/run_YYYYMMDD_HHMMSS/postgres_schema_YYYYMMDD_HHMMSS.sql.gz \
# | psql -h db03.c1i64gi0k41z.ap-northeast-2.rds.amazonaws.com \
#        -U admin01 \
#        -d postgres
#

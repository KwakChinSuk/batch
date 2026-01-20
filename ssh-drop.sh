#i!/bin/bash

LOG_FILE="/home/ec2-user/batch/log/ssh_drop.log"
GROUP_ID="sg-0d6ab1531781f9bad"
REGION="ap-northeast-2"
KEYWORD="-auto-"

SENDMAIL="/home/ec2-user/bin/sendmail-file"

SUCCESS=true

echo "[$(date '+%Y-%m-%d %H:%M:%S')] === START === " > "${LOG_FILE}"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "${LOG_FILE}"
}

  RULE_IDS=$(/usr/local/bin/aws ec2 describe-security-group-rules \
    --region "$REGION" \
    --filters "Name=group-id,Values=$GROUP_ID" \
    --query "SecurityGroupRules[?(!IsEgress) && Description!=null && contains(Description, \`${KEYWORD}\`)].SecurityGroupRuleId" \
    --output text 2>/dev/null)

  if [[ $? -ne 0 ]]; then
    log "[ERROR] Failed to describe security group rules"
    SUCCESS=false
  fi

  if [[ "$SUCCESS" == true && -n "${RULE_IDS// }" ]]; then
    log "Target rule IDs: $RULE_IDS"

    /usr/local/bin/aws ec2 revoke-security-group-ingress \
      --region "$REGION" \
      --group-id "$GROUP_ID" \
      --security-group-rule-ids $RULE_IDS

    if [[ $? -ne 0 ]]; then
      log "[ERROR] Failed to revoke security group rules"
      SUCCESS=false
      ${SENDMAIL} ssh-drop-Fail "${LOG_FILE}"
    else
      log "=== END ==="       
      log "-=Complete=-"
      ${SENDMAIL} ssh-drop-Execute "${LOG_FILE}"
    fi

  elif [[ "$SUCCESS" == true ]]; then
    log "No inbound rules found with description containing '$KEYWORD'."
    log "-=Complete=-"
    # ${SENDMAIL} ssh-drop-check-OK "${LOG_FILE}"
  fi





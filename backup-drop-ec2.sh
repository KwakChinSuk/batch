/usr/local/bin/aws ec2 describe-snapshots --owner-ids self \
  --query "Snapshots[?contains(Description, 'w01 full backup')].SnapshotId" \
  --output text | tr '\t' '\n' | \
  xargs -r -I {} aws ec2 delete-snapshot --snapshot-id {}



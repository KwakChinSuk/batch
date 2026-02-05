
/usr/local/bin/aws rds describe-events --source-type db-instance --source-identifier db03 --duration 60 --region ap-northeast-2 --query "reverse(sort_by(Events,&Date))[].{Time:Date,Level:Severity,Msg:Message}" --output table > /home/ec2-user/batch/log/db-log.log 2>&1

echo "-=Complete=-" >> /home/ec2-user/batch/log/db-log.log

/home/ec2-user/bin/sendmail-file db03-start-checklog /home/ec2-user/batch/log/db-log.log


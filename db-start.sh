
/usr/local/bin/aws rds start-db-instance --db-instance-identifier db03 > /home/ec2-user/batch/log/db-start.log 2>&1

echo "-=Complete=-" >> /home/ec2-user/batch/log/db-start.log

/home/ec2-user/bin/sendmail-file db03-start /home/ec2-user/batch/log/db-start.log

